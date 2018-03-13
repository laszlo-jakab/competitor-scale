# Laszlo Jakab
# Mar 3, 2018

# Setup ------------------------------------------------------------------------

# directories
pw.dir     <- "data/portfolio"
data.dir   <- "data/clean"
sample.dir <- "data/funds_included"
out.dir    <- "data/competitor_size"
fn.dir     <- "R/functions"

# source functions
source(file.path(fn.dir, "CosSim_Fn.R"))


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
  "Mar 1980" <= date & date <= "Dec 2016"][
  # keep only quarter-end months
  month(date) %in% c(3, 6, 9, 12)]

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


# Re-Format to Matrix ----------------------------------------------------------

DtToMatrix <- function(dt) {

  # portfolio weights in wide form data.table
  w <- dcast(dt[[1]], permno ~ wficn, value.var = "w.adj", fill = 0)
  # portfolio weight matrix
  w <- as.matrix(w[, 2:dim(w)[2]])

  # cosine similarities, excluding own
  cos.sim <- CosSim(w)
  diag(cos.sim) <- 0

  # fund size matrix
  fs <- as.matrix(dt[[2]]$fund.size)
  rownames(fs) <- dt[[2]]$wficn

  # output
  out <- list(cos.sim, fs, dt[[3]])
  return(out)
}

csl.mat <- lapply(csl, DtToMatrix)


# Delta (log) CompetitorSize ---------------------------------------------------

# perform the calculations month-by-month
# loop through time and get ln_DCS
out.mat <- NULL
cs.mat <- for (i in (2:length(csl.mat))) {

  # last period's similarity, fund size
  cos.sim.last   <- csl.mat[[i-1]][[1]]
  fund.size.last <- csl.mat[[i-1]][[2]]

  # last period competitor size
  if (!identical(rownames(cos.sim.last), rownames(fund.size.last))) {
    stop("Last period funds do not match")
  }
  cs.last <- cos.sim.last %*% fund.size.last

  # this period's fund size
  fund.size.this <- csl.mat[[i]][[2]]

  # intersect last period's similarity and this period's fund size
  wficns.this <- intersect(
    rownames(cos.sim.last), rownames(fund.size.this))

  # funds that are both in last quarter's cosine similarity and
  # this quarter's fund size
  cos.sim.this   <- cos.sim.last[wficns.this, wficns.this]
  fund.size.this <- fund.size.this[wficns.this, , drop = FALSE]

  # competitor size using this period's fund size
  if (!identical(rownames(cos.sim.this), rownames(fund.size.this))) {
    stop("This period funds do not match")
  }
  cs.this <- cos.sim.this %*% fund.size.this

  # keep only if observe fund size at both t-1 and t
  wficns.both <- intersect(rownames(cs.last), rownames(cs.this))
  cs.last <- cs.last[wficns.both, , drop = FALSE]
  cs.this <- cs.this[wficns.both, , drop = FALSE]
  if (!identical(rownames(cs.last), rownames(cs.this))) {
    stop("Funds must match for calculating Delta CS")
  }
  cs_delta_log <- log(cs.this)-log(cs.last)

  # output
  out.mat <- rbind(out.mat,
    cbind(cs_delta_log, year(csl.mat[[i]][[3]]), month(csl.mat[[i]][[3]])))
}


# convert output to data.table
dcs.dt <- data.table(out.mat, keep.rownames = TRUE)
setnames(dcs.dt, c("wficn", "dln.comp.size", "year", "month"))
dcs.dt[
  # convert wficn to numeric
  , wficn := as.numeric(wficn)][
  # date variable corresponding to year and month
  , date := as.yearmon(paste0(year, "-", month))][
  # drop year and month
  , c("year", "month") := NULL]
# fix column order
setcolorder(dcs.dt, c("wficn", "date", "dln.comp.size"))
# sort and save
setkey(dcs.dt, wficn, date)
saveRDS(dcs.dt, file.path(out.dir, "dln_competitor_size.Rds"))
