# Laszlo Jakab
# Mar, 2018

# Setup ------------------------------------------------------------------------

# packages
library(lfe)
library(laszlor)

# load data
combined <- readRDS("data/combined/combined.Rds")

# standardize variables
combined[, `:=` (
  csize.std  = comp.size / sd(comp.size, na.rm = TRUE),
  isize.std = industry.size / sd(industry.size, na.rm = TRUE),
  fsize.std  = fund.size /
    (quantile(fund.size, .5, na.rm = TRUE) -
       quantile(fund.size, .1, na.rm = TRUE)))]


# Returns and Competitor Scale -------------------------------------------------

# regression specifications
y  <- "ra.gross.ff3"
x  <- c("csize.std", "isize.std",
  "csize.std + isize.std", "csize.std + fsize.std")
fe <- c(rep("wficn", 3), "wficn + date")
iv <- "0"
cl <- "wficn + date.port.grp"
m.base <- FormFELM(y, x, fe, iv, cl)

# run regressions
r.base <- lapply(m.base, felm, combined)

# construct regression table
coef.lab.dt <- data.table(
  old.name = c("csize.std", "isize.std", "fsize.std"),
  new.name = c("$CompetitorSize$", "$IndustrySize$", "$FundSize$"))
fe.list <- rbind(
  c("Fixed Effects", rep("", 4)),
  c("$\\bullet$ Fund", rep("Yes", 4)),
  c("$\\bullet$ Month", rep("No", 3), "Yes"))
rt.base <- RegTable(r.base, fe.list = fe.list, coef.lab.dt = coef.lab.dt)

# label regression table
tab.base <- list(
  results = rt.base,
  title = "Decreasing Returns to Competitor Scale",
  caption = "Observations are at the fund-month level, over the period 1980-2016. The dependent variable is three-factor adjusted gross returns, in annualized percentages. $CompetitorSize$ and $IndustrySize$ are normalized by their respective sample standard deviations. $FundSize$ is normalized by the difference between the 50th and 10th percentile of its distribution. Standard errors are double clustered by fund and year-month $\\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Returns and Competitor Scale, Pre-2008 ---------------------------------------

# run regressions
r.base.08 <- lapply(m.base, felm, combined[date <= "Dec 2007"])

# construct regression table
rt.base.08 <- RegTable(r.base.08, fe.list = fe.list, coef.lab.dt = coef.lab.dt)

# label regression table
tab.base.08 <- list(
  results = rt.base.08,
  title = "Decreasing Returns to Competitor Scale --- Pre-2008 Data",
  caption = "Observations are at the fund-month level, over the period 1980-2007. The dependent variable is three-factor adjusted gross returns, in annualized percentages. $CompetitorSize$ and $IndustrySize$ are normalized by their respective sample standard deviations. $FundSize$ is normalized by the difference between the 50th and 10th percentile of its distribution. Standard errors are double clustered by fund and year-month $\\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Role of Portfolio Liquidity --------------------------------------------------

# fund-level means of L, S, D, C, B
plv <- c("L", "S", "D", "C", "B")
plv.bar <- paste0(plv, ".bar")
plv.both <- c(plv, plv.bar)
# fund-level mean portfolio liquidity vars
combined[, (plv.bar) :=
  lapply(.SD, mean, na.rm = TRUE), by = wficn, .SDcols = plv]
# normalize by interquartile range
combined[, (plv.both) :=
  lapply(.SD, function(x) x / IQR(x, na.rm = TRUE)), .SDcols = plv.both]

# function for running regressions; first rename interaction variable to X
XRegFn <- function(x, dt.txt, include.main = FALSE) {
  setnames(eval(parse(text = dt.txt)), x, "X")
  if (include.main) {
    reg.spec <- "ra.gross.ff3 ~ csize.std:X + fsize.std:X + X +
    csize.std + fsize.std | wficn + date | 0 | wficn + date.port.grp"
  } else {
    reg.spec <- "ra.gross.ff3 ~ csize.std:X + fsize.std:X +
      csize.std + fsize.std | wficn + date | 0 | wficn + date.port.grp"
  }
  this.reg <- felm(as.formula(reg.spec), eval(parse(text = dt.txt)))
  setnames(eval(parse(text = dt.txt)), "X", x)
  return(this.reg)
}

# regressions using interactions with fund-level means
r.liqA <- lapply(plv.bar, function(x) XRegFn(x, "combined"))
# regressions using real-time interactions
r.liqB <- lapply(plv, function(x) XRegFn(x, "combined", include.main = TRUE))

# label coefficients
coef.lab.dtA <- data.table(
  old.name = c("csize.std:X", "X:fsize.std", "csize.std", "fsize.std"),
  new.name = c("$Comp.Size \\times \\bar{X}$", "$FundSize \\times \\bar{X}$",
               "$CompetitorSize$", "$FundSize$"),
  position = 1:4)
coef.lab.dtB <- data.table(
  old.name = c("csize.std:X", "X:fsize.std", "X", "csize.std", "fsize.std"),
  new.name = c("$Comp.Size \\times X$", "$FundSize \\times X$", "$X$",
               "$CompetitorSize$", "$FundSize$"))
# label fixed effects
fe.list <- rbind(
  c("Fixed Effects", rep("", 5)),
  c("$\\bullet$ Fund", rep("Yes", 5)),
  c("$\\bullet$ Month", rep("Yes", 5)))
rt.liqA <- RegTable(r.liqA,
  fe.list = fe.list, coef.lab.dt = coef.lab.dtA, col.names = plv)
rt.liqB <- RegTable(r.liqB,
  fe.list = fe.list, coef.lab.dt = coef.lab.dtB, col.names = plv)
rt.liq <- rbind(rt.liqA, rt.liqB)
setnames(rt.liq, "V1", "X =")

# label output regression table
tab.liq <- list(
  results = rt.liq,
  sub.results = list(fund.level = rt.liqA, real.time = rt.liqB),
  title = "The Role of Portfolio Liquidity",
  caption = "Observations are at the fund-month level, over the period 1980-2016. The dependent variable is three-factor adjusted gross returns, in annualized percentages. $L$, $S$, $D$, $C$, $B$ are portfolio liquidity, stock liquidity, diversification, coverage, and balance, as defined in \\citet{pst17L}. $\\bar{L}$, $\\bar{S}$, $\\bar{D}$, $\\bar{C}$, $\\bar{B}$ denote fund-level means. Each $X$ variable is normalized by its interquartile range. Standard errors are double clustered by fund and year-month $\\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Role of Portfolio Liquidity, Pre-2008 ----------------------------------------

# regressions using interactions with fund-level means
combined08 <- combined[date <= "Dec 2007"]
r.liqA.08 <- lapply(plv.bar, function(x) XRegFn(x, "combined08"))
# regressions using real-time interactions
r.liqB.08 <- lapply(plv, function(x) XRegFn(x, "combined08", include.main=TRUE))

# format reg tables
rt.liqA.08 <- RegTable(r.liqA.08,
  fe.list = fe.list, coef.lab.dt = coef.lab.dtA, col.names = plv)
rt.liqB.08 <- RegTable(r.liqB.08,
  fe.list = fe.list, coef.lab.dt = coef.lab.dtB, col.names = plv)
rt.liq.08 <- rbind(rt.liqA.08, rt.liqB.08)
setnames(rt.liq.08, "V1", "X =")

# label output regression table
tab.liq.08 <- list(
  results = rt.liq.08,
  sub.results = list(fund.level = rt.liqA.08, real.time = rt.liqB.08),
  title = "The Role of Portfolio Liquidity --- Pre-2008 Data",
  caption = "Observations are at the fund-month level, over the period 1980-2007. The dependent variable is three-factor adjusted gross returns, in annualized percentages. $L$, $S$, $D$, $C$, $B$ are portfolio liquidity, stock liquidity, diversification, coverage, and balance, as defined in \\citet{pst17L}. $\\bar{L}$, $\\bar{S}$, $\\bar{D}$, $\\bar{C}$, $\\bar{B}$ denote fund-level means. Each $X$ variable is normalized by its interquartile range. Standard errors are double clustered by fund and year-month $\\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: *** p<0.01, ** p<0.05, * p<0.1.")


# Collect and Save -------------------------------------------------------------
tab.ret <- list(
  baseline     = tab.base,
  liquidity    = tab.liq,
  baseline.08  = tab.base.08,
  liquidity.08 = tab.liq.08)
saveRDS(tab.ret, "tab/reg_performance.Rds")
