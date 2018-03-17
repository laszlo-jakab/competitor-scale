# Laszlo Jakab
# Feb 27, 2018

# Setup ------------------------------------------------------------------------

# load packages
pkgs <- c("foreach",
          "doParallel")
lapply(pkgs, library, character.only = TRUE)

# directories
pw.dir     <- "data/portfolio"
data.dir   <- "data/clean"
sample.dir <- "data/funds_included"
out.dir    <- "data/competitor_size"
fn.dir     <- "R/functions"

# source functions
source(file.path(fn.dir, "CosSim_Fn.R"))
source(file.path(fn.dir, "CompSize_Fn.R"))


# Load Data --------------------------------------------------------------------

# list of included funds
funds.in.sample <- readRDS(file.path(sample.dir, "funds_in_sample.Rds"))

# portfolio weights
pw <- readRDS(file.path(pw.dir, "portfolio_weights.Rds"))[
  , w := NULL]

# fund tna
fund.tna <- readRDS(file.path(data.dir, "fund_level_crsp.Rds"))[
  , .(wficn, date, tna)]

# total market cap of CRSP universe
total.mktcap <- readRDS(file.path(data.dir, "total_mktcap.Rds"))[
  , .(date, totcap)]


# Intersect Weights and Sizes --------------------------------------------------

# unique wficn-date pairs from portfolio weight dataset
pw.wficn.date <- unique(pw[, .(wficn, date)])
setkey(pw.wficn.date, wficn, date)
# unique wficn-date pairs common to both datasets
wficn.date <- fund.tna[, .(wficn, date)][
  # intersect with portfolio weight datasets
  pw.wficn.date, on = c("wficn", "date"), nomatch = 0][
  # restrict to funds meeting sample filters
  funds.in.sample, on = "wficn", nomatch = 0][
  # keep only Mar 1980 to Dec 2016
  "Mar 1980" <= date & date <= "Dec 2016"]

# fund size: keep only intersection, and normalize by total mkt cap
fund.tna <- fund.tna[
  # keep only if meets sample criteria
  wficn.date, on = c("wficn", "date"), nomatch = 0][
  # add in total mktcap
  total.mktcap, on = "date", nomatch = 0][
  # normalize by total market cap
  , fund.size := tna * 10^6 / totcap][
  # drop chaff
  , c("tna", "totcap") := NULL]

# portfolio weights: keep only intersection
setkey(pw, wficn, date)
pw <- pw[wficn.date, on = c("wficn", "date"), nomatch = 0]


# Split by Date ----------------------------------------------------------------

# sort by date
setkey(fund.tna, date, wficn)
setkey(pw, date, wficn, permno)
# split portfolio weight dataset by date and arrange in a list of data.tables
pwl <- split(pw, by = "date", keep.by = FALSE)
# split fund size dataset by date and arrange in a list of data.tables
ftl <- split(fund.tna, by = "date", keep.by = FALSE)
# list of dates
datel <- sort(unique(fund.tna$date))

# zip together the three lists (e.g. first element includes both weights
# and sizes for Mar 1980 as separate datasets, as well as the date as the
# third element)
csl <- Map(list, pwl, ftl, datel)

# clean up
rm(fund.tna, pw, pwl, ftl)


# CompetitorSize ---------------------------------------------------------------

# convenience function for transforming each piece of data in correct
# format for calculating cosine similarity and CompetitorSize.
# outputs a matrix of competitor size, year, and month, with
# row names identifying the fund's wficn.
MainFn <- function(dt) {

  # portfolio weights in wide form data.table
  w <- dcast(dt[[1]], permno ~ wficn, value.var = "w.adj", fill = 0)
  # portfolio weight matrix
  w <- as.matrix(w[, 2:dim(w)[2]])

  # fund size matrix
  fs <- as.matrix(dt[[2]]$fund.size)
  rownames(fs) <- dt[[2]]$wficn

  # cosine similarities
  cos.sim <- CosSim(w)

  # CompetitorSize
  cs <- CompSize(cos.sim, fs)

  # output a neat matrix
  out <- cbind(cs, year(dt[[3]]), month(dt[[3]]))
  return(out)
}

# setup parallel backend to use all but one of the cores
n.cores <- detectCores()
cl <- makeCluster(n.cores - 1)
#cl <- makeCluster(n.cores)
# register the cluster
registerDoParallel(cl)
# perform the calculations month-by-month
cs.mat <-
  foreach (i = csl,
    .packages = c("data.table", "zoo"),
    .combine = "rbind",
    .inorder = FALSE
  ) %dopar% MainFn(i)

# unlink cluster
stopCluster(cl)

# convert output to data.table
cs.dt <- data.table(cs.mat, keep.rownames = TRUE)
setnames(cs.dt, c("wficn", "comp.size", "year", "month"))
cs.dt[
  # convert wficn to numeric
  , wficn := as.numeric(wficn)][
  # date variable corresponding to year and month
  , date := as.yearmon(paste0(year, "-", month))][
  # drop year and month
  , c("year", "month") := NULL]

# sort and save
setkey(cs.dt, wficn, date)
saveRDS(cs.dt, file.path(out.dir, "competitor_size.Rds"))
