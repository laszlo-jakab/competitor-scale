# Laszlo Jakab
# Feb 26, 2018

# Setup ------------------------------------------------------------------------

# directories
raw.dir  <- "data/raw"
data.dir <- "data/clean"
out.dir  <- "data/portfolio"

# read in data
mfl.tfn      <- readRDS(file.path(data.dir, "mfl_tfn.Rds"))
cusip.permno <- readRDS(file.path(data.dir, "cusip_permno_lookup.Rds"))
msf          <- readRDS(file.path(data.dir, "msf_common_equity.Rds"))
s12type1     <- readRDS(file.path(data.dir, "tfn_s12type1_fvint.Rds"))
s12type3     <- readRDS(file.path(raw.dir,  "tfn_s12type3.Rds"))


# Preliminary Steps ------------------------------------------------------------

# clean up s12type1
s12type1 <- s12type1[
  # add in mflinks to first vintage of s12type1
  mfl.tfn, on = c("fundno", "fdate"), nomatch = 0][
  # month-level rdate and fdate
  , `:=` (rdate.mon = as.yearmon(rdate), fdate.mon = as.yearmon(fdate))][
  # drop if wficn-rdate not unique (at month level)
  , if (.N == 1L) .SD, keyby = .(wficn, rdate.mon)][
  # min of next report date and current report plus six months
  , nrdate.mon
    := pmin(shift(rdate.mon, type="lead"), rdate.mon + 6 / 12, na.rm = TRUE)
      , by = wficn][
  # keep only necessary variables
  , .(wficn, fundno, rdate, fdate, rdate.mon, nrdate.mon, fdate.mon)]

# save wficn-rdate pairs
wficn.rdate <- s12type1[, .(wficn, rdate.mon)]
setkey(wficn.rdate, wficn, rdate.mon)
saveRDS(wficn.rdate, file.path(data.dir, "wficn_rdate.Rds"))
rm(wficn.rdate)

# sort by fundno, fdate
setkey(s12type1, fundno, fdate)

# clean up s12type3
s12type3 <- s12type3[
  , fdate := as.Date(lubridate::fast_strptime(fdate, "%Y-%m-%d"))][
  , cusip := gsub("^\\s+|\\s+$", "", cusip)]
setkey(s12type3, fundno, fdate)


# Portfolio Weights ------------------------------------------------------------

# match to share holdings
pw <- s12type1[s12type3, on = c("fundno", "fdate"), nomatch = 0]

# match cusips to permnos
setkey(pw, cusip)
pw <- pw[cusip.permno, on = "cusip", nomatch = 0]

# there are 53 instances where wficn, rdate, and permno are not unique; add together these holdings
pw <- pw[, .(wficn, rdate.mon, permno, nrdate.mon, fdate.mon, shares)]
setkey(pw, wficn, rdate.mon, permno)
pw <- pw[, shares := sum(shares), by = .(wficn, rdate.mon, permno)]
pw <- unique(pw)

# clean up workspace for memory management
rm(s12type3, mfl.tfn, cusip.permno)

# add in share adjustment (matched on vintage date)
setkey(pw, permno, fdate.mon)
pw <- pw[msf[, .(permno, date, cfacshr)], on = c("permno", fdate.mon = "date"), nomatch = 0]
# adjust shares
pw[, shares := shares * cfacshr]

# number of months between reports
pw[, d := round((nrdate.mon - rdate.mon)*12)]
# some housekeeping
setnames(pw, "rdate.mon", "date")
# keep only what's necessary
pw <- pw[, .(wficn, permno, date, shares, d)]
# fill in dates
pw <- pw[rep(1:.N, d)]
setkey(pw, wficn, permno, date)
pw[, d := (seq_len(.N) - 1) / 12, by = .(wficn, permno, date)]
pw[, date := date + d]
pw[, d := NULL]

# merge in crsp prices
setkey(pw, permno, date)
pw <- pw[msf[, .(permno, date, p, w.mkt)], on = c("permno", "date"), nomatch = 0]
# calculate portfolio weights
setkey(pw, wficn, date)
pw[, w := shares * p / sum(shares * p), by = .(wficn, date)]
pw[, w.adj := w / w.mkt]
pw[, c("shares", "p", "w.mkt") := NULL]

# keep only if at least five stocks
setkey(pw, wficn, date)
pw <- pw[, if (.N >= 5) .SD, by = .(wficn, date)]

# sort and save
setkey(pw, date, permno, wficn)
saveRDS(pw, file.path(out.dir, "portfolio_weights.Rds"))
