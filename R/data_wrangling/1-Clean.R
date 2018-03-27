# Laszlo Jakab
# 2-22-2018

# Setup ------------------------------------------------------------------------

# relative directories for input and output
raw.dir   <- "data/raw"
clean.dir <- "data/clean"

# load packages
library(lubridate)
library(laszlor)

# convenience function for speeding up date conversions
as.Date.fast <- function(x) as.Date(fast_strptime(x, "%Y-%m-%d"))


# Read in all raw data ---------------------------------------------------------

# list of files
raw.files <- list.files(raw.dir, "\\.Rds$") # all raw files (a bit unneccessary)
raw.files.excl <- c(
  "crsp_dsedelist", "crsp_fund_summary", "crsp_msedelist",
  "bw_sentiment", "cpz_factors", "ff_factors", "petajisto_activeshare",
  "tfn_s12type3", "sy_anomalous11", "sy_factor", "sy_mispricing")
raw.files <- raw.files[!raw.files %in% paste0(raw.files.excl, ".Rds")]
# read in all files
for (f in raw.files) {
  dt.name <- gsub("_", "\\.", strsplit(f, "\\.")[[1]][1])
  assign(dt.name, readRDS(file.path(raw.dir, f)))
}


# MFLINKS: crsp_fundno to wficn ------------------------------------------------

# this table is supposed to be a 1:m match of crsp_fundno to wficn.
# unfortunately, there are a 6 instances where crsp_fundno matched
# to two different wficn. i drop these funds.
mfl.crsp <- mfl.crsp[, if (.N == 1) .SD, keyby = crsp_fundno]
saveRDS(mfl.crsp, file.path(clean.dir, "mfl_crsp_nodup.Rds"))


# MFLINKS: (fundno x fdate) to wficn -------------------------------------------

# standardize date format, sort and save
mfl.tfn[, fdate := as.Date.fast(fdate)]
setkey(mfl.tfn, fundno, fdate)
saveRDS(mfl.tfn, file.path(clean.dir, "mfl_tfn.Rds"))


# CPI (from FRED) --------------------------------------------------------------
# standardize data types in CPI dataset
cpiaucs <- fred.cpiaucs[, `:=` (date = as.yearmon(date), cpi = as.numeric(cpi))]
setkey(cpiaucs, date)
saveRDS(cpiaucs, file.path(clean.dir, "cpi.Rds"))


# CRSP Stocknames --------------------------------------------------------------

# clean crsp stocknames file
setnames(crsp.stocknames, tolower(names(crsp.stocknames)))
sn.charcols <- names(crsp.stocknames)[sapply(crsp.stocknames, is.character)]
crsp.stocknames[
  # eliminate leading and trailing whitespace from string variables
  , (sn.charcols) :=
    lapply(.SD, function(x) gsub("^\\s+|\\s+$", "", x)), .SDcols = sn.charcols][
  # standardize dates
  , c("namedt", "nameenddt", "st_date", "end_date") := lapply(.SD, as.Date.fast),
    .SDcols = c("namedt", "nameenddt", "st_date", "end_date")]
# sort and save
setkey(crsp.stocknames, permno, namedt, nameenddt)
saveRDS(crsp.stocknames, file.path(clean.dir, "stocknames.Rds"))


# Permno-Cusip Table -----------------------------------------------------------

# lookup table with cusip-permno pairs (table is 1:m)
cusip.permno <- crsp.stocknames[
  # replace missing ncusip with cusip
  ncusip == "", ncusip := cusip][
  # keep only identifiers
  , .(ncusip, permno)]
# keep only unique cusip-permno pairs
cusip.permno <- unique(cusip.permno)
setnames(cusip.permno, "ncusip", "cusip")
setkey(cusip.permno, cusip)
saveRDS(cusip.permno, file.path(clean.dir, "cusip_permno_lookup.Rds"))


# CRSP Monthly Stock File ------------------------------------------------------

# string variables in crsp msf file
msf.charcols <- names(crsp.msf)[sapply(crsp.msf, is.character)]
msf <- crsp.msf[
  # remove whitespace from string variables
  , (msf.charcols) :=
    lapply(.SD, function(x) gsub("^\\s+|\\s+$", "", x)), .SDcols = msf.charcols][
  # set price to NA if equal to -99
  prc == -99, prc := NA][
  # fix negative price
  , prc:= abs(prc)][
  # drop if price or shares outstanding is missing
  !(is.na(prc) | is.na(shrout))][
  # rename date
  , caldt := as.Date.fast(date)][
  # year-month date
  , date := as.yearmon(caldt)]

# keep only common equity
msf <- foverlaps(
  msf[
    # generate degenerate interval for overlap join
    , caldt2 := caldt][
    # sort by permno, and beginning and end of degenerate interval
    , .SD, key = c("permno", "caldt", "caldt2")],
  # match names dataset
  crsp.stocknames[, .(permno, namedt, nameenddt, shrcd)], type = "within")[
    # keep only common stock
    shrcd %in% c(10, 11)][
    # drop variables unlikely to be used in analysis
    , c("namedt", "nameenddt", "caldt2", "shrcd") := NULL]

# calculate adjusted price, shrout, and market weights
msf <- msf[, `:=`
  (p = prc / cfacpr, w.mkt = (prc * shrout) / sum(prc * shrout)), by = date]

# sort and save
setkey(msf, permno, date)
saveRDS(msf, file.path(clean.dir, "msf_common_equity.Rds"))


# Total Market Cap -------------------------------------------------------------

total.mktcap <- msf[
  , .(totcap = sum(prc * shrout * 1000), num.stocks = .N), keyby = date]
saveRDS(total.mktcap, file.path(clean.dir, "total_mktcap.Rds"))


# Thomson S12Type1: Restrict to First Vintage ----------------------------------

tfn.s12type1.fvint <- tfn.s12type1[
  # standardize dates
  , c("fdate", "rdate")
  := lapply(.SD, as.Date.fast), .SDcols = c("fdate", "rdate")][
  # identify last report date by report month
  , max.rdate := max(rdate), by = .(fundno, year(rdate), month(rdate))][
  # keep only last report
  rdate == max.rdate][
  # for each report date, keep only the first file date
  , .SD, key = c("fundno", "rdate", "fdate")][
  , .SD[1], by = .(fundno, rdate)][
  # clean up
  , max.rdate := NULL]
# sort and save
setkey(tfn.s12type1.fvint, fundno, fdate)
saveRDS(tfn.s12type1.fvint, file.path(clean.dir, "tfn_s12type1_fvint.Rds"))


# CRSP Fund Headers ------------------------------------------------------------

# append fund header info
fund.hdr <- rbind(crsp.fund.hdr, crsp.fund.hdr.hist, fill = TRUE)
# use dead_flag, delist_cd, merge_fundno from crsp.fund.hdr
fund.hdr[, c("dead_flag", "delist_cd", "merge_fundno") := NULL]
fund.hdr <- fund.hdr[
  crsp.fund.hdr[, .(crsp_fundno, dead_flag, delist_cd, merge_fundno)]
  , on = "crsp_fundno"]
# eliminate leading and trailing whitespace from string variables
hdr.charcols <- names(fund.hdr)[sapply(fund.hdr, is.character)] # string variables
fund.hdr[, (hdr.charcols) :=
  lapply(.SD, function(x) gsub("^\\s+|\\s+$", "", x)), .SDcols = hdr.charcols]

# consolidate effective dates for fund_hdr and fund_hdr_hist
# standardize date formats
dates <- c("chgdt", "chgenddt", "end_dt")
fund.hdr[, (dates) := lapply(.SD, as.Date.fast), .SDcols = dates]

# --- End Date ---

# use historical header end date where it exists
fund.hdr[, enddt := chgenddt]
# consider current header to be the most recent
fund.hdr[is.na(enddt) & !is.na(end_dt), enddt := end_dt]

# if no end date attached to current header, consider info valid to the end
fund.hdr[is.na(enddt), enddt := as.Date("2018-03-01")]

# --- Beginning Date ---

# use historical header beginning date where it exists
fund.hdr[, begdt := chgdt]

# if historical info not available, take last end date
setkey(fund.hdr, crsp_fundno, enddt)
fund.hdr <- fund.hdr[
  , enddt.last := shift(enddt), by = crsp_fundno][
  is.na(begdt), begdt := enddt.last + 1][
  , enddt.last := NULL]

# if no begdt available and first obs for fund, consider it to apply throughout
fund.hdr[
  , first.obs := .I[1], by = crsp_fundno][
  (1:.N == first.obs) & is.na(begdt), begdt := as.Date("1900-01-01")][
  , first.obs := NULL]

# sort by crsp_fundno, begdt, enddt and save
setkey(fund.hdr, crsp_fundno, begdt, enddt)
saveRDS(fund.hdr, file.path(clean.dir, "fund_hdr.Rds"))


# CRSP Fund Style --------------------------------------------------------------

# clean dates
fund.style <- crsp.fund.style[
  , c("begdt", "enddt") :=
    lapply(.SD, as.Date.fast), .SDcols = c("begdt", "enddt")]
# eliminate leading and trailing whitespace from string variables
style.charcols <- names(fund.style)[sapply(fund.style, is.character)]
fund.style[
  , (style.charcols) := lapply(.SD, function(x) gsub("^\\s+|\\s+$", "", x))
  ,.SDcols = style.charcols]
# save
saveRDS(fund.style, file.path(clean.dir, "fund_style.Rds"))


# CRSP Fund Fees ---------------------------------------------------------------

# fix missing values (assign -99 to NA)
fund.fees <- crsp.fund.fees
fund.fees[fund.fees == -99] <- NA
# zero expense ratios for active funds tend to indicate
# missing information (Barber, Odean and Zheng (2005));
# i also set negative expense ratios to missing (e.g. PST)
fund.fees[exp_ratio <= 0, exp_ratio := NA]
# standardize dates
fund.fees <- fund.fees[, c("begdt", "enddt", "fiscal_yearend")
  := lapply(.SD, as.Date.fast), .SDcols = c("begdt", "enddt", "fiscal_yearend")]

# break out turnover, as it is recorded on different timetable
turnover <- fund.fees[!is.na(turn_ratio),
  .(crsp_fundno, begdt, fiscal_yearend, turn_ratio)]
fund.fees[, c("turn_ratio", "fiscal_yearend") := NULL]

# make sure begdt-enddt intervals do not overlap
setkey(fund.fees, crsp_fundno, begdt)
fund.fees <- fund.fees[
  # generate subsequent begdt
  , next.begdt := shift(begdt, type = "lead"), by = crsp_fundno][
  # if next begdt is same as current enddt, adjust enddt (34 changes)
  enddt == next.begdt, enddt := enddt - 1][
  # clean up
  , next.begdt := NULL]
# save
setkey(fund.fees, crsp_fundno, begdt, enddt)
saveRDS(fund.fees, file.path(clean.dir, "fund_fees.Rds"))


# CRSP Turnover ----------------------------------------------------------------

turnover <- turnover[
  # turn_ratio valid for 12 months ending on fiscal_yearend when it is present.
  # otherwise, it applies for 12 months ending on begdt.
  , enddt := dplyr::if_else(!is.na(fiscal_yearend), fiscal_yearend, begdt)][
  # average by effective end date (475 duplicates by crsp_fundno X enddt)
  , .(turn_ratio = mean(turn_ratio)), by = .(crsp_fundno, enddt)][
  , .SD, key = c("crsp_fundno", "enddt")][
  # identify most recent enddt
  , last.enddt := shift(enddt), by = .(crsp_fundno)][
  # effective beginning date is the last enddt if it is less than 1 year before
  # current enddt. otherwise, generate begdt as 1 year before current enddt
  , begdt
    := dplyr::if_else(!is.na(last.enddt) & enddt-last.enddt < dyears(1) ,
      last.enddt + 1, enddt - dyears(1) + 1)][
  , .(crsp_fundno, begdt, enddt, turn_ratio)][
  # clean up gaps (up to 3 days) between begdt and enddt
  , .SD, key = c("crsp_fundno", "begdt", "enddt")][
  , last.enddt := shift(enddt), by = .(crsp_fundno)][
  !is.na(last.enddt) & (begdt - last.enddt <= 4), begdt := last.enddt + 1][
  # housekeeping
  , last.enddt := NULL]
# sort and save
setkey(turnover, crsp_fundno, begdt, enddt)
saveRDS(turnover, file.path(clean.dir, "turnover.Rds"))


# CRSP Returns, TNA, NAV -------------------------------------------------------

# mtna
mtna <- crsp.mtna[
  # assign -99 to missing
  mtna == -99, mtna := NA][
  # keep if mtna not missing and positive
  !is.na(mtna) & mtna > 0][
  # standardize dates
  , caldt := as.Date.fast(caldt)][
  , date  := as.yearmon(caldt)][
  , caldt := min(caldt), by = date][
  , date  := NULL]
# sort and save
setkey(mtna, crsp_fundno, caldt)
saveRDS(mtna, file.path(clean.dir, "mtna.Rds"))

# nav
mnav <- crsp.mnav[
  # drop missing
  !is.na(mnav)][
  # standardize dates
  , caldt := as.Date.fast(caldt)][
  , date  := as.yearmon(caldt)][
  , caldt := min(caldt), by = date][
  , date  := NULL]
# sort and save
setkey(mnav, crsp_fundno, caldt)
saveRDS(mnav, file.path(clean.dir, "mnav.Rds"))

# returns
mret <- crsp.mret[
  # drop missing
  !is.na(mret)][
  # standardize dates
  , caldt := as.Date.fast(caldt)][
  , date  := as.yearmon(caldt)][
  , caldt := min(caldt), by = date][
  , date  := NULL]
setkey(mret, crsp_fundno, caldt)

# keep returns only if they are for a single month
# that is, drop if gap is not a single month between observations
# AND no nav is available in the previous month.
mret <- merge(
  mret, mnav[, .(crsp_fundno, caldt)],
    by = c("crsp_fundno", "caldt"), all = TRUE)[
  , date := as.yearmon(caldt)][
  , gap  := round((date - shift(date)) * 12), by = crsp_fundno][
  gap == 1 & !is.na(mret)][
  , c("gap", "date") := NULL]
# save
setkey(mret, crsp_fundno, caldt)
saveRDS(mret, file.path(clean.dir, "mret.Rds"))


# Fund Inception Date ----------------------------------------------------------

# minimum of first_offer_dt, and first month for which
# returns, tna, or nav are available, across all share classes

# first month for which any return, size, or NAV recorded (by share class)
min.date.in.data <- merge(merge(
  # min caldt for which each of returns, tna, nav exist
  mret[, .(min.caldt.mret = min(caldt)), by = crsp_fundno],
  mtna[, .(min.caldt.mtna = min(caldt)), by = crsp_fundno], all = TRUE),
  mnav[, .(min.caldt.mnav = min(caldt)), by = crsp_fundno], all = TRUE)[
  # min caldt for which any data ret, tna, or nav exists
  , min.caldt :=
    pmin(min.caldt.mret, min.caldt.mtna, min.caldt.mnav, na.rm = TRUE)][
  # keep only fund id and earliest date with any data
  , .(crsp_fundno, min.caldt)]

fund.inception <- min.date.in.data[
  # match with first offer date from CRSP Fund Header table (share class level)
  crsp.fund.hdr[, first_offer_dt, keyby = crsp_fundno], on = "crsp_fundno"][
  # corrected share class inception date
  , share.class.inception := pmin(min.caldt, first_offer_dt, na.rm = TRUE)][
  # merge in fund identifier
  mfl.crsp, on = "crsp_fundno", nomatch = 0][
  # corrected fund inception date
  , .(fund.inception = min(share.class.inception)), keyby = wficn]
# save
saveRDS(fund.inception, file.path(clean.dir, "fund_inception.Rds"))


# Combine Returns, TNA, Expense Ratio, Turnover --------------------------------

# merge returns, TNA
ret.tna <- merge(mret, mtna, by = c("crsp_fundno", "caldt"), all = TRUE)

# degenerate interval end date for overlap joins
ret.tna[, caldt2 := caldt]
setkey(ret.tna, crsp_fundno, caldt, caldt2)
# match with expense ratio
ret.tna <- foverlaps(ret.tna,
  fund.fees[, .(crsp_fundno, begdt, enddt, exp_ratio)], type = "within")
# match with turnover
ret.tna <- foverlaps(ret.tna, turnover, type = "within")
# housekeeping
ret.tna[, c("begdt", "enddt", "i.begdt", "i.enddt", "caldt2") := NULL]

# sort and save
setcolorder(ret.tna,
  c("crsp_fundno", "caldt", "mret", "mtna", "exp_ratio", "turn_ratio"))
setkey(ret.tna, crsp_fundno, caldt)
saveRDS(ret.tna, file.path(clean.dir, "share_class_crsp_data.Rds"))


# Collapse to Fund Level -------------------------------------------------------

# fill in gaps in mtna where consecutive mret is available
ret.tna[
  # year-month variable
  , date := as.yearmon(caldt)][
  # number of months between non-missing mret obs
  !is.na(mret), gap.mret := round((date - shift(date)) * 12), by = crsp_fundno][
  # consider gap to be 1 for first non-missing obs of mret
  !is.na(mret), first.mret := .I[1L], by = crsp_fundno][
  1:.N == first.mret, gap.mret := 1][
  # most recent non-missing mtna
  , tna := na.locf(mtna, na.rm = FALSE), by = crsp_fundno][
  # mret, ignoring observations where there is a break in data availability
  gap.mret == 1, mret.nogap := mret][
  # compound returns by share class, resetting when missingness of mtna switches
  , mret.cum := cumprod(1 + mret.nogap), by = .(crsp_fundno, rleid(is.na(mtna)))][
  # compound fund last observed size using interim returns
  is.na(mtna), tna := tna * mret.cum]

# lag tna by one month to be used as weights in fund-level aggregation
ret.tna <- LagDT(ret.tna, "tna", panel.id = "crsp_fundno")
# fill lagged tna with actual value for the first non-missing observation
ret.tna <- ret.tna[
  !is.na(tna), first.tna := .I[1L], by = crsp_fundno][
  1:.N == first.tna, tna.l1 := tna]

# prepare for aggregation to fund level
ret.tna <- ret.tna[
  # add fund id (wficn) from MFLINKS (only keep matches)
  mfl.crsp, on = "crsp_fundno", nomatch = 0][
  # drop if lagged tna not available or is not positive
  !is.na(tna.l1) & tna.l1 > 0][
  # gross returns
  , mret.gross := mret + exp_ratio / 12]

# aggregate to fund level
# net returns, expense ratio, turnover weighted by lagged tna
r.net.dt <- ret.tna[
  !is.na(mret), .(r.net = sum(mret * tna.l1 / sum(tna.l1))),
  keyby = .(wficn, date)]
# gross returns
r.gross.dt <- ret.tna[
  !is.na(mret.gross), .(r.gross = sum(mret.gross * tna.l1 / sum(tna.l1))),
  keyby = .(wficn, date)]
# total net assets
tna.dt <- ret.tna[
  !is.na(tna), .(tna = sum(tna)),
  keyby = .(wficn, date)]
# expense ratio
exp_ratio.dt <- ret.tna[
  !is.na(exp_ratio), .(exp_ratio = sum(exp_ratio * tna.l1 / sum(tna.l1))),
  keyby = .(wficn, date)]
# turnover
turn_ratio.dt <- ret.tna[
  !is.na(turn_ratio), .(turn_ratio = sum(turn_ratio * tna.l1 / sum(tna.l1))),
  keyby = .(wficn, date)]

# merge fund level variables
ret.tna.fund <- merge(r.net.dt, r.gross.dt,
  by = c("wficn", "date"), all = TRUE)
ret.tna.fund <- merge(ret.tna.fund, tna.dt,
  by = c("wficn", "date"), all = TRUE)
ret.tna.fund <- merge(ret.tna.fund, exp_ratio.dt,
  by = c("wficn", "date"), all = TRUE)
ret.tna.fund <- merge(ret.tna.fund, turn_ratio.dt,
  by = c("wficn", "date"), all = TRUE)


# Tidy Fund Level Dataset ------------------------------------------------------

# total net assets in real dollars
ret.tna.fund <- ret.tna.fund[
  # add in CPI (keep only matches; this deletes only from the CPI dataset)
  cpiaucs, on = "date", nomatch = 0][
  # total net assets in constant 2017 dollars
  , tna.real2017 := tna * cpiaucs[date == "Jun 2017", cpi] / cpi][
  # drop cpi
  , cpi := NULL]

# lagged tna, real tna
ret.tna.fund <- LagDT(ret.tna.fund, c("tna", "tna.real2017"), panel.id="wficn")

# additional sample conditions on tna, expense ratio
ret.tna.fund <- ret.tna.fund[
  # drop if lagged real tna is less than 15m
  is.na(tna.real2017.l1) | tna.real2017.l1 >= 15][
  # if lagged real tna missing, drop if current real tna less than 15m
  !(is.na(tna.real2017.l1) & tna.real2017 < 15)][
  # drop if fund-level expense ratio < .1% (signifies passive fund)
  is.na(exp_ratio) | exp_ratio >= 0.001][
  # drop if tna == 0
  tna > 0][
  # keep only if the fund is observed for at least a year
  , if (.N >= 12) .SD, by = wficn]

# add in fund inception
ret.tna.fund <- merge(ret.tna.fund, fund.inception, by = "wficn", all.x = TRUE)[
  # number of years since inception
  , fund.age := date - as.yearmon(fund.inception)][
  # no need to retain actual inception date in this table
  , fund.inception := NULL]

# sort and save
setkey(ret.tna.fund, wficn, date)
saveRDS(ret.tna.fund, file.path(clean.dir, "fund_level_crsp.Rds"))
