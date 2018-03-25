# Laszlo Jakab
# Mar 2018

# Setup ------------------------------------------------------------------

# packages
library(lfe)
library(laszlor)

# dataset
scandal <- readRDS("data/scandal/scandal_dt.Rds")


# Coef Label Table  ------------------------------------------------------------

coef.lab.dt <- data.table(
  rbind(c("postXscan",       "$\\mathbb{I}\\times ScanEx$"),
        c("scandal.outflow", "$ScandalOutFlow$"),
        c("ln.CS",           "$\\ln(CompetitorSize)$"),
        c("`ln.CS(fit)`",    "$\\ln(CompetitorSize)$"),
        c("`CS.std(fit)`",   "$CompetitorSize$"),
        c("scandal.exposure:date", "$t \\times ScanEx$"),
        c("scandal.outflow.m:date", "$t \\times \\overline{ScandalOutFlow}$"),
        c("ln.fund.size",    "$\\ln(FundSize)$"),
        c("fund.size.std",   "$FundSize$"),
        c("ln.f",            "$\\ln(f)$"),
        c("ln.T",            "$\\ln(T)$"),
        c("ln.D",            "$\\ln(D)$"),
        c("ln.S",            "$\\ln(S)$"),
        c("ln.B",            "$\\ln(B)$"),
        c("ln.C",            "$\\ln(C)$")
        ))
setnames(coef.lab.dt, c("old.name", "new.name"))


# Reg Model Components ---------------------------------------------------------

y <- c("ln.CS", "ln.AS", "ln.TL", "ln.L", "ln.S", "ln.D", "ln.C", "ln.B")
y.2sls <- y[2:length(y)]

x2 <- c(
  rep("ln.fund.size + ln.f", 3),
  "ln.fund.size + ln.f + ln.T",
  "ln.fund.size + ln.f + ln.T + ln.D",
  "ln.fund.size + ln.f + ln.T + ln.S",
  "ln.fund.size + ln.f + ln.T + ln.S + ln.B",
  "ln.fund.size + ln.f + ln.T + ln.S + ln.C")
x2.2sls <- x2[2:length(x2)]

fe    <- "wficn + date"
fe.bm <- "wficn + benchmark.min.X.date"

iv <- "0"
iv.2sls   <- "(ln.CS ~ scandal.outflow)"
iv.2sls.a <- "(CS.std ~ scandal.outflow)"

cl    <- "wficn + date.port.grp"
cl.bm <- "wficn + benchmark.min.X.date"

x.did <- "postXscan"
x.sof <- "scandal.outflow"
x.pt  <- "scandal.exposure:date"
x.pt.sof <- "scandal.outflow.m:date"


# DiD  --------------------------------------------------------------

# regression models
m.did <- FormFELM(y, paste(x.did, x2, sep = " + "), fe, iv, cl)

# run regressions
r.did.1yr <- lapply(m.did, felm, scandal[did.1yr == TRUE & date == rdate])
r.did.2yr <- lapply(m.did, felm, scandal[did.2yr == TRUE & date == rdate])

# format regression output
fe.list <- rbind(
  c("Fixed Effects", rep("", 8)),
  c("$\\bullet$ Fund", rep("Yes", 8)),
  c("$\\bullet$ Time", rep("Yes", 8)))
rt.did.1yr <- RegTable(r.did.1yr,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = y)
rt.did.2yr <- RegTable(r.did.2yr,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = y)
rt.did <- rbind(rt.did.1yr, rt.did.2yr)

# label output table
tab.did <- list(
  results = rt.did,
  sub.results = list(w1yr = rt.did.1yr, w2yr = rt.did.2yr),
  title = "Capital Allocation and the Scandal: Before and After Analysis",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Observations are at the fund-report date level, including only funds not directly involved in the scandal over the period $\\{(2003m8-W, 2003m8], [2004m11, 2004m11 + W) \\}$, where $W$ corresponds to the number of years specified. $ScandalExposure$ (abbreviated to $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. I normalize $ScandalExposure$ by its interquartile range. $\\mathbb{I}$ is an indicator for the post scandal period. Standard errors are double clustered by fund and portfolio group $\\times$ date, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# DiD: Bm X Time ---------------------------------------------------------------

# reg specification
m.did.bm <- FormFELM(y, paste(x.did, x2, sep = " + "), fe.bm, iv, cl.bm)

# run regressions
r.did.1yr.bm <- lapply(m.did.bm, felm, scandal[did.1yr == TRUE & date == rdate])
r.did.2yr.bm <- lapply(m.did.bm, felm, scandal[did.2yr == TRUE & date == rdate])

# format regression output
fe.list.bm <- rbind(
  c("Fixed Effects", rep("", 8)),
  c("$\\bullet$ Fund", rep("Yes", 8)),
  c("$\\bullet$ Benchmark $\\times$ Time", rep("Yes", 8)))
rt.did.1yr.bm <- RegTable(r.did.1yr.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = y)
rt.did.2yr.bm <- RegTable(r.did.2yr.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = y)
rt.did.bm <- rbind(rt.did.1yr.bm, rt.did.2yr.bm)

# label output table
tab.did.bm <- list(
  results = rt.did.bm,
  sub.results = list(w1yr = rt.did.1yr.bm, w2yr = rt.did.2yr.bm),
  title = "Capital Allocation and the Scandal: Before and After Analysis --- Benchmark $\\times$ Time FE",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Observations are at the fund-report date level, including only funds not directly involved in the scandal over the period $\\{(2003m8-W, 2003m8], [2004m11, 2004m11 + W) \\}$, where $W$ corresponds to the number of years specified. $ScandalExposure$ (abbreviated to $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. $ScandalExposure$ is normalized by its interquartile range. $\\mathbb{I}$ is an indicator for the post scandal period. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\\times$ date, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Pre-Trend --------------------------------------------------------------------

# regression models
m.pt <- FormFELM(y, paste(x.pt, x2, sep = " + "), fe, iv, cl)

# run regressions
r.pt.1yr <- lapply(m.pt, felm, scandal[
  did.1yr == TRUE & date == rdate & date < "Sep 2003"])
r.pt.2yr <- lapply(m.pt, felm, scandal[
  did.2yr == TRUE & date == rdate & date < "Sep 2003"])

# format regression output
rt.pt.1yr <- RegTable(r.pt.1yr,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = y)
rt.pt.2yr <- RegTable(r.pt.2yr,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = y)
rt.pt <- rbind(rt.pt.1yr, rt.pt.2yr)

# label output table
tab.pt <- list(
  results = rt.pt,
  sub.results = list(w1yr = rt.pt.1yr, w2yr = rt.pt.2yr),
  title = "Capital Allocation and $ScandalExposure$: Testing for Pre-Trends",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Observations are at the fund-report date level, including only funds not directly involved in the scandal over the period $[2003m8-W, 2003m8]$, where $W$ denotes the number of years specified. $ScandalExposure$ (abbreviated $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. $ScandalExposure$ is normalized by its interquartile range. Standard errors are double clustered by fund and portfolio group $\\times$ time, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Pre-Trend: Bm X Time ---------------------------------------------------------

# regression models
m.pt.bm <- FormFELM(y, paste(x.pt, x2, sep = " + "), fe.bm, iv, cl)

# run regressions
r.pt.1yr.bm <- lapply(m.pt.bm, felm, scandal[
  did.1yr == TRUE & date == rdate & date < "Sep 2003"])
r.pt.2yr.bm <- lapply(m.pt.bm, felm, scandal[
  did.2yr == TRUE & date == rdate & date < "Sep 2003"])

# format regression output
rt.pt.1yr.bm <- RegTable(r.pt.1yr.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = y)
rt.pt.2yr.bm <- RegTable(r.pt.2yr.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = y)
rt.pt.bm <- rbind(rt.pt.1yr.bm, rt.pt.2yr.bm)

# label output table
tab.pt.bm <- list(
  results = rt.pt.bm,
  sub.results = list(w1yr = rt.pt.1yr.bm, w2yr = rt.pt.2yr.bm),
  title = "Capital Allocation and the Scandal: Testing for Pre-Trends --- Benchmark $\\times$ Time FE",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Observations are at the fund-report date level, including only funds not directly involved in the scandal over the period $[2003m8-W, 2003m8]$, where $W$ corresponds to the number of years specified. $ScandalExposure$ (abbreviated $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. $ScandalExposure$ is normalized by its interquartile range. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\\times$ time, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# ScandalOutFlow ---------------------------------------------------------------

# regression models to estimate
m.sof <- FormFELM(y, paste(x.sof, x2, sep = " + "), fe, iv, cl)

# run regressions
r.sof.1yr <- lapply(m.sof, felm, scandal[sample.1yr == TRUE & date == rdate])
r.sof.2yr <- lapply(m.sof, felm, scandal[sample.2yr == TRUE & date == rdate])

# format regression output
rt.sof.1yr <- RegTable(r.sof.1yr,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = y)
rt.sof.2yr <- RegTable(r.sof.2yr,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = y)
rt.sof <- rbind(rt.sof.1yr, rt.sof.2yr)

# label regression output
tab.sof <- list(
  results = rt.sof,
  sub.results = list(w1yr = rt.sof.1yr, w2yr = rt.sof.2yr),
  title = "Capital Allocation and the Scandal: Using Abnormal Flows",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Observations are at the fund-report date level, including only funds not directly involved in the scandal over the period $\\{[2003m9-W, 2004m10+W] \\}$, where $W$ corresponds to the number of years specified. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. Standard errors are double clustered by fund and portfolio group $\\times$ time, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# ScandalOutFlow: Bm X Time ---------------------------------------------------

# regression models to estimate
m.sof.bm <- FormFELM(y, paste(x.sof, x2, sep = " + "), fe.bm, iv, cl.bm)

# run models
r.sof.1yr.bm <- lapply(m.sof.bm, felm, scandal[
  sample.1yr == TRUE & date == rdate])
r.sof.2yr.bm <- lapply(m.sof.bm, felm, scandal[
  sample.2yr == TRUE & date == rdate])

# format regression output
rt.sof.1yr.bm <- RegTable(r.sof.1yr.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = y)
rt.sof.2yr.bm <- RegTable(r.sof.2yr.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = y)
rt.sof.bm <- rbind(rt.sof.1yr.bm, rt.sof.2yr.bm)

# label regression output
tab.sof.bm <- list(
  results = rt.sof.bm,
  sub.results = list(w1yr = rt.sof.1yr.bm, w2yr = rt.sof.2yr.bm),
  title = "Capital Allocation and the Scandal: Using Abnormal Flows --- Benchmark $\\times$ Time FE",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Observations are at the fund-report date level, including only funds not directly involved in the scandal over the period $\\{[2003m9-W, 2004m10+W] \\}$, where $W$ corresponds to the number of years specified. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\\times$ time, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")



# Pre-Trend for ScandalOutFlow -------------------------------------------------

# regression models
m.pt.sof <- FormFELM(y, paste(x.pt.sof, x2, sep = " + "), fe, iv, cl)

# mean scandal outflow, 1 year window
scandal[
  sample.1yr == TRUE, scandal.outflow.m := mean(scandal.outflow), by = wficn][
  , scandal.outflow.m := scandal.outflow.m / IQR(scandal.outflow.m, na.rm=TRUE)]

# run regressions (1 year window)
r.pt.sof.1yr <- lapply(m.pt.sof, felm, scandal[
  sample.1yr == TRUE & date == rdate & date < "Sep 2003"])

# mean scandal. outflow, 2 year window
scandal[
  sample.2yr == TRUE, scandal.outflow.m := mean(scandal.outflow), by = wficn][
  , scandal.outflow.m := scandal.outflow.m / IQR(scandal.outflow.m, na.rm=TRUE)]

# run regressions (2 year window)
r.pt.sof.2yr <- lapply(m.pt.sof, felm, scandal[
  sample.2yr == TRUE & date == rdate & date < "Sep 2003"])

# format regression output
rt.pt.sof.1yr <- RegTable(r.pt.sof.1yr,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = y)
rt.pt.sof.2yr <- RegTable(r.pt.sof.2yr,
  fe.list = fe.list, coef.lab.dt = coef.lab.dt, col.names = y)
rt.pt.sof <- rbind(rt.pt.sof.1yr, rt.pt.sof.2yr)

# label output table
tab.pt.sof <- list(
  results = rt.pt.sof,
  sub.results = list(w1yr = rt.pt.sof.1yr, w2yr = rt.pt.sof.2yr),
  title = "Capital Allocation and $ScandalOutFlow$: Testing for Pre-Trends",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Observations are at the fund-report date level, including only funds not directly involved in the scandal over the period $[2003m8-W, 2003m8]$, where $W$ denotes the number of years specified. $\\overline{ScandalOutFlow}$ is the fund-level mean $ScandalOutFlow$ over the specified post-scandal window, normalized by interquartile range. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and portfolio group $\\times$ time, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Pre-Trend for ScandalOutFlow: Bm X Time --------------------------------------

# regression models
m.pt.sof.bm <- FormFELM(y, paste(x.pt.sof, x2, sep = " + "), fe.bm, iv, cl)

# mean scandal outflow, 1 year window
scandal[, scandal.outflow.m:= NULL]
scandal[
  sample.1yr == TRUE, scandal.outflow.m := mean(scandal.outflow), by = wficn][
  , scandal.outflow.m := scandal.outflow.m / IQR(scandal.outflow.m, na.rm=TRUE)]

# run regressions (1 year window)
r.pt.sof.1yr.bm <- lapply(m.pt.sof.bm, felm, scandal[
  sample.1yr == TRUE & date == rdate & date < "Sep 2003"])

# mean scandal. outflow, 2 year window
scandal[
  sample.2yr == TRUE, scandal.outflow.m := mean(scandal.outflow), by = wficn][
  , scandal.outflow.m := scandal.outflow.m / IQR(scandal.outflow.m, na.rm=TRUE)]

# run regressions (2 year window)
r.pt.sof.2yr.bm <- lapply(m.pt.sof.bm, felm, scandal[
  sample.2yr == TRUE & date == rdate & date < "Sep 2003"])

# format regression output
rt.pt.sof.1yr.bm <- RegTable(r.pt.sof.1yr.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = y)
rt.pt.sof.2yr.bm <- RegTable(r.pt.sof.2yr.bm,
  fe.list = fe.list.bm, coef.lab.dt = coef.lab.dt, col.names = y)
rt.pt.sof.bm <- rbind(rt.pt.sof.1yr.bm, rt.pt.sof.2yr.bm)

# label output table
tab.pt.sof.bm <- list(
  results = rt.pt.sof.bm,
  sub.results = list(w1yr = rt.pt.sof.1yr.bm, w2yr = rt.pt.sof.2yr.bm),
  title = "Capital Allocation and $ScandalOutFlow$: Testing for Pre-Trends --- Benchmark $\\times$ Time FE",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Observations are at the fund-report date level, including only funds not directly involved in the scandal over the period $[2003m8-W, 2003m8]$, where $W$ denotes the number of years specified. $\\overline{ScandalOutFlow}$ is the fund-level mean $ScandalOutFlow$ over the specified post-scandal window, normalized by interquartile range. Benchmarks are the  Standard errors are double clustered by fund and benchmark $\\times$ time, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# IV: ScandalOutflow -----------------------------------------------------------

# regression models to estimate
m.sof.iv <- FormFELM(y.2sls, x2.2sls, fe, iv.2sls, cl)

# run regressions
r.sof.1yr.iv <- lapply(m.sof.iv, felm, scandal[
  sample.1yr == TRUE & date == rdate])
r.sof.2yr.iv <- lapply(m.sof.iv, felm, scandal[
  sample.2yr == TRUE & date == rdate])

# format regression output
rt.sof.1yr.iv <- RegTable(r.sof.1yr.iv,
  fe.list = fe.list[, 1:(ncol(fe.list) - 1)], coef.lab.dt = coef.lab.dt)
rt.sof.2yr.iv <- RegTable(r.sof.2yr.iv,
  fe.list = fe.list[, 1:(ncol(fe.list) - 1)], coef.lab.dt = coef.lab.dt)
rt.sof.iv <- rbind(rt.sof.1yr.iv, rt.sof.2yr.iv)

# label regression output
tab.sof.iv <- list(
  results = rt.sof.iv,
  sub.results = list(w1yr = rt.sof.1yr.iv, w2yr = rt.sof.2yr.iv),
  title = "Capital Allocation and the Scandal: Instrumenting Competitor Size with Abnormal Flows",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Observations are at the fund-report date level, including only funds not directly involved in the scandal over the period $\\{[2003m9-W, 2004m10+W] \\}$, where $W$ corresponds to the number of years specified. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. Regressions are estimated via two stage least squares, instrumenting for $\\ln(CompetitorSize_{i,t})$ with $ScandalOutFlow_{i,t}$. The F-statistic of the first stage relation is reported at the bottom of each panel. Standard errors are double clustered by fund and portfolio group $\\times$ time, and are reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# IV: ScandalOutflow: Bm X Date FE ---------------------------------------------

# regression models to estimate
m.sof.iv.bm <- FormFELM(y.2sls, x2.2sls, fe.bm, iv.2sls, cl.bm)

# run regressions
r.sof.1yr.iv.bm <- lapply(m.sof.iv.bm, felm, scandal[
  sample.1yr == TRUE & date == rdate])
r.sof.2yr.iv.bm <- lapply(m.sof.iv.bm, felm, scandal[
  sample.2yr == TRUE & date == rdate])

# format regression output
rt.sof.1yr.iv.bm <- RegTable(r.sof.1yr.iv.bm,
  fe.list = fe.list[, 1:(ncol(fe.list) - 1)], coef.lab.dt = coef.lab.dt)
rt.sof.2yr.iv.bm <- RegTable(r.sof.2yr.iv.bm,
  fe.list = fe.list[, 1:(ncol(fe.list) - 1)], coef.lab.dt = coef.lab.dt)
rt.sof.iv.bm <- rbind(rt.sof.1yr.iv.bm, rt.sof.2yr.iv.bm)

# label regression output
tab.sof.iv.bm <- list(
  results = rt.sof.iv.bm,
  sub.results = list(w1yr = rt.sof.1yr.iv.bm, w2yr = rt.sof.2yr.iv.bm),
  title = "Capital Allocation and the Scandal: Instrumenting Competitor Size with Abnormal Flows --- Benchmark $\\times$ Time FE",
  caption = "Dependent variables are identified in the column headers. $\\ln(C.S.)$ is an abbreviation for $\\ln(CompetitorSize)$. Observations are at the fund-report date level, including only funds not directly involved in the scandal over the period $\\{[2003m9-W, 2004m10+W] \\}$, where $W$ corresponds to the number of years specified. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. I estimate regressions via two stage least squares, instrumenting for $\\ln(CompetitorSize_{i,t})$ with $ScandalOutFlow_{i,t}$. The F-statistic of the first stage relation is reported at the bottom of each panel. Standard errors are double clustered by fund and benchmark $\\times$ time, and are reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Performance ------------------------------------------------------------------

# specifications to estimate
y.p <- "ra.gross.ff3"
x.p <- c(rep(x.did, 2), rep(x.sof, 2), rep("", 2))
x2.p <- "ln.fund.size"
fe.p <- rep(c(fe, fe.bm), 3)
iv.p <- c(rep(iv, 4), rep(iv.2sls, 2))
cl.p <- rep(c(cl, cl.bm), 3)
m.perf <- FormFELM(y.p, paste(x.p, x2.p, sep = "+"), fe.p, iv.p, cl.p)

# data over which to estimate specifications
dt.perf.1yr <- c(
  rep("scandal[did.1yr == TRUE]", 2),
  rep("scandal[sample.1yr == TRUE]", 4))
dt.perf.2yr <- c(
  rep("scandal[did.2yr == TRUE]", 2),
  rep("scandal[sample.2yr == TRUE]", 4))

# run regressions
mapfn <- function(a, b) felm(a, eval(parse(text = b)))
r.perf.1yr <- Map(mapfn, m.perf, dt.perf.1yr)
r.perf.2yr <- Map(mapfn, m.perf, dt.perf.2yr)

# label reg tables
fe.list.p <- rbind(
  c("Fixed Effects", rep("", 6)),
  c("$\\bullet$ Fund", rep("Yes", 6)),
  c("$\\bullet$ Month", rep(c("Yes", "No"), 3)),
  c("$\\bullet$ Benchmark $\\times$ Month", rep(c("No", "Yes"), 3)))

rt.perf.1yr <- RegTable(r.perf.1yr,
  fe.list = fe.list.p, coef.lab.dt = coef.lab.dt)
rt.perf.2yr <- RegTable(r.perf.2yr,
  fe.list = fe.list.p, coef.lab.dt = coef.lab.dt)

# label results
rt.perf <- rbind(rt.perf.1yr, rt.perf.2yr)
setnames(rt.perf, "V1", "")
tab.perf <- list(
  results = rt.perf,
  sub.results = list(w1yr = rt.perf.1yr, w2yr = rt.perf.2yr),
  title = "Fund Performance and the Scandal",
  caption = "The dependent variable is Fama-French 3 factor adjusted gross returns, in annual percent units. Observations are at the fund-month level. The estimation sample includes only funds not tainted by the scandal. In columns (1)-(4) regressions are estimated by ordinary least squares. In columns (5)-(6), regressions are estimated by two stage least squares, instrumenting $\\ln(CompetitorSize)$ with $ScandalOutFlow$. In columns (1)-(2), the sample includes $\\{(2003m8-W, 2003m8], [2004m11,2004m11+W) \\}$, where $W$ corresponds to the number of years specified. In columns (3)-(6), the sample is taken over the period $\\{[2003m9-W, 2004m10+W] \\}$. $ScandalExposure$ (abbreviated to $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. I normalize $ScandalExposure$ by its interquartile range. $\\mathbb{I}$ is an indicator for the post scandal period. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and portfolio group $\\times$ month in odd columns, and by fund and benchmark $\\times$ month in even columns (5)-(6). Standard errors are reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")


# Performance, Alternative Spec ------------------------------------------------

scandal[, CS.std := CS / sd(CS)]
scandal[, fund.size.std := fund.size /
          (quantile(fund.size, .5) - quantile(fund.size, .1))]

# specifications to estimate
x2.p.a <- "fund.size.std"
iv.p.a <- c(rep(iv, 4), rep(iv.2sls.a, 2))
m.perf.a <- FormFELM(y.p, paste(x.p, x2.p.a, sep = "+"), fe.p, iv.p.a, cl.p)

# run regressions
r.perf.a.1yr <- Map(mapfn, m.perf.a, dt.perf.1yr)
r.perf.a.2yr <- Map(mapfn, m.perf.a, dt.perf.2yr)

rt.perf.a.1yr <- RegTable(r.perf.a.1yr,
  fe.list = fe.list.p, coef.lab.dt = coef.lab.dt)
rt.perf.a.2yr <- RegTable(r.perf.a.2yr,
  fe.list = fe.list.p, coef.lab.dt = coef.lab.dt)

# label results
rt.perf.a <- rbind(rt.perf.a.1yr, rt.perf.a.2yr)
setnames(rt.perf.a, "V1", "")
tab.perf.a <- list(
  results = rt.perf.a,
  sub.results = list(w1yr = rt.perf.a.1yr, w2yr = rt.perf.a.2yr),
  title = "Fund Performance and the Scandal",
  caption = "The dependent variable is Fama-French 3 factor adjusted gross returns, in annual percent units. Observations are at the fund-month level. The estimation sample includes only funds not tainted by the scandal. In columns (1)-(4) regressions are estimated by ordinary least squares. In columns (5)-(6), regressions are estimated by two stage least squares, instrumenting $\\ln(CompetitorSize)$ with $ScandalOutFlow$. In columns (1)-(2), the sample includes $\\{(2003m8-W, 2003m8], [2004m11,2004m11+W) \\}$, where $W$ corresponds to the number of years specified. In columns (3)-(6), the sample is taken over the period $\\{[2003m9-W, 2004m10+W] \\}$. $ScandalExposure$ (abbreviated to $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. I normalize $ScandalExposure$ by its interquartile range. $\\mathbb{I}$ is an indicator for the post scandal period. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and portfolio group $\\times$ month in odd columns, and by fund and benchmark $\\times$ month in even columns (5)-(6). Standard errors are reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.")



# Combine and Save -------------------------------------------------------------

tab.reg.scandal <- list(
  did       = tab.did,
  did.bm    = tab.did.bm,
  pt        = tab.pt,
  pt.bm     = tab.pt.bm,
  sof       = tab.sof,
  sof.bm    = tab.sof.bm,
  pt.sof    = tab.pt.sof,
  pt.sof.bm = tab.pt.sof.bm,
  iv        = tab.sof.iv,
  iv.bm     = tab.sof.iv.bm,
  perf      = tab.perf,
  perf.a    = tab.perf.a
)
saveRDS(tab.reg.scandal, "tab/reg_scandal.Rds")

