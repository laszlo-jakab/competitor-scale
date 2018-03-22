# Laszlo Jakab
# Mar 2018


# Regression Function ----------------------------------------------------------

RegCoefs <- function(dt, fm) {
  fm <- as.formula(fm)
  reg <- lm(fm, data = dt)$coef
  out <- transpose(list(reg))
  return(out)
}


# Load Fund Level Returns, FF factors ------------------------------------------

fund.ret   <- readRDS("data/clean/fund_level_crsp.Rds")
ff.factors <- readRDS("data/raw/ff_factors.Rds")


# Combine Datasets -------------------------------------------------------------

# generate year-month id for ff factors
ff.factors[, date := as.yearmon(paste(year, month, sep = "-"))]

# get combined dataset of interest
fund.ret <- fund.ret[
  # keep only returns
  , .(wficn, date, r.net, r.gross)][
  # add in ff factors
  ff.factors[, .(date, mktrf, smb, hml, umd, rf)], on = "date", nomatch = 0][
  # excess returns
  , `:=` (
    re.net = r.net - rf,
    re.gross = r.gross - rf)][
  # restrict to 1980-2016
  "Jan 1980" <= date & date <= "Jan 2017"][
  # require a year of net returns
  !is.na(r.net), if (.N >= 12) .SD, keyby = wficn]


# Fitting Factor Models --------------------------------------------------------

# CAPM, net returns
capm.betas.net <- fund.ret[
  , RegCoefs(.SD, "re.net ~ mktrf"), by = wficn]
setnames(capm.betas.net, c("wficn", paste0(c("a", "b"), ".capm.net")))

# CAPM, gross returns
capm.betas.gross <- fund.ret[
  !is.na(r.gross), if (.N >= 12) .SD, by = wficn][
  , RegCoefs(.SD, "re.gross ~ mktrf"), by = wficn]
setnames(capm.betas.gross, c("wficn", paste0(c("a", "b"), ".capm.gross")))

# FF3, net returns
ff3.betas.net <- fund.ret[
  , RegCoefs(.SD, "re.net ~ mktrf + smb + hml"), by = wficn]
setnames(ff3.betas.net, c("wficn", paste0(c("a", "b", "s", "h"), ".ff3.net")))

# FF3, gross returns
ff3.betas.gross <- fund.ret[
  !is.na(r.gross), if (.N >= 12) .SD, by = wficn][
  , RegCoefs(.SD, "re.gross ~ mktrf + smb + hml"), by = wficn]
setnames(ff3.betas.gross, c("wficn", paste0(c("a", "b", "s", "h"), ".ff3.gross")))

# FF4, net returns
ff4.betas.net <- fund.ret[
  , RegCoefs(.SD, "re.net ~ mktrf + smb + hml + umd"), by = wficn]
setnames(ff4.betas.net, c("wficn", paste0(c("a", "b", "s", "h", "m"), ".ff4.net")))

# FF4, gross returns
ff4.betas.gross <- fund.ret[
  !is.na(r.gross), if (.N >= 12) .SD, by = wficn][
  , RegCoefs(.SD, "re.gross ~ mktrf + smb + hml + umd"), by = wficn]
setnames(ff4.betas.gross, c("wficn", paste0(c("a", "b", "s", "h", "m"), ".ff4.gross")))

# consolidate loadings
loadings.net <- capm.betas.net[
  ff3.betas.net, on = "wficn"][
  ff4.betas.net, on = "wficn"]
loadings.gross <- capm.betas.gross[
  ff3.betas.gross, on = "wficn"][
  ff4.betas.gross, on = "wficn"]
loadings <- merge(loadings.net, loadings.gross, by = "wficn", all = TRUE)
saveRDS(loadings, file.path(out.dir, "factor_loadings.Rds"))


# Risk Adjusted Returns --------------------------------------------------------

risk.adj.ret <- fund.ret[loadings, on = "wficn"][
  , `:=` (
    # CAPM
    ra.net.capm = re.net - b.capm.net*mktrf,
    ra.gross.capm = re.gross - b.capm.gross*mktrf,
    # FF3
    ra.net.ff3 = re.net -
      (b.ff3.net*mktrf + s.ff3.net*smb + h.ff3.net*hml),
    ra.gross.ff3 = re.gross -
      (b.ff3.gross*mktrf + s.ff3.gross*smb + h.ff3.gross*hml),
    # FF4
    ra.net.ff4 = re.net -
      (b.ff4.net*mktrf + s.ff4.net*smb + h.ff4.net*hml + m.ff4.net*umd),
    ra.gross.ff4 = re.gross -
      (b.ff4.gross*mktrf + s.ff4.gross*smb + h.ff4.gross*hml + m.ff4.gross*umd)
  )][
    # keep only relevant variables
  , .(wficn, date,
      ra.net.capm, ra.net.ff3, ra.net.ff4,
      ra.gross.capm, ra.gross.ff3, ra.gross.ff4)]
# sort and save
setkey(risk.adj.ret, wficn, date)
saveRDS(risk.adj.ret, "data/benchmarked_returns/risk_adj_ret.Rds")
