# Laszlo Jakab
# Mar 2018

# Setup ------------------------------------------------------------------------

# libraries
library(lfe)

# source functions to construct reg tables
source("R/functions/RegDisplay_Fn.R")

# load combined fund-month level data
combined <- readRDS("data/combined/combined.Rds")
# load quarter-to-quarter log competitor size change
dln.cs <- readRDS("data/competitor_size/dln_competitor_size.Rds")


# Keep End of Quarter Report Dates ---------------------------------------------

combined <- combined[
  # keep report dates
  date == rdate][
  # keep quarter-end
  month(date) %in% c(3, 6, 9, 12)][
  # number of months since last obs
  , d.months := round((date - shift(date))*12), by = wficn][
  # keep if 3 months between this obs and last
  d.months == 3]

# get logs of active share, portfolio  liquidity variables,
# fund size, and expense ratio
setnames(combined, c("activeshare", "exp_ratio", "To"), c("AS", "f", "T"))
vars <- c("AS", "L", "S", "D", "C", "B", "fund.size", "f", "T")
ln.vars <- paste0("ln.", vars)
combined[, (ln.vars) := lapply(.SD, log), .SDcols = vars]


# First Differences ------------------------------------------------------------

ln.vars <- c("ln.AS", "ln.TL", "ln.L", "ln.S", "ln.D", "ln.C",
  "ln.B", "ln.fund.size", "ln.f", "ln.T")
dln.vars <- paste0("d", ln.vars)
combined[, (dln.vars) := lapply(.SD, function(x) x - shift(x))
  , by = wficn, .SDcols = ln.vars]

# add in quasi-first differenced log competitor size
combined <- combined[dln.cs, on = c("wficn", "date"), nomatch = 0]


# Fund Behavior Regressions ----------------------------------------------------

ys <- c("dln.AS", "dln.TL", "dln.L", "dln.S", "dln.D", "dln.C", "dln.B")
xs <- "dln.comp.size"
ctrls <- c(
  rep("dln.fund.size + dln.f", 2),
  "dln.fund.size + dln.f + dln.T",
  "dln.fund.size + dln.f + dln.T + dln.D",
  "dln.fund.size + dln.f + dln.T + dln.S",
  "dln.fund.size + dln.f + dln.T + dln.S + dln.B",
  "dln.fund.size + dln.f + dln.T + dln.S + dln.C")
fes <- "date"
ivs <- "0"
cls <- "wficn + date.port.grp"
models.behavior <- paste(paste(paste(ys, xs, sep = " ~ "), ctrls, sep = " + "),
  fes, ivs, cls, sep = " | ")

# run regressions
res.behavior <- lapply(models.behavior,
  function(x) felm(as.formula(x), data = combined))

# output regression table
coef.lab.dt <- data.table(
  old.name = c("dln.comp.size", "dln.fund.size", "dln.f", "dln.T",
    "dln.D", "dln.S", "dln.B", "dln.C"),
  new.name = c("$\\Delta CS$", "$\\Delta\\ln(FundSize)$", "$\\Delta\\ln(f)$",
    "$\\Delta \\ln(T)$", "$\\Delta\\ln(D)$", "$\\Delta\\ln(S)$",
    "$\\Delta\\ln(B)$", "$\\Delta\\ln(C)$"))
fe.list <- rbind(
  c("Fixed Effects", rep("", 7)),
  c("$\\bullet$ Quarter", rep("Yes", 7)))
rt.behavior <- RegTable(res.behavior,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt)

# label table
behavior.reg.base <- list(
  results = rt.behavior,
  title = "Capital Allocation and Competitor Size",
  caption = "Observations are first differences at the fund $\\times$ quarter level, from 1980-2016. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks \\citep{cp09, petajisto13}, covering years 1980-2009. $TL^{-1/2}$ is the turnover to portfolio liquidity ratio, as in \\citet{pst17L}. $S$, $D$, $C$, and $B$ are the components of portfolio liquidity, namely stock liquidity, diversification, coverage, and balance (each calculated with respect to all U.S. equity). $\\Delta CS_{i,t}=\\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t} \\right) - \\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t-1}\\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Standard errors are double clustered by fund and portfolio group $\\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Fund Behavior Regressions, Pre-2008 ---------------------------------------

# run regressions
res.behavior.08 <- lapply(models.behavior,
  function(x) felm(as.formula(x), data = combined[date <= "Dec 2007"]))

# output regression table
rt.behavior.08 <- RegTable(res.behavior.08,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt)

# label table
behavior.reg.base.08 <- list(
  results = rt.behavior.08,
  title = "Capital Allocation and Competitor Size --- Pre-2008 Data",
  caption = "Observations are first differences at the fund $\\times$ quarter level, from 1980-2007. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks \\citep{cp09, petajisto13}. $TL^{-1/2}$ is the turnover to portfolio liquidity ratio, as in \\citet{pst17L}. $S$, $D$, $C$, and $B$ are the components of portfolio liquidity, namely stock liquidity, diversification, coverage, and balance (each calculated with respect to all U.S. equity). $\\Delta CS_{i,t}=\\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t} \\right) - \\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t-1}\\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Standard errors are double clustered by fund and portfolio group $\\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Benchmark X Date FE ----------------------------------------------------------

# update specification
fes.bd <- "benchmark.min.X.date"
cls.bd <- "wficn + benchmark.min.X.date"
models.behavior.bd <- paste(paste(paste(ys, xs, sep = " ~ "),
  ctrls, sep = " + "), fes.bd, ivs, cls.bd, sep = " | ")

# run regressions
res.behavior.bd <- lapply(models.behavior.bd,
  function(x) felm(as.formula(x), data = combined))

# format output table
fe.list.bd <- rbind(
  c("Fixed Effects", rep("", 7)),
  c("$\\bullet$ Benchmark $\\times$ Quarter", rep("Yes", 7)))
rt.behavior.bd <- RegTable(res.behavior.bd,
  fe.list = fe.list.bd, coef.lab.dt = coef.lab.dt)

# label table
behavior.reg.bd <- list(
  results = rt.behavior.bd,
  title = "Capital Allocation and Competitor Size --- Benchmark $\\times$ Quarter FE",
  caption = "Observations are first differences at the fund $\\times$ quarter level, from 1980-2016. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks \\citep{cp09, petajisto13}, covering years 1980-2009. $TL^{-1/2}$ is the turnover to portfolio liquidity ratio, as in \\citet{pst17L}. $S$, $D$, $C$, and $B$ are the components of portfolio liquidity, namely stock liquidity, diversification, coverage, and balance (each calculated with respect to all U.S. equity). $\\Delta CS_{i,t}=\\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t} \\right) - \\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t-1}\\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Benchmark X Date FE, Pre-2008 ---------------------------------------------------

# run regressions
res.behavior.bd.08 <- lapply(models.behavior.bd,
  function(x) felm(as.formula(x), data = combined[date <= "Dec 2007"]))

# format output table
rt.behavior.bd.08 <- RegTable(res.behavior.bd.08,
  fe.list = fe.list.bd, coef.lab.dt = coef.lab.dt)

# label table
behavior.reg.bd.08 <- list(
  results = rt.behavior.bd.08,
  title = "Capital Allocation and Competitor Size --- Benchmark $\\times$ Quarter FE, Pre-2008 Data",
  caption = "Observations are first differences at the fund $\\times$ quarter level, from 1980-2008. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks \\citep{cp09, petajisto13}. $TL^{-1/2}$ is the turnover to portfolio liquidity ratio, as in \\citet{pst17L}. $S$, $D$, $C$, and $B$ are the components of portfolio liquidity, namely stock liquidity, diversification, coverage, and balance (each calculated with respect to all U.S. equity). $\\Delta CS_{i,t}=\\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t} \\right) - \\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t-1}\\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: \\*** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Collect and Save ------------------------------------------------------

behavior.tab <- list(
  baseline    = behavior.reg.base,
  bd          = behavior.reg.bd,
  baseline.08 = behavior.reg.base.08,
  bd.08       = behavior.reg.bd.08)
saveRDS(behavior.tab, "tab/reg_behavior.Rds")
