# Laszlo Jakab
# Mar 2018

# Setup ------------------------------------------------------------------------

# load packages
library(compsizer)


# Load Data --------------------------------------------------------------------

# list of included funds
funds.in.sample <- readRDS("data/funds_included/funds_in_sample.Rds")

# portfolio weights (keep only mkt-adjusted)
pw <- readRDS("data/portfolio/portfolio_weights.Rds")[, w := NULL]

# fund size
size <- readRDS("data/clean/fund_level_crsp.Rds")[, .(wficn, date, tna)]

# total market cap of CRSP universe
total.mktcap <- readRDS("data/clean/total_mktcap.Rds")[, .(date, totcap)]


# Prep Datasets ----------------------------------------------------------------

# keep only if fund meets sample criteria and period
pw <- pw[
  funds.in.sample, on = "wficn", nomatch = 0][
    "Mar 1980" <= date & date <= "Dec 2016"]
size <- size[
  funds.in.sample, on = "wficn", nomatch = 0][
    "Mar 1980" <= date & date <= "Dec 2016"]

# normalize tna by total mkt cap
size <- size[
  total.mktcap, on = "date", nomatch = 0][
    , fund.size := tna * 10^6 / totcap][
      , c("tna", "totcap") := NULL]


# Generate CompetitorSize ------------------------------------------------------

# use purpose-built function from compsizer package
cs.dt <- GenCompSize(pw, size, w.var = "w.adj")
cs.dt[, `:=` (wficn = as.numeric(wficn), date = as.yearmon(date))]
setkey(cs.dt, wficn, date)
saveRDS(cs.dt, "data/competitor_size/competitor_size.Rds")
