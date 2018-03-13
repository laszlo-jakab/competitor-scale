# Laszlo Jakab
# Mar 8, 2018

# Setup ------------------------------------------------------------------

# packages
library(lfe)

# dataset
scandal.dt <- readRDS("data/scandal/scandal_dt.Rds")

# source function for displaying regression results
source("R/functions/RegDisplay_Fn.R")
source("R/functions/FeedFERegData.R")


# Coef Label Table  ------------------------------------------------------------

coef.lab.dt <- data.table(
  rbind(c("postXscan",       "$\\mathbb{I}\\times ScanEx$"),
        c("scandal.outflow", "$ScandalOutflow$"),
        c("ln.CS",           "$\\ln(CompetitorSize)$"),
        c("`ln.CS(fit)`",    "$\\ln(CompetitorSize)$"),
        c("scandal.exposure:date", "$t \\times ScanEx$"),
        c("ln.fund.size",    "$\\ln(FundSize)$"),
        c("ln.f",            "$\\ln(f)$"),
        c("ln.T",            "$\\ln(T)$"),
        c("ln.D",            "$\\ln(D)$"),
        c("ln.S",            "$\\ln(S)$"),
        c("ln.B",            "$\\ln(B)$"),
        c("ln.C",            "$\\ln(C)$")
        ))
setnames(coef.lab.dt, c("old.name", "new.name"))


# Reg Model Components ---------------------------------------------------------

ys <- c("ln.CS", "ln.AS", "ln.TL", "ln.L", "ln.S", "ln.D", "ln.C", "ln.B")
ys.iv <- ys[2:length(ys)]

ctrls <- c(
  rep("ln.fund.size + ln.f", 3),
  "ln.fund.size + ln.f + ln.T",
  "ln.fund.size + ln.f + ln.T + ln.D",
  "ln.fund.size + ln.f + ln.T + ln.S",
  "ln.fund.size + ln.f + ln.T + ln.S + ln.B",
  "ln.fund.size + ln.f + ln.T + ln.S + ln.C")
ctrls.iv <- ctrls[2:length(ctrls)]

fes    <- "wficn + date"
fes.bm <- "wficn + benchmark.X.date"

ivs <- "0"
ivs.2sls <- "(ln.CS ~ scandal.outflow)"

cls    <- "wficn + date.port.grp"
cls.bm <- "wficn + benchmark.X.date"

xs.did <- "postXscan"
xs.sof <- "scandal.outflow"
xs.pt  <- "scandal.exposure:date"


# DiD  --------------------------------------------------------------

# data
did.1yr.dt <- c(
  rep("scandal.dt[did.1yr == TRUE & date == rdate]", 2),
  "scandal.dt[did.1yr == TRUE]",
  rep("scandal.dt[did.1yr == TRUE & date == rdate]", 5))
did.2yr.dt <- c(
  rep("scandal.dt[did.2yr == TRUE & date == rdate]", 2),
  "scandal.dt[did.2yr == TRUE]",
  rep("scandal.dt[did.2yr == TRUE & date == rdate]", 5))

# regression models
did.models <- paste(paste(paste(ys, xs.did, sep = " ~ "), ctrls, sep = " + "),
  fes, ivs, cls, sep = " | ")

# run regressions
did.1yr.res <- Map(FeedFERegData, did.models, did.1yr.dt)
did.2yr.res <- Map(FeedFERegData, did.models, did.2yr.dt)

# format regression output
fe.list <- rbind(
  c("Fixed Effects", rep("", 8)),
  c("$\\bullet$ Fund", rep("Yes", 8)),
  c("$\\bullet$ Time", rep("Yes", 8)))
did.1yr.rt <- RegTable(did.1yr.res,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = ys)
did.2yr.rt <- RegTable(did.2yr.res,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = ys)
did.rt <- rbind(did.1yr.rt, did.2yr.rt)

# label output table
did.tab <- list(
  results = did.rt,
  sub.results = list(w1yr = did.1yr.rt, w2yr = did.2yr.rt),
  title = "Capital Allocation and the Scandal: Before and After Analysis",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. For regressions with $\\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. The estimation sample includes only funds not directly involved in the scandal. It covers the period $\\{(2003m8-W, 2003m8], [2004m11, 2004m11 + W) \\}$, where $W$ corresponds to the number of years specified. $ScandalExposure$ (abbreviated to $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003 (see Section \\@ref(sec:scandalID) for details). I normalize $ScandalExposure$ by its interquartile range. $\\mathbb{I}$ is an indicator for the post scandal period. Standard errors are double clustered by fund and portfolio group $\\times$ date, and reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# DiD: Bm X Time ---------------------------------------------------------------

# reg specification
did.models.bm <- paste(paste(paste(ys, xs.did, sep = " ~ "), ctrls,
  sep = " + "), fes.bm, ivs, cls.bm, sep = " | ")

# run regressions
did.1yr.res.bm <- Map(FeedFERegData, did.models.bm, did.1yr.dt)
did.2yr.res.bm <- Map(FeedFERegData, did.models.bm, did.2yr.dt)

# format regression output
fe.list.bm <- rbind(
  c("Fixed Effects", rep("", 8)),
  c("$\\bullet$ Fund", rep("Yes", 8)),
  c("$\\bullet$ Benchmark $\\times$ Time", rep("Yes", 8)))
did.1yr.rt.bm <- RegTable(did.1yr.res.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = ys)
did.2yr.rt.bm <- RegTable(did.2yr.res.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = ys)
did.rt.bm <- rbind(did.1yr.rt.bm, did.2yr.rt.bm)

# label output table
did.tab.bm <- list(
  results = did.rt.bm,
  sub.results = list(w1yr = did.1yr.rt.bm, w2yr = did.2yr.rt.bm),
  title = "Capital Allocation and the Scandal: Before and After Analysis --- Benchmark $\\times$ Date FE",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. For regressions with $\\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. The estimation sample includes only funds not directly involved in the scandal. It covers the period $\\{(2003m8-W, 2003m8], [2004m11, 2004m11 + W) \\}$, where $W$ corresponds to the number of years specified. $ScandalExposure$ (abbreviated to $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003 (see Section \\@ref(sec:scandalID) for details). I normalize $ScandalExposure$ by its interquartile range. $\\mathbb{I}$ is an indicator for the post scandal period. Standard errors are double clustered by fund and benchmark $\\times$ date, and reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# Pre-Trend --------------------------------------------------------------------

# data
pt.1yr.dt <- c(
  rep("scandal.dt[did.1yr == TRUE & date == rdate & date < 'Sep 2003']", 2),
  "scandal.dt[did.1yr == TRUE & date < 'Sep 2003']",
  rep("scandal.dt[did.1yr == TRUE & date == rdate & date < 'Sep 2003']", 5))
pt.2yr.dt <- c(
  rep("scandal.dt[did.2yr == TRUE & date == rdate & date < 'Sep 2003']", 2),
  "scandal.dt[did.2yr == TRUE & date < 'Sep 2003']",
  rep("scandal.dt[did.2yr == TRUE & date == rdate & date < 'Sep 2003']", 5))

# regression models
pt.models <- paste(paste(paste(ys, xs.pt, sep = " ~ "),
  ctrls, sep = " + "), fes, ivs, cls, sep = " | ")

# run regressions
pt.1yr.res <- Map(FeedFERegData, pt.models, pt.1yr.dt)
pt.2yr.res <- Map(FeedFERegData, pt.models, pt.2yr.dt)

# format regression output
pt.1yr.rt <- RegTable(pt.1yr.res,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = ys)
pt.2yr.rt <- RegTable(pt.2yr.res,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = ys)
pt.rt <- rbind(pt.1yr.rt, pt.2yr.rt)

# label output table
pt.tab <- list(
  results = pt.rt,
  sub.results = list(w1yr = pt.1yr.rt, w2yr = pt.2yr.rt),
  title = "Capital Allocation and the Scandal: Testing for Pre-Trends",
  caption = "The estimation sample includes only funds not directly involved in the scandal, over the period $[2003m8-W, 2003m8]$. Dependent variables are noted in the table header. For regressions with $\\ln(TL^{-1/2)$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. $ScandalExposure$ (abbreviated $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. I normalize $ScandalExposure$ by its interquartile range. See Section \\@ref(sec:scandalID) for details. Standard errors are reported in parentheses. Errors are double clustered by fund and portfolio group $\times$ time. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# Pre-Trend: Bm X Time ---------------------------------------------------------

# regression models
pt.models.bm <- paste(paste(paste(ys, xs.pt, sep = " ~ "),
  ctrls, sep = " + "), fes.bm, ivs, cls, sep = " | ")

# run regressions
pt.1yr.res.bm <- Map(FeedFERegData, pt.models.bm, pt.1yr.dt)
pt.2yr.res.bm <- Map(FeedFERegData, pt.models.bm, pt.2yr.dt)

# format regression output
pt.1yr.rt.bm <- RegTable(pt.1yr.res.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = ys)
pt.2yr.rt.bm <- RegTable(pt.2yr.res.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = ys)
pt.rt.bm <- rbind(pt.1yr.rt.bm, pt.2yr.rt.bm)

# label output table
pt.tab.bm <- list(
  results = pt.rt.bm,
  sub.results = list(w1yr = pt.1yr.rt.bm, w2yr = pt.2yr.rt.bm),
  title = "Capital Allocation and the Scandal: Testing for Pre-Trends --- Benchmark $\\times$ Time FE",
  caption = "The estimation sample includes only funds not directly involved in the scandal, over the period $[2003m8-W, 2003m8]$. Dependent variables are noted in the table header. For regressions with $\\ln(TL^{-1/2)$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. $ScandalExposure$ (abbreviated $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. I normalize $ScandalExposure$ by its interquartile range. See Section \\@ref(sec:scandalID) for details. Standard errors are reported in parentheses. Errors are double clustered by fund and benchmark $\times$ time. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# ScandalOutFlow ---------------------------------------------------------------

# regression models to estimate
sof.models <- paste(paste(paste(ys, xs.sof, sep = " ~ "), ctrls, sep = " + "),
  fes, ivs, cls, sep = " | ")

# data on which to estimate each specification
sof.1yr.dt <- c(
  rep("scandal.dt[sample.1yr == TRUE & date == rdate]", 2),
  "scandal.dt[sample.1yr == TRUE]",
  rep("scandal.dt[sample.1yr == TRUE & date == rdate]", 5))
sof.2yr.dt <- c(
  rep("scandal.dt[sample.2yr == TRUE & date == rdate]", 2),
  "scandal.dt[sample.2yr == TRUE]",
  rep("scandal.dt[sample.2yr == TRUE & date == rdate]", 5))

# run regressions
sof.1yr.res <- Map(FeedFERegData, sof.models, sof.1yr.dt)
sof.2yr.res <- Map(FeedFERegData, sof.models, sof.2yr.dt)

# format regression output
sof.1yr.rt <- RegTable(sof.1yr.res,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = ys)
sof.2yr.rt <- RegTable(sof.2yr.res,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = ys)
sof.rt <- rbind(sof.1yr.rt, sof.2yr.rt)

# label regression output
sof.tab <- list(
  results = sof.rt,
  sub.results = list(w1yr = sof.1yr.rt, w2yr = sof.2yr.rt),
  title = "Capital Allocation and the Scandal: Using Abnormal Flows",
  caption = "Dependent variables are identified in the column headers. For regressions with $\\ln\\left(TL^{-\\frac{1}{2}}\\right)$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. The estimation sample includes untainted funds during $\\{[2003m9-W, 2004m10+W] \\}$, where $W$ corresponds to the number of years specified at the bottom of each panel. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. See Section \\@ref(sec:linkFlows) for details on the variable's construction. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Standard errors are double clustered by fund and portfolio group $\\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# ScandalOutFlow: Bm X Time ---------------------------------------------------

# regression models to estimate
sof.models.bm <- paste(paste(paste(ys, xs.sof, sep = " ~ "), ctrls,
  sep = " + "), fes.bm, ivs, cls.bm, sep = " | ")

# run models
sof.1yr.res.bm <- Map(FeedFERegData, sof.models.bm, sof.1yr.dt)
sof.2yr.res.bm <- Map(FeedFERegData, sof.models.bm, sof.2yr.dt)

# format regression output
sof.1yr.rt.bm <- RegTable(sof.1yr.res.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = ys)
sof.2yr.rt.bm <- RegTable(sof.2yr.res.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = ys)
sof.rt.bm <- rbind(sof.1yr.rt.bm, sof.2yr.rt.bm)

# label regression output
sof.tab.bm <- list(
  results = sof.rt.bm,
  sub.results = list(w1yr = sof.1yr.rt.bm, w2yr = sof.2yr.rt.bm),
  title = "Capital Allocation and the Scandal: Using Abnormal Flows --- Benchmark $\\times$ Time FE",
  caption = "Dependent variables are identified in the column headers. For regressions with $\\ln\\left(TL^{-\\frac{1}{2}}\\right)$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. The estimation sample includes untainted funds during $\\{[2003m9-W, 2004m10+W] \\}$, where $W$ corresponds to the number of years specified at the bottom of each panel. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. See Section \\@ref(sec:linkFlows) for details on the variable's construction. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Standard errors are double clustered by fund and benchmark $\\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast$ p$<$0.01, $\\ast\\ast$ p$<$0.05, $\\ast$ p$<$0.1.")


# IV: ScandalOutflow -----------------------------------------------------------

# data on which to estimate each specification
sof.1yr.dt.iv <- c(
  "scandal.dt[sample.1yr == TRUE & date == rdate]",
  "scandal.dt[sample.1yr == TRUE]",
  rep("scandal.dt[sample.1yr == TRUE & date == rdate]", 5))
sof.2yr.dt.iv <- c(
  "scandal.dt[sample.2yr == TRUE & date == rdate]",
  "scandal.dt[sample.2yr == TRUE]",
  rep("scandal.dt[sample.2yr == TRUE & date == rdate]", 5))

# regression models to estimate
sof.models.iv <- paste(paste(ys.iv, ctrls.iv, sep = " ~ "),
  fes, ivs.2sls, cls, sep = " | ")

# run regressions
sof.1yr.res.iv <- Map(FeedFERegData, sof.models.iv, sof.1yr.dt.iv)
sof.2yr.res.iv <- Map(FeedFERegData, sof.models.iv, sof.2yr.dt.iv)

# format regression output
sof.1yr.rt.iv <- RegTable(sof.1yr.res.iv,
  fe.list = fe.list[, 1:(ncol(fe.list) - 1)], coef.lab.dt = coef.lab.dt)
sof.2yr.rt.iv <- RegTable(sof.2yr.res.iv,
  fe.list = fe.list[, 1:(ncol(fe.list) - 1)], coef.lab.dt = coef.lab.dt)
sof.rt.iv <- rbind(sof.1yr.rt.iv, sof.2yr.rt.iv)

# label regression output
sof.tab.iv <- list(
  results = sof.rt.iv,
  sub.results = list(w1yr = sof.1yr.rt.iv, w2yr = sof.2yr.rt.iv),
  title = "Capital Allocation and the Scandal: Instrumenting Competitor Size with Abnormal Flows",
  caption = "The estimation sample includes only funds not directly involved in the scandal, over the period $\\{[2003m9-W, 2004m10+W] \\}$, where $W$ corresponds to the number of years specified. Dependent variables are noted in the column headers. For regressions with $\\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. See Section \\@ref(sec:linkFlows) for details on the variable's construction. I estimate regressions via two stage least squares, instrumenting for $\\ln(CompetitorSize_{i,t})$ with $ScandalOutFlow_{i,t}$. The F-statistic of the first stage relation is reported at the bottom of each panel. Standard errors are double clustered by fund and portfolio group $\\times$ time, and are reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# IV: ScandalOutflow: Bm X Date FE ---------------------------------------------

# regression models to estimate
sof.models.iv.bm <- paste(paste(ys.iv, ctrls.iv, sep = " ~ "),
  fes.bm, ivs.2sls, cls.bm, sep = " | ")

# run regressions
sof.1yr.res.iv.bm <- Map(FeedFERegData, sof.models.iv.bm, sof.1yr.dt.iv)
sof.2yr.res.iv.bm <- Map(FeedFERegData, sof.models.iv.bm, sof.2yr.dt.iv)

# format regression output
sof.1yr.rt.iv.bm <- RegTable(sof.1yr.res.iv.bm,
  fe.list = fe.list[, 1:(ncol(fe.list) - 1)], coef.lab.dt = coef.lab.dt)
sof.2yr.rt.iv.bm <- RegTable(sof.2yr.res.iv.bm,
  fe.list = fe.list[, 1:(ncol(fe.list) - 1)], coef.lab.dt = coef.lab.dt)
sof.rt.iv.bm <- rbind(sof.1yr.rt.iv.bm, sof.2yr.rt.iv.bm)

# label regression output
sof.tab.iv.bm <- list(
  results = sof.rt.iv.bm,
  sub.results = list(w1yr = sof.1yr.rt.iv.bm, w2yr = sof.2yr.rt.iv.bm),
  title = "Capital Allocation and the Scandal: Instrumenting Competitor Size with Abnormal Flows --- Benchmark $\\times$ Time FE",
  caption = "The estimation sample includes only funds not directly involved in the scandal, over the period $\\{[2003m9-W, 2004m10+W] \\}$, where $W$ corresponds to the number of years specified. Dependent variables are noted in the column headers. For regressions with $\\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. See Section \\@ref(sec:linkFlows) for details on the variable's construction. I estimate regressions via two stage least squares, instrumenting for $\\ln(CompetitorSize_{i,t})$ with $ScandalOutFlow_{i,t}$. The F-statistic of the first stage relation is reported at the bottom of each panel. Standard errors are double clustered by fund and benchmark $\\times$ time, and are reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# Performance ------------------------------------------------------------------

# specifications to estimate
ys.p <- "ra.gross.ff3"
xs.p <- c(rep(xs.did, 2), rep(xs.sof, 2), rep("", 2))
ctrls.p <- "ln.fund.size"
fes.p <- rep(c(fes, fes.bm), 3)
ivs.p <- c(rep(ivs, 4), rep(ivs.2sls, 2))
cls.p <- rep(c(cls, cls.bm), 3)

perf.models <- paste(paste(paste(ys.p, xs.p, sep = " ~ "),
  ctrls.p, sep = " + "), fes.p, ivs.p, cls.p, sep = " | ")

# data over which to estimate specifications
perf.1yr.dt <- c(
  rep("scandal.dt[did.1yr == TRUE]", 2),
  rep("scandal.dt[sample.1yr == TRUE]", 4))
perf.2yr.dt <- c(
  rep("scandal.dt[did.2yr == TRUE]", 2),
  rep("scandal.dt[sample.2yr == TRUE]", 4))

# run regressions
perf.1yr.res <- Map(FeedFERegData, perf.models, perf.1yr.dt)
perf.2yr.res <- Map(FeedFERegData, perf.models, perf.2yr.dt)

# label reg tables
fe.list.p <- rbind(
  c("Fixed Effects", rep("", 6)),
  c("$\\bullet$ Fund", rep("Yes", 6)),
  c("$\\bullet$ Month", rep(c("Yes", "No"), 3)),
  c("$\\bullet$ Benchmark $\\times$ Month", rep(c("No", "Yes"), 3)))

perf.1yr.rt <- RegTable(perf.1yr.res,
  fe.list = fe.list.p, coef.lab.dt = coef.lab.dt)
perf.2yr.rt <- RegTable(perf.2yr.res,
  fe.list = fe.list.p, coef.lab.dt = coef.lab.dt)

# label results
perf.rt <- rbind(perf.1yr.rt, perf.2yr.rt)
perf.tab <- list(
  results = perf.rt,
  sub.results = list(w1yr = perf.1yr.rt, w2yr = perf.2yr.rt),
  title = "Fund Performance and the Scandal",
  caption = "The dependent variable is Fama-French 3 factor adjusted gross returns, in annual percent units. Observations are monthly. The estimation sample includes only funds not tainted by the scandal. In columns (1)-(4) regressions are estimated by ordinary least squares. In columns (5)-(6), regressions are estimated by two stage least squares, instrumenting $\\ln(CompetitorSize)$ with $ScandalOutFlow$. In columns (1)-(2), the sample includes $\\{(2003m8-W, 2003m8], [2004m11,2004m11+W) \\}$, where $W$ corresponds to the number of years specified. In columns (3)-(6), the sample is taken over the period $\\{[2003m9-W, 2004m10+W] \\}$. $ScandalExposure$ (abbreviated to $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003 (see Section \\@ref(sec:scandalID) for details). I normalize $ScandalExposure$ by its interquartile range. $\\mathbb{I}$ is an indicator for the post scandal period. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. See Section \\@ref(sec:linkFlows) for details on the variable's construction. Benchmarks are the indexes which yield the lowest active share, taken from @petajisto13. Standard errors are double clustered by fund and portfolio group $\times$ month in columns (1)-(4), and by fund and benchmark $\\times$ month in columns (5)-(6). Standard errors are reported in parentheses. Asterisks denote statistical significance: $\\ast\\ast\\ast p<0.01$, $\\ast\\ast p<0.05$, $\\ast p<0.1$.")


# Combine and Save -------------------------------------------------------------

reg.tab.scandal <- list(
  did    = did.tab,
  did.bm = did.tab.bm,
  pt     = pt.tab,
  pt.bm  = pt.tab.bm,
  sof    = sof.tab,
  sof.bm = sof.tab.bm,
  iv     = sof.tab.iv,
  iv.bm  = sof.tab.iv.bm,
  perf = perf.tab
)
saveRDS(reg.tab.scandal, "tab/reg_scandal.Rds")

