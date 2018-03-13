# Laszlo Jakab
# Mar, 2018

# Setup ------------------------------------------------------------------------

# packages
library(lfe)

# source functions for displaying regressions
source("R/functions/RegDisplay_Fn.R")

# load data
combined <- readRDS("data/combined/combined.Rds")


# Decreasing Returns to Competitor Scale ---------------------------------------

# standardize variables
combined[, `:=` (
  csize.std  = comp.size / sd(comp.size, na.rm = TRUE),
  isize.std = industry.size / sd(industry.size, na.rm = TRUE),
  fsize.std  = fund.size /
    (quantile(fund.size, .5, na.rm = TRUE)-quantile(fund.size, .1, na.rm = TRUE))
)]

# regression specifications
ys  <- "ra.gross.ff3"
xs  <- c("csize.std", "isize.std",
  "csize.std + isize.std", "csize.std + fsize.std")
fes <- c(rep("wficn", 3), "wficn + date")
ivs <- "0"
cls <- "wficn + date.port.grp"

models.performance <- paste(paste(ys, xs, sep = " ~ "), fes, ivs, cls, sep = " | ")

# run regressions
res.performance <- lapply(models.performance,
  function(x) felm(as.formula(x), combined))

# construct regression table
coef.lab.dt <- data.table(
  old.name = c("csize.std", "isize.std", "fsize.std"),
  new.name = c("$CompetitorSize$", "$IndustrySize$", "$FundSize$"),
  position = 1:3)
fe.list <- rbind(
  c("Fixed Effects", rep("", 4)),
  c("$\\bullet$ Fund", rep("Yes", 4)),
  c("$\\bullet$ Month", rep("No", 3), "Yes"))
rt.performance <- RegTable(res.performance,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt)

# label regression table
ret.baseline.tab <- list(
  results = rt.performance,
  title = "Decreasing Returns to Competitor Scale",
  caption = "The regression sample contains actively managed domestic equity mutual funds from 1980 to 2016. The dependent variable is three-factor adjusted gross returns, in annualized percentages. Size variables are as defined in Section \\@ref(sec:CompetitorSize). $CompetitorSize$ and $IndustrySize$ are normalized by their respective sample standard deviations. $FundSize$ is normalized by the difference between the 50th and 10th percentile of its distribution. Each fund is assigned to one of ten portfolio group clusters each month based on k-means clustering of most recent portfolio holdings. Standard errors are double clustered by fund and year-month $\\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# Decreasing Returns to Competitor Scale, Pre-2008 ---------------------------------------

# run regressions
res.performance.08 <- lapply(models.performance,
  function(x) felm(as.formula(x), combined[date < "Dec 2007"]))

# construct regression table
rt.performance.08 <- RegTable(res.performance.08,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt)

# label regression table
ret.baseline.tab.08 <- list(
  results = rt.performance.08,
  title = "Decreasing Returns to Competitor Scale",
  caption = "The regression sample contains actively managed domestic equity mutual funds from 1980 to 2007. The dependent variable is three-factor adjusted gross returns, in annualized percentages. Size variables are as defined in Section \\@ref(sec:CompetitorSize). $CompetitorSize$ and $IndustrySize$ are normalized by their respective sample standard deviations. $FundSize$ is normalized by the difference between the 50th and 10th percentile of its distribution. Each fund is assigned to one of ten portfolio group clusters each month based on k-means clustering of most recent portfolio holdings. Standard errors are double clustered by fund and year-month $\\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# The Role of Portfolio Liquidity ----------------------------------------------

# fund-level means of L, S, D, C, B
pl.var <- c("L", "S", "D", "C", "B")
pl.var.bar <- paste0(pl.var, ".bar")
pl.both <- c(pl.var, pl.var.bar)
# fund-level mean portfolio liquidity vars
combined[, (pl.var.bar) :=
  lapply(.SD, mean, na.rm = TRUE), by = wficn, .SDcols = pl.var]
# normalize by interquartile range
combined[, (pl.both) :=
  lapply(.SD, function(x) x / IQR(x, na.rm = TRUE)), .SDcols = pl.both]

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
res.role.liqA <- lapply(pl.var.bar,
  function(x) XRegFn(x, "combined"))
# regressions using real-time interactions
res.role.liqB <- lapply(pl.var,
  function(x) XRegFn(x, "combined", include.main = TRUE))

# label coefficients
coef.lab.dtA <- data.table(
  old.name = c("csize.std:X", "X:fsize.std", "csize.std", "fsize.std"),
  new.name = c("$Comp.Size \\times \\bar{X}$", "$FundSize \\times \\bar{X}$",
               "$CompetitorSize$", "$FundSize$"),
  position = 1:4)
coef.lab.dtB <- data.table(
  old.name = c("csize.std:X", "X:fsize.std", "X", "csize.std", "fsize.std"),
  new.name = c("$Comp.Size \\times X$", "$FundSize \\times X$", "$X$",
               "$CompetitorSize$", "$FundSize$"),
  position = 1:5)
# label fixed effects
fe.list <- rbind(
  c("Fixed Effects", rep("", 5)),
  c("$\\bullet$ Fund", rep("Yes", 5)),
  c("$\\bullet$ Month", rep("Yes", 5)))
rt.role.liqA <- RegTable(res.role.liqA,
  fe.list = fe.list, coef.lab.dt = coef.lab.dtA, col.names = pl.var)
rt.role.liqB <- RegTable(res.role.liqB,
  fe.list = fe.list, coef.lab.dt = coef.lab.dtB, col.names = pl.var)
rt.role.liq <- rbind(rt.role.liqA, rt.role.liqB)
setnames(rt.role.liq, "V1", "X =")

# label output regression table
ret.liq.tab <- list(
  results = rt.role.liq,
  sub.results = list(fund.level = rt.role.liqA, real.time = rt.role.liqB),
  title = "The Role of Portfolio Liquidity",
  caption = "The dependent variable is three-factor adjusted gross returns, in annualized percentages. Size variables are normalized according to the Table \\@ref(tab:mainResults) caption. $L$, $S$, $D$, $C$, $B$ are portfolio liquidity, stock liquidity, diversification, coverage, and balance, as defined in @pst17L. $\\bar{L}$, $\\bar{S}$, $\\bar{D}$, $\\bar{C}$, $\\bar{B}$ denote fund-level means. $X$ variables are normalized by interquartile range. Each fund is assigned to one of ten portfolio group clusters each month based on k-means clustering of most recent portfolio holdings. Standard errors are double clustered by fund and year-month $\\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# The Role of Portfolio Liquidity, Pre-2008 ------------------------------------

# regressions using interactions with fund-level means
combined08 <- combined[date <= "Dec 2007"]
res.role.liqA.08 <- lapply(pl.var.bar,
  function(x) XRegFn(x, "combined08"))
# regressions using real-time interactions
res.role.liqB.08 <- lapply(pl.var,
  function(x) XRegFn(x, "combined08", include.main = TRUE))

# format reg tables
rt.role.liqA.08 <- RegTable(res.role.liqA.08,
  fe.list = fe.list, coef.lab.dt = coef.lab.dtA, col.names = pl.var)
rt.role.liqB.08 <- RegTable(res.role.liqB.08,
  fe.list = fe.list, coef.lab.dt = coef.lab.dtB, col.names = pl.var)
rt.role.liq.08 <- rbind(rt.role.liqA.08, rt.role.liqB.08)
setnames(rt.role.liq.08, "V1", "X =")

# label output regression table
ret.liq.tab.08 <- list(
  results = rt.role.liq.08,
  sub.results = list(fund.level = rt.role.liqA.08, real.time = rt.role.liqB.08),
  title = "The Role of Portfolio Liquidity --- Pre-2008 data",
  caption = "The dependent variable is three-factor adjusted gross returns, in annualized percentages. Size variables are normalized according to the Table \\@ref(tab:mainResults) caption. $L$, $S$, $D$, $C$, $B$ are portfolio liquidity, stock liquidity, diversification, coverage, and balance, as defined in @pst17L. $\\bar{L}$, $\\bar{S}$, $\\bar{D}$, $\\bar{C}$, $\\bar{B}$ denote fund-level means. $X$ variables are normalized by interquartile range. Each fund is assigned to one of ten portfolio group clusters each month based on k-means clustering of most recent portfolio holdings. Standard errors are double clustered by fund and year-month $\\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# Collect and Save -------------------------------------------------------------
ret.tab <- list(
  baseline     = ret.baseline.tab,
  liquidity    = ret.liq.tab,
  baseline.08  = ret.baseline.tab.08,
  liquidity.08 = ret.liq.tab.08)
saveRDS(ret.tab, "tab/reg_performance.Rds")
