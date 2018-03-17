# Laszlo Jakab
# Mar 7, 2018

# Setup ------------------------------------------------------------------------

# packages
pkgs <- c("lfe",
          "broom")
lapply(pkgs, library, character.only = TRUE)

# directories
combined.dir <- "data/combined"
scandal.dir  <- "data/scandal"
pw.dir       <- "data/portfolio"
fn.dir       <- "R/functions"
data.dir     <- "data/clean"
sample.dir   <- "data/funds_included"

# source functions
source(file.path(fn.dir, "CosSim_Fn.R"))
source(file.path(fn.dir, "CompSize_Fn.R"))


# Load Data ------------------------------------------------------------

# combined dataset
combined <- readRDS("data/combined/combined.Rds")

# scandal categorization and news date
scandal.wficns <- readRDS("data/scandal/scandal_wficns_2018-Mar-06.Rds")

# portfolio weights
pw <- readRDS("data/portfolio/portfolio_weights.Rds")[
  date == "Aug 2003"][
  , c("w", "date") := NULL]


# Prep Scandal Data ------------------------------------------------------------

# keep two years pre- and post- scandal period
scandal.dt <- combined["Sep 2001" <= date & date < "Nov 2006"]

# keep only if fund is in sample as of Aug 2003
scandal.dt <- scandal.dt[
  , is.aug2003 := date == "Aug 2003"][
  , exists.aug2003 := max(is.aug2003), by = wficn][
  exists.aug2003 == 1][
  , c("is.aug2003", "exists.aug2003") := NULL]

# scandal status as of Aug 2003
scandal.dt <- scandal.dt[scandal.wficns, on = "wficn", nomatch = 0][
  , news.month := as.yearmon(news.date)][
  , tau := round((date - news.month) * 12) + 1][
  tau <= 0, tau := NA]


# Estimate Flow Regression Model -----------------------------------------------

# grouping funds according to scandal cohort X month since scandal
scandal.dt <- scandal.dt[
  , news.month.X.tau := paste0(news.month, "_X_", tau)][
  grepl("NA", news.month.X.tau), news.month.X.tau := NA]

# generate indicator variables for cohort X month groups
# (omitting non-scandal funds and months)
cohort.X.month <- scandal.dt[, unique(news.month.X.tau)]
cohort.X.month <- cohort.X.month[!is.na(cohort.X.month)]
for (cm in cohort.X.month) {
  # remove whitespace from variable names
  vn <- gsub("\\s+", "", cm)
  # dummy variable for each non-missing cohort X month
  scandal.dt[, eval(vn)
    := ifelse(!is.na(news.month.X.tau) & news.month.X.tau == cm, 1, 0)]
}

# regression model:
# flows on cohort X month dummies; include fund and date FE
# since i am only interested in point estimates, standard errors are not adjusted
reg.model <- paste("flow ~ ", paste(gsub("\\s+", "", cohort.X.month),
  collapse = "+"), "| wficn + date | 0 | 0", collapse = "")
# estimate model
treat.reg <- felm(as.formula(reg.model), scandal.dt)


# Cumulative Abnormal Flows ----------------------------------------------------

# collect coefficients
treat.coefs <- tidy(treat.reg)
setDT(treat.coefs)
# tidy up
treat.coefs[
  # scandal cohort
  , news.month := as.yearmon(
      paste(substr(term, 1, 3), substr(term, 4, 7)))][
  # months since scandal
  , tau := as.numeric(unlist(tstrsplit(term, "_X_")[2]))][
  # effective date for coefficient
  , date := news.month + (tau - 1) / 12]

# cumulative abnormal flows
setkey(treat.coefs, news.month, date)
treat.coefs[, f.hat := cumprod(1 + estimate) - 1, by = news.month]

# multiply cumulative abnormal flows by fund size as of Aug 2003
# to obtain expected size loss
fund.size.aug03 <- scandal.dt[
  date == "Aug 2003" & !is.na(news.month), .(wficn, news.month, fund.size)]
size.loss <- treat.coefs[fund.size.aug03, on = "news.month", allow.cartesian = TRUE]
size.loss[, e.size.loss := f.hat * fund.size]
# sort and save for future reference
setkey(size.loss, wficn, date)
saveRDS(size.loss, file.path(scandal.dir, "expected_size_loss.Rds"))


# Cosine Similarities (Aug 2003) ---------------------------------------------

# portfolio weights in wide form data.table
w <- dcast(pw, permno ~ wficn, value.var = "w.adj", fill = 0)

# portfolio weight matrix
w <- as.matrix(w[, 2:dim(w)[2]])

# cosine similarities
cos.sim <- CosSim(w)


# Split by Date ----------------------------------------------------------------

# expected size loss of affected funds
setkey(size.loss, date, wficn)
sll <- split(size.loss[, .(wficn, date, e.size.loss)], by = "date", keep.by = FALSE)

# list of unaffected funds (post- Aug 2003) by date
unaffected.funds <- scandal.dt[
  date > "Aug 2003" & scandal.fund == 0, .(wficn, date)]
setkey(unaffected.funds, date, wficn)
ual <- split(unaffected.funds, by = "date", keep.by = FALSE)

# list of dates
datel <- sort(unique(size.loss$date))

# zip together the three lists
# (e.g. first element includes both weights and expected size loss for Sep 2003
# as separate datasets, as well as the date as the third element)
scofl <- Map(list, sll, ual, datel)

# clean up the workspace
rm(list=setdiff(ls(), c("scandal.dir", "scofl", "cos.sim")))


# ScandalOutflow --------------------------------------------------------------

MainFn <- function(l) {

  # affected funds
  af <- paste(intersect(colnames(cos.sim), l[[1]]$wficn))

  # unaffected funds
  uf <- paste(intersect(rownames(cos.sim), l[[2]]$wficn))

  # expected size loss matrix
  fs <- as.matrix(l[[1]]$e.size.loss)
  rownames(fs) <- l[[1]]$wficn
  fs <- fs[paste(af), , drop = FALSE]

  # cosine similarity matrix
  this.cos.sim <- cos.sim[uf, af]

  # ScandalOutFlow
  if (any(colnames(this.cos.sim) != rownames(fs))) stop("Fund names do not match")
  scandal.outflow <- (-1) * this.cos.sim %*% fs

  # output a neat matrix
  out <- data.table(cbind(
    scandal.outflow, year(l[[3]]), month(l[[3]])), keep.rownames = TRUE)
  return(out)
}

# run for each month
scandal.outflow.dt <- rbindlist(lapply(scofl, MainFn))


# Tidy Output -----------------------------------------------------------------

# set names
setnames(scandal.outflow.dt, c("wficn", "scandal.outflow", "year", "month"))
# standardize wficn format
scandal.outflow.dt[, wficn := as.numeric(wficn)]
# get date identifier
scandal.outflow.dt[, date := as.yearmon(paste(year, month, sep = "-"))][
  , c("year", "month") := NULL]
setcolorder(scandal.outflow.dt, c("wficn", "date", "scandal.outflow"))

# sort and save
setkey(scandal.outflow.dt, wficn, date)
saveRDS(scandal.outflow.dt, "data/scandal/scandal_outflow.Rds")
