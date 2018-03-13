# Laszlo Jakab
# Feb 26, 2018

# Setup ------------------------------------------------------------------------

# directories
data.dir <- "data/clean"
pw.dir   <- "data/portfolio"


# Load and Prep Data -----------------------------------------------------------

# stock data
msf <- readRDS(file.path(data.dir, "msf_common_equity.Rds"))[
  , .(permno, date, w.mkt.adj)]
setnames(msf, "w.mkt.adj", "w.mkt")

# fund portfolio weights
pw <- readRDS(file.path(pw.dir, "portfolio_weights.Rds"))[
  , .(wficn, date, permno, w)]


# Portfolio Liquidity ----------------------------------------------------------

setkey(pw, permno, date)
L <- pw[
  # add in market weights
  msf[, .(permno, date, w.mkt)], nomatch = 0][
  # portfolio liquidity
  , .(L = sum(w^2 / w.mkt)^(-1)), keyby = .(wficn, date)]


# Stock Liquidity --------------------------------------------------------------

# mkt weight relative to avarage mkt weight (naming follows PST notation)
msf[, mathcal_L := w.mkt / mean(w.mkt), by = date]
S <- pw[
  # add in market weights
  msf[, .(permno, date, mathcal_L)], nomatch = 0][
  # stock liquidity
  , .(S = mean(mathcal_L)), keyby = .(wficn, date)]


# Coverage ---------------------------------------------------------------------

C <- pw[
  # number of stocks held by the fund
  , .(num.stocks.held = .N), by = .(wficn, date)][
  # merge in number of stocks in CRSP universe
  msf[, .(num.stocks.crsp = .N), by = date], on = "date", nomatch = 0][
  , C := num.stocks.held / num.stocks.crsp][
  # clean up
  , C, key = c("wficn", "date")]


# Balance ----------------------------------------------------------------------

B <- pw[
  # add in market weights
  msf[, .(permno, date, w.mkt)], nomatch = 0][
  # relative market weights in the portfolio
  , m.star := w.mkt / sum(w.mkt), by = .(wficn, date)][
  # portfolio liquidity
  , .(B = sum(w^2 / m.star)^(-1)), keyby = .(wficn, date)]


# Consolidate and Save ---------------------------------------------------------

portfolio_liquidity <- L[S][C][B][, D := C * B]
saveRDS(portfolio_liquidity, file.path(pw.dir, "portfolio_liquidity.Rds"))
