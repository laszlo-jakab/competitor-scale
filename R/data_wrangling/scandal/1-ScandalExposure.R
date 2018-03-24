# Laszlo Jakab
# Mar 2018

# Setup ------------------------------------------------------------------------

library(compsizer)

# scandal categorization
scandal.wficns <- readRDS("data/scandal/scandal_wficns_2018-Mar-06.Rds")[
  , .(wficn, scandal.fund)]

# list of included funds
funds.in.sample <- readRDS("data/funds_included/funds_in_sample.Rds")

# portfolio weights
pw <- readRDS("data/portfolio/portfolio_weights.Rds")[
  date == "Aug 2003", .(wficn, date, permno, w.adj)]

# fund tna
size <- readRDS("data/clean/fund_level_crsp.Rds")[
  date == "Aug 2003", .(wficn, date, tna)]

# total market cap of CRSP universe
total.mktcap <- readRDS("data/clean/total_mktcap.Rds")[
  date == "Aug 2003", totcap]


# Intersect Weights and Restrict Sample ----------------------------------------

# fund size: keep only if fund meets inclusion criteria, add in scandal status,
# and normalize tna by total mkt cap
size <- size[
  funds.in.sample, on = "wficn", nomatch = 0][
  scandal.wficns, on = "wficn", nomatch = 0][
  # exclude funds not included in the scandal
  , tna.tainted := scandal.fund * tna][
  # normalize (tainted) tna by total market cap
  , .(wficn, date,
      fund.size = tna * 10^6 / total.mktcap,
      fund.size.tainted = tna.tainted * 10^6 / total.mktcap)]


# ScandalExposure --------------------------------------------------------------

# CompetitorSize
cs <- GenCompSize(pw, size, w.var = "w.adj", size.var = "fund.size")

# CompetitorSize, exluding TNA of untainted funds
cs.tainted <- GenCompSize(pw, size, w.var="w.adj", size.var="fund.size.tainted")
setnames(cs.tainted, "comp.size", "comp.size.tainted")

# ScandalExposure: fraction of CompetitorSize due to tainted funds
scandal.exposure <- cs.tainted[
  cs, .(wficn = as.numeric(wficn),
        scandal.exposure = comp.size.tainted / comp.size)][
  # keep only funds not involved in the scandal
  scandal.wficns[scandal.fund == 0, .(wficn)], on = "wficn", nomatch = 0]

# sort and save
setkey(scandal.exposure, wficn)
saveRDS(scandal.exposure, "data/scandal/scandal_exposure.Rds")
