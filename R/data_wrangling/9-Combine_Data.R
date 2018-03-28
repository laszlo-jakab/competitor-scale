# Laszlo Jakab
# Mar 2018

# Load Datasets ----------------------------------------------------------------

# funds that pass filters
funds.in.sample <- readRDS("data/funds_included/funds_in_sample.Rds")

# fund-level info from crsp (returns, size, turnover, exp. ratio)
fund.crsp <- readRDS("data/clean/fund_level_crsp.Rds")
fund.crsp <- fund.crsp[funds.in.sample, nomatch = 0]

# factor-benchmarked returns; adjust date so it is a lead
ra.ret <- readRDS("data/benchmarked_returns/risk_adj_ret.Rds")
ra.ret <- ra.ret[funds.in.sample, nomatch = 0]
ra.ret[, date := date - 1 / 12]
setkey(ra.ret, wficn, date)

# competitor size
cs <- readRDS("data/competitor_size/competitor_size.Rds")

# portfolio groups
pg <- readRDS("data/portfolio/portfolio_grp.Rds")
pg <- pg[funds.in.sample, nomatch = 0]

# portfolio liquidity measures
pl <- readRDS("data/portfolio/portfolio_liquidity.Rds")
pl <- pl[funds.in.sample, nomatch = 0]

# active share
as <- readRDS("data/raw/petajisto_activeshare.Rds")
as <- as[funds.in.sample, nomatch = 0]

# total market cap of crsp universe
total.mktcap <- readRDS("data/clean/total_mktcap.Rds")

# wficn-report date pairs, matched to date
wficn.rdate.date <- readRDS("data/clean/wficn_rdate.Rds")[
  , date := rdate.mon][
  , d := pmin(6, round((shift(date, type = "lead") - date)*12), na.rm = TRUE)
    , by = wficn][
  rep(1:.N, d)][
  , d := NULL][
  , date := date + (seq_len(.N) - 1) / 12, by = .(wficn, date)]
setkey(wficn.rdate.date, wficn, date)
saveRDS(wficn.rdate.date, "data/clean/wficn_rdate_date.Rds")


# Prep Datasets ----------------------------------------------------------------

# fund level crsp data
fund.crsp <- fund.crsp[
  # keep only March 1980 to December 2016
  "Mar 1980" <= date & date <= "Dec 2016"][
  # total market cap
  total.mktcap[, .(date, totcap)], on = "date", nomatch = 0][
  # FundSize: TNA normalized by total market cap
  , fund.size := tna * 10^6 / totcap][
  # industry size: sum of FundSize
  , industry.size := sum(fund.size), by = date][
  , totcap := NULL][
  # winsorize turnover (function taken from "psych" package)
  , To := psych::winsor(turn_ratio, trim = .01)][
  # generate net (percent) flows
  , flow.raw := (tna - tna.l1 * (1 + r.net)) / tna.l1][
  # winsorized flow
  , flow := psych::winsor(flow.raw, trim = .01)]
setkey(fund.crsp, wficn, date)

# break out industry size for convenience
isize <- fund.crsp[, .(industry.size = sum(fund.size)), keyby = date]


# Combine Datasets -------------------------------------------------------------

# combine, keeping only intersection of datasets
combined <- fund.crsp[
  # add in competitor size
  cs, on = c("wficn", "date"), nomatch = 0][
  # portfolio liquidity vars
  pl, on = c("wficn", "date"), nomatch = 0][
  # portfolio groups
  pg, on = c("wficn", "date"), nomatch = 0][
  # risk adjusted returns (shifted one month
  ra.ret, on = c("wficn", "date"), nomatch = 0][
  # month X portfolio group
  , date.port.grp := paste0(date, "X", port.grp)]
# add in active share
combined <- as[combined, on = c("wficn", "date")]

# add in report dates
combined <- combined[wficn.rdate.date, on = c("wficn", "date"), nomatch = 0]

# merge in competitor size as constant within report date
setnames(combined, c("rdate.mon", "comp.size"), c("rdate", "comp.size.var"))
setnames(cs, "date", "rdate")
combined <- cs[combined, on = c("wficn", "rdate"), nomatch = 0]

# log TL-ratio for convenience
combined[, ln.TL := log(To/sqrt(L))]

# returns, expense ratio in yearly % units
combined[, c("r.net", "r.gross", "exp_ratio")
  := list(r.net * 100 * 12, r.gross * 100 * 12, exp_ratio * 100)]
ra.var <- names(combined)[grepl("^ra\\.", names(combined))]
combined[, (ra.var) := lapply(.SD, function(x) x * 100 * 12), .SDcols = ra.var]

# carry forward most recently observed benchmark
setkey(combined, wficn, date)
combined[, c("benchmark", "benchmark.min") :=
  lapply(.SD, na.locf, na.rm = FALSE),
  by = wficn, .SDcols = c("index", "index_min")]
# benchmark X date
combined[!is.na(benchmark), c("benchmark.X.date", "benchmark.min.X.date") :=
  lapply(.SD, function(x) paste0(x, "X", date)),
  .SDcols = c("benchmark", "benchmark.min")]

# sort and save
saveRDS(combined, "data/combined/combined.Rds")
saveRDS(isize, "data/combined/isize.Rds")

