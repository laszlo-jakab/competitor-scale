# Laszlo Jakab
# Mar 2018

# Setup ------------------------------------------------------------------------

# packages
library(lfe)
library(laszlor)

# helper function
mapfn <- function(a, b) felm(a, eval(parse(text = b)))

# load data
funds.in.sample <- readRDS("data/funds_included/funds_in_sample.Rds")
flc      <- readRDS("data/clean/fund_level_crsp.Rds")[
  , .(wficn, date, r.net, tna, tna.l1)]
tmc      <- readRDS("data/clean/total_mktcap.Rds")[, .(date, totcap)]
ra       <- readRDS("data/benchmarked_returns/risk_adj_ret.Rds")
combined <- readRDS("data/combined/combined.Rds")
scandal  <- readRDS("data/scandal/scandal_dt.Rds")


# Data Prep ---------------------------------------------------

flc <- flc[
  # keep only fudns that pass sample filters
  funds.in.sample, on = "wficn", nomatch = 0][
  # keep only March 1980 to December 2016
  "Mar 1980" <= date & date <= "Dec 2016"][
  # add in total market cap
  tmc, on = "date", nomatch = 0][
  # generate FundSize
  , fund.size := tna * 10^6 / totcap][
  , totcap := NULL]
# lag fundsize by two months for later
flc <- LagDT(flc, "fund.size", shift.by = 2, panel.id = "wficn")[
  , ln.fund.size.l2 := log(fund.size.l2)]

# get a year's worth of lagged net returns (CAPM and FF3-adjusted)
ra.dt <- ra[
  , .(wficn, date, ra.net.capm = 100*ra.net.capm, ra.net.ff3 = 100*ra.net.ff3)]
setnames(ra.dt, c("wficn", "date", "rcapm", "rff3"))
setkey(ra.dt, wficn, date)
ra.dt <- LagDT(ra.dt, c("rcapm", "rff3"), shift.by = 1:12, panel.id = "wficn")

# add in lagged fund size and risk adjusted returns
combined <- merge(combined,
  flc[, .(wficn, date, fund.size.l2, ln.fund.size.l2)],
  by = c("wficn", "date"), all.x = TRUE)
combined <- merge(combined, ra.dt, by = c("wficn", "date"), all.x = TRUE)

# clear up workspace
rm(funds.in.sample, flc, tmc, ra)

# flows in percent
combined[, flow := flow * 100]
scandal[, flow := flow * 100]


# Regression Table Labels ------------------------------------------------------

coef.lab.dt <- data.table(
  old.name = c(
    "post.newsTRUE",
    "post.scandal:scandal.fund",
    "postXscan",
    "scandal.outflow",
    "cs.std",
    "ln.fund.size.l2",
    paste0("rcapm.l", 1:12),
    paste0("rff3.l", 1:12)),
  new.name = c(
    "PostNews",
    "$\\mathbb{I} \\times$ Scandal",
    "$\\mathbb{I} \\times ScanEx$",
    "$ScandalOutFlow$",
    "$CompetitorSize",
    "$\\ln(FundSize_{t-2})$",
    paste0("$R^{CAPM}_{t-", 1:12, "}$"),
    paste0("$R^{FF3}_{t-", 1:12, "}$")))


# Flows and Past Returns -------------------------------------------------------

# models to run
y <- "flow"
x.capm <- paste0("rcapm.l", 1:12, collapse = " + ")
x.ff3  <- paste0("rff3.l", 1:12, collapse = " + ")
fe <- c("0", "date", "benchmark.X.date", "wficn",
  "wficn + date", "wficn + benchmark.X.date")
iv <- "0"
cl <- "wficn + date"
m.capm <- FormFELM(y, x.capm, fe, iv, cl)
m.ff3 <- FormFELM(y, x.ff3, fe, iv, cl)

# run regressions
r.capm <- lapply(m.capm, felm, combined[date >= "Jan 1991"])
r.ff3 <- lapply(m.ff3, felm, combined[date >= "Jan 1991"])

# format tables
fe.list <- rbind(
  c("Fixed Effects", rep("", 6)),
  c("$\\bullet$ Fund", rep("No", 3), rep("Yes", 3)),
  c("$\\bullet$ Month", c("No", "Yes", rep("No", 2), "Yes", "No")),
  c("$\\bullet$ Benchmark $\\times$ Month", rep("No", 2), "Yes", rep("No", 2), "Yes"))
rt.capm <- RegTable(r.capm, fe.list = fe.list, coef.lab.dt = coef.lab.dt)
rt.ff3  <- RegTable(r.ff3,  fe.list = fe.list, coef.lab.dt = coef.lab.dt)


# Flows and Competitor Scale ---------------------------------------------------

# standardize competitor size, fund size
combined[
  , cs.std := comp.size / sd(comp.size, na.rm = TRUE)][
  , fs.l2.std := fund.size.l2 / (quantile(fund.size.l2, .25, na.rm = TRUE) -
                                 quantile(fund.size.l2, .25, na.rm = TRUE))]

# model specification
x.cs <- "cs.std"
x.cs.capm <- paste("cs.std", paste0("rcapm.l", 1:12, collapse = "+"), sep = "+")
x.cs.ff3 <- paste("cs.std", paste0("rff3.l", 1:12, collapse = "+"), sep = "+")

m.cs <- FormFELM(y, x.cs, fe, iv, cl)
m.cs.capm <- FormFELM(y, x.cs.capm, fe, iv, cl)
m.cs.ff3 <- FormFELM(y, x.cs.ff3, fe, iv, cl)

# run regressions
r.cs <- lapply(m.cs, felm, combined[date >= "Jan 1991"])
r.cs.capm <- lapply(m.cs.capm, felm, combined[date >= "Jan 1991"])
r.cs.ff3 <- lapply(m.cs.ff3, felm, combined[date >= "Jan 1991"])

# format tables
rt.cs <- RegTable(r.cs, fe.list = fe.list, coef.lab.dt = coef.lab.dt)
rt.cs.capm <- RegTable(r.cs.capm, fe.list = fe.list, coef.lab.dt = coef.lab.dt)
rt.cs.ff3 <- RegTable(r.cs.ff3, fe.list = fe.list, coef.lab.dt = coef.lab.dt)


# Scandal: Flows from Tainted Funds --------------------------------------------

# add in past returns
scandal <- merge(scandal, ra.dt, by = c("wficn", "date"), all.x = TRUE)
scandal[, post.news := date >= as.yearmon(news.date)][
  is.na(post.news), post.news := FALSE]

# specifications
dt.t <- c(rep("scandal['Sep 2002' <= date & date < 'Nov 2005']", each = 2),
          rep("scandal", each = 2))
x.t <- rep(c(
  "post.news",
  paste("post.news",
         paste0("rff3.l", 1:12, collapse = " + "), sep = " + ")), 2)
fe.t <- "wficn + date"
cl.t <- "wficn + date.port.grp"
m.t <- FormFELM(y, x.t, fe.t, iv, cl.t)

# run regressions
r.t <- Map(mapfn, m.t, dt.t)

# format tables
fe.list.t <- rbind(
  c("$W =$", rep(c("1yr", "2yr"), each = 2)),
  c("Fixed Effects", rep("", 4)),
  c("$\\bullet$ Fund", rep("Yes", 4)),
  c("$\\bullet$ Month", rep("Yes", 4)))
rt.t <- RegTable(r.t,
  fe.list = fe.list.t, coef.lab.dt = coef.lab.dt, print.tstat = TRUE)


# Scandal: Flows Among Untainted Funds -----------------------------------------

# data on which to estimate
dt.s <- c(
  rep("scandal[did.1yr == TRUE]", each = 2),
  rep("scandal[sample.1yr == TRUE]", each = 2),
  rep("scandal[did.2yr == TRUE]", each = 2),
  rep("scandal[sample.2yr == TRUE]", each = 2))

# specifications
x.s <- rep(c(rep("postXscan", 2), rep("scandal.outflow", 2)), 2)
fe.s <- rep(c("wficn + date", "wficn + benchmark.X.date"), 4)
cl.s <- rep(c("wficn + date.port.grp", "wficn + benchmark.X.date"), 2)
m.s <- FormFELM(y, x.s, fe.s, iv, cl.s)

# run regressions
r.s <- Map(mapfn, m.s, dt.s)

# format tables
fe.list.scan <- rbind(
  c("Fixed Effects", rep("", 8)),
  c("$\\bullet$ Fund", rep("Yes", 8)),
  c("$\\bullet$ Month", rep(c("Yes", "No"), 4)),
  c("$\\bullet$ Benchmark $\\times$ Month", rep(c("No", "Yes"), 4)))
rt.s <- RegTable(r.s, fe.list = fe.list.scan, coef.lab.dt = coef.lab.dt)

# --- Controlling for past returns ---
# specifications
x.sr <- rep(c(
  rep(paste("postXscan",
            paste0("rff3.l", 1:12, collapse = " + "), sep = " + "), 2),
  rep(paste("scandal.outflow",
            paste0("rff3.l", 1:12, collapse = " + "),sep = " + "), 2)), 2)
m.sr <- FormFELM(y, x.sr, fe.s, iv, cl.s)

# run regressions
r.sr <- Map(mapfn, m.sr, dt.s)

# format tables
rt.sr <- RegTable(r.sr, fe.list = fe.list.scan, coef.lab.dt = coef.lab.dt)
rt.scandal <- rbind(rt.s, rt.sr)
setnames(rt.scandal, "V1", "")


# Collect Results and Save -----------------------------------------------------

tab.flow <- list(
  capm = list(
    results = rt.capm,
    title = "Fund Flows and Past Performance --- CAPM",
    caption = "The dependent variable is net flows, $flow_{i,t} = \\frac{TNA_{i,t} - TNA_{i,t-1}(1 + r_{i,t})}{TNA_{i,t-1}}$. The sample runs from Jan 1991 to Dec 2016"),
  ff3 = list(
    results = rt.ff3,
    title = "Fund Flows and Past Performance --- FF3",
    caption = "The dependent variable is net flows, $flow_{i,t} = \\frac{TNA_{i,t} - TNA_{i,t-1}(1 + r_{i,t})}{TNA_{i,t-1}}$. The sample runs from Jan 1991 to Dec 2016"),
  cs = list(
    results = rt.cs,
    title = "CompetitorSize and Fund Flows",
    caption = "The dependent variable is net flows, $flow_{i,t} = \\frac{TNA_{i,t} - TNA_{i,t-1}(1 + r_{i,t})}{TNA_{i,t-1}}$. The sample runs from Jan 1991 to Dec 2016"),
  cs.capm = list(
    results = rt.cs.capm,
    title = "CompetitorSize and Fund Flows --- Controlling for Past $R^{CAPM}$",
    caption = "The dependent variable is net flows, $flow_{i,t} = \\frac{TNA_{i,t} - TNA_{i,t-1}(1 + r_{i,t})}{TNA_{i,t-1}}$. The sample runs from Jan 1991 to Dec 2016"),
  cs.ff3 = list(
    results = rt.cs.ff3,
    title = "CompetitorSize and Fund Flows --- Controlling for Past $R^{FF3}$",
    caption = "The dependent variable is net flows, $flow_{i,t} = \\frac{TNA_{i,t} - TNA_{i,t-1}(1 + r_{i,t})}{TNA_{i,t-1}}$. The sample runs from Jan 1991 to Dec 2016"),
  scandal.treat = list(
    results = rt.t,
    title = "Impact of Scandal Involvement on Fund Flows",
    caption = "The dependent variable is net flows, $flow_{i,t} = \\frac{TNA_{i,t} - TNA_{i,t-1}(1 + r_{i,t})}{TNA_{i,t-1}}$."
  ),
  scandal.cs = list(
    results = rt.scandal,
	sub.results = list(raw = rt.s, ret.controls = rt.sr),
    title = "Investor Flows and the Scandal",
    caption = "The dependent variable is net flows in monthly percent units. Observations are at the fund-month level, including only funds untainted by the scandal, over the period $\\{[2003m9-W, 2004m10+W] \\}$. $\\mathbb{I}$ is an indicator for the post scandal period. $ScandalExposure$ ($ScanEx$) and $ScandalOutFlow$ are normalized by interquartile range. Benchmarks are the indexes which yield the lowest active share, taken from \\citet{petajisto13}. Standard errors are double clustered by fund and portfolio group $\\times$ month in the month FE specifications, and by fund and benchmark $\\times$ month in the benchmark $\\times$ month specifications, reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1."
  )
)

saveRDS(tab.flow, "tab/reg_flow.Rds")
