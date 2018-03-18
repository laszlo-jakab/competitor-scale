# Laszlo Jakab
# Mar 6, 2018

# Setup ------------------------------------------------------------------------

# source functions
source("R/functions/CosSim_Fn.R")
source("R/functions/CompSize_Fn.R")


# Load Data --------------------------------------------------------------------

# scandal categorization
scandal.wficns <- readRDS("data/scandal/scandal_wficns_2018-Mar-06.Rds")[
  , .(wficn, scandal.fund)]

# list of included funds
funds.in.sample <- readRDS("data/funds_included/funds_in_sample.Rds")

# portfolio weights
pw <- readRDS("data/portfolio/portfolio_weights.Rds")[
  date == "Aug 2003"][
  , c("date", "w") := NULL]

# fund tna
fund.tna <- readRDS("data/clean/fund_level_crsp.Rds")[
  date == "Aug 2003"][
  , .(wficn, tna)]

# total market cap of CRSP universe
total.mktcap <- readRDS("data/clean/total_mktcap.Rds")[
  date == "Aug 2003"][
  , totcap]


# Intersect Weights and Restrict Sample ----------------------------------------

# intersect wficns from portfolio weight and fund size datasets
common.wficns <- intersect(pw[, unique(wficn)], fund.tna[, wficn])
# restrict to funds that meet sample restrictions
common.wficns <- intersect(common.wficns, funds.in.sample[, wficn])

# fund size: keep only intersection, add in scandal status,
# and normalize tna by total mkt cap
fund.tna <- fund.tna[
  # keep only if meets sample criteria
  wficn %in% common.wficns][
  scandal.wficns, on = "wficn", nomatch = 0][
  # normalize by total market cap
  , fund.size := tna * 10^6 / total.mktcap][
  # drop chaff
  , tna := NULL]
setkey(fund.tna, wficn)

# portfolio weights: keep only intersection
pw <- pw[wficn %in% common.wficns]


# ScandalExposure --------------------------------------------------------------

# portfolio weights in wide form data.table
w <- dcast(pw, permno ~ wficn, value.var = "w.adj", fill = 0)
# portfolio weight matrix
w <- as.matrix(w[, 2:dim(w)[2]])

# fund size matrix
fs <- as.matrix(fund.tna$fund.size)
rownames(fs) <- fund.tna$wficn

# fund size matrix, setting non-scandal fund size to zero
fs.scandal <- as.matrix(fund.tna$fund.size * fund.tna$scandal.fund)
rownames(fs.scandal) <- fund.tna$wficn

# cosine similarities
cos.sim <- CosSim(w)

# CompetitorSize
cs <- CompSize(cos.sim, fs)

# CompetitorSize due to scandal funds
cs.scandal <- CompSize(cos.sim, fs.scandal)

# ScandalExposure: fraction of CompetitorSize due to scandal funds
scandal.exposure <- cs.scandal / cs


# Tidy Dataset -----------------------------------------------------------------

# convert to data.table
scandal.exposure <- data.table(scandal.exposure, keep.rownames = TRUE)
setnames(scandal.exposure, c("wficn", "scandal.exposure"))
# keep only non-scandal funds
scandal.exposure <- scandal.exposure[
  , wficn := as.numeric(wficn)][
  scandal.wficns, on = "wficn", nomatch = 0][
  scandal.fund == 0][
  , scandal.fund := NULL]
# sort and save
setkey(scandal.exposure, wficn)
saveRDS(scandal.exposure, "data/scandal/scandal_exposure.Rds")
