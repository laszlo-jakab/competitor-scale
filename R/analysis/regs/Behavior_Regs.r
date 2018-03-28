# Laszlo Jakab
# Mar 2018

# Setup ------------------------------------------------------------------------

# libraries
library(lfe)
library(laszlor)

# load combined fund-month level data
combined <- readRDS("data/combined/combined.Rds")
# load quarter-to-quarter log competitor size change
dln.cs <- readRDS("data/competitor_size/dln_competitor_size.Rds")


# Prep Data ---------------------------------------------

# keep end of quarter report dates
combined <- combined[month(date) %in% c(3, 6, 9, 12) & date == rdate]

# get logs of active share, portfolio liquidity, fund size, and expense ratio
setnames(combined, c("activeshare", "exp_ratio", "To"), c("AS", "f", "T"))
vars <- c("AS", "L", "S", "D", "C", "B", "fund.size", "f", "T")
combined[, (paste0("ln.", vars)) := lapply(.SD, log), .SDcols = vars]

# FD log variables (note: interval for FD is not consistent for now)
ln.vars <- c("ln.AS", "ln.TL", "ln.L", "ln.S", "ln.D", "ln.C",
  "ln.B", "ln.fund.size", "ln.f", "ln.T")
combined[, (paste0("d", ln.vars)) := lapply(.SD, function(x) x - shift(x))
  , by = wficn, .SDcols = ln.vars]

# add in quasi-first differenced log competitor size
combined <- combined[dln.cs, on = c("wficn", "date"), nomatch = 0]

# keep only if FD interval is three months
combined <- combined[
  , dm := round((date - shift(date)) * 12), by = wficn][dm == 3]


# FD Regressions ---------------------------------------------------------------

y <- c("dln.AS", "dln.TL", "dln.L", "dln.S", "dln.D", "dln.C", "dln.B")
x1 <- "dln.comp.size"
x2 <- c(
  rep("dln.fund.size + dln.f", 2),
  "dln.fund.size + dln.f + dln.T",
  "dln.fund.size + dln.f + dln.T + dln.D",
  "dln.fund.size + dln.f + dln.T + dln.S",
  "dln.fund.size + dln.f + dln.T + dln.S + dln.B",
  "dln.fund.size + dln.f + dln.T + dln.S + dln.C")
fe <- "date"
iv <- "0"
cl <- "wficn + date.port.grp"
m.fd <- FormFELM(y, paste(x1, x2, sep = " + "), fe, iv, cl)

# run regressions
r.fd <- lapply(m.fd, felm, combined)

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

rt.fd <- RegTable(r.fd, fe.list = fe.list, coef.lab.dt = coef.lab.dt)

# label table
tab.fd <- list(
  results = rt.fd,
  title = "Capital Allocation and Competitor Scale",
  caption = "Observations are at the fund-quarter level, from 1980-2016. $\\Delta$ denotes first differences. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks from \\citet{petajisto13}, covering years 1980-2009. $T$ is turnover; $L$, $S$, $D$, $C$, and $B$ are respectively portfolio liquidity, stock liquidity, diversification, coverage, and balance, as defined in \\citet{pst17L}. $\\Delta CS_{i,t}=\\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t} \\right) - \\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t-1}\\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Standard errors are double clustered by fund and portfolio group $\\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# FD Regressions, Pre-2008 -----------------------------------------------------

# run regressions
r.fd.08 <- lapply(m.fd, felm, combined[date <= "Dec 2007"])

# output regression table
rt.fd.08 <- RegTable(r.fd.08, fe.list = fe.list, coef.lab.dt = coef.lab.dt)

# label table
tab.fd.08 <- list(
  results = rt.fd.08,
  title = "Capital Allocation and Competitor Scale --- Pre-2008 Data",
  caption = "Observations are at the fund-quarter level, from 1980-2007. $\\Delta$ denotes first differences. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks from \\citet{petajisto13}. $T$ is turnover; $L$, $S$, $D$, $C$, and $B$ are respectively portfolio liquidity, stock liquidity, diversification, coverage, and balance, as defined in \\citet{pst17L}. $\\Delta CS_{i,t}=\\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t} \\right) - \\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t-1}\\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Standard errors are double clustered by fund and portfolio group $\\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Benchmark X Date FE ----------------------------------------------------------

# update specification
fe.bm <- "benchmark.min.X.date"
cl.bm <- "wficn + benchmark.min.X.date"
m.fd.bm <- FormFELM(y, paste(x1, x2, sep = " + "), fe.bm, iv, cl.bm)

# run regressions
r.fd.bm <- lapply(m.fd.bm, felm, combined)

# format output table
fe.list.bm <- rbind(
  c("Fixed Effects", rep("", 7)),
  c("$\\bullet$ Benchmark $\\times$ Quarter", rep("Yes", 7)))
rt.fd.bm <- RegTable(r.fd.bm, fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt)

# label table
tab.fd.bm <- list(
  results = rt.fd.bm,
  title = "Capital Allocation and Competitor Scale --- Benchmark $\\times$ Quarter FE",
  caption = "Observations are at the fund-quarter level, from 1980-2007. $\\Delta$ denotes first differences. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks from \\citet{petajisto13}. $T$ is turnover; $L$, $S$, $D$, $C$, and $B$ are respectively portfolio liquidity, stock liquidity, diversification, coverage, and balance, as defined in \\citet{pst17L}. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Benchmark X Date FE, Pre-2008 ---------------------------------------------------

# run regressions
r.fd.bm.08 <- lapply(m.fd.bm, felm, combined[date <= "Dec 2007"])

# format output table
rt.fd.bm.08 <- RegTable(r.fd.bm.08,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt)

# label table
tab.fd.bm.08 <- list(
  results = rt.fd.bm.08,
  title = "Capital Allocation and Competitor Scale --- Benchmark $\\times$ Quarter FE, Pre-2008 Data",
  caption = "Observations are at the fund-quarter level, from 1980-2007. $\\Delta$ denotes first differences. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks from \\citet{petajisto13}. $T$ is turnover; $L$, $S$, $D$, $C$, and $B$ are respectively portfolio liquidity, stock liquidity, diversification, coverage, and balance, as defined in \\citet{pst17L}. $\\Delta CS_{i,t}=\\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t} \\right) - \\ln\\left(\\sum_{j\\neq i} \\psi_{i,j,t-1} FundSize_{j,t-1}\\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: \\*** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Collect and Save ------------------------------------------------------

behavior.tab <- list(
  baseline    = tab.fd,
  bm          = tab.fd.bm,
  baseline.08 = tab.fd.08,
  bm.08       = tab.fd.bm.08)
saveRDS(behavior.tab, "tab/reg_behavior.Rds")
