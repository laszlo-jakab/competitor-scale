# Laszlo Jakab
# Mar 2018

# Setup ------------------------------------------------------------------------

# load packages
library(ggplot2)
library(magrittr)

# load data
scandal.dt         <- readRDS("data/scandal/scandal_dt.Rds")
size.loss.dt       <- readRDS("data/scandal/expected_size_loss.Rds")
scandal.outflow.dt <- readRDS("data/scandal/scandal_outflow.Rds")

# load plotting function
source("R/functions/Plot_Fn.R")


# Data: Flows ------------------------------------------------------------------

# time series dataset of mean flows by scandal status
scandal.flows <- scandal.dt[
  # mean flows by scandal status
  , .(flow = mean(flow, na.rm = TRUE)), by = .(scandal.fund, date)][
  # conventional date format for plotting
  , Date := as.Date(date)][
  # relabel scandal status for plotting
  , scandal.fund := ifelse(scandal.fund == 1,
    "Involved in scandal", "Not involved in scandal")]

# collect unique scandal dates
news.dates <- scandal.dt[, unique(as.yearmon(news.date))]
news.dates <- sort(news.dates[!is.na(news.dates)])
# time series dataset of fraction of industry becoming tainted
scandal.size.date <- scandal.dt[
  # indicator variable for fund becoming tainted in current month
  , scandal.date :=
    ifelse(!is.na(news.date) & date == as.yearmon(news.date), 1, 0)][
  # size of fund becoming tainted that month, setting other size to zero
  , scandal.fund.size := fund.size * scandal.date][
  # keep only if at least one fund becomes tainted during the month
  date %in% news.dates][
  # fraction of industry size becoming tainted during the month
  , .(scandal.size.date =
    sum(scandal.fund.size, na.rm = TRUE) / sum(fund.size, na.rm = TRUE)), by = date][
  , Date := as.Date(date)]


# Data: ScandalOutFlow ---------------------------------------------------------

# abnormal flow estimates
mean.betas <- size.loss.dt[
  # mean treatment effect of scandal on flows for affected funds, by post-scandal date
  , .(mean.beta = mean(estimate)), keyby = date][
  # standard date variable for convenience
  , Date := as.Date(date)]

# ScandalOutFlow percentiles
sof.scale <- 10^4
sof.pctiles <- scandal.outflow.dt[
  # 25th, 50th, 75th percentiles of predicted outflows due to scandal
  , as.list(quantile(scandal.outflow * sof.scale, c(.25, .50, .75))), keyby = date][
  # standard date variable for convenience
  , Date := as.Date(date)]
setnames(sof.pctiles, c("date", "p25", "p50", "p75", "Date"))
# reshape to long (ggplot prefers long form)
sof.pctiles <- melt(sof.pctiles, id.vars = "Date",
  measure.vars = c("p25", "p50", "p75"))
# reorder percentiles for legend
sof.pctiles[, variable := factor(variable, levels = c("p75", "p50", "p25"))]


# Data: DiD --------------------------------------------------------------------

# dataset of untainted funds
untainted.dt <- scandal.dt[scandal.fund == 0]

# split by median 2003 Aug scandal exposure
scandal.exposure.median <- untainted.dt[
  date == "Aug 2003", median(scandal.exposure)]
untainted.dt[, high.exposure := ifelse(
  scandal.exposure > scandal.exposure.median, "High exposure", "Low exposure")]

# split by median of average scandal outflow
untainted.dt[, scandal.outflow.mean := mean(scandal.outflow), by = wficn]
untainted.dt[, high.outflow := ifelse(
  scandal.outflow.mean > median(scandal.outflow.mean), "High outflow", "Low outflow")]

# demean logged variables by fund
var.list <- c("ln.CS", "ln.AS", "ln.TL", "ln.T", "ln.L")
untainted.dt[, (paste0("f", var.list)) :=
  lapply(.SD, function(x) x - mean(x, na.rm = TRUE)),
  by = wficn, .SDcols = var.list]

# mean outcomes by exposure group
high.low.dt <- untainted.dt[, lapply(.SD, mean, na.rm = TRUE),
  by = .(high.exposure, date),
  .SDcols = c(paste0("f", var.list), "ra.gross.ff3")]
high.low.dt[, caldt := as.Date(date)]
setkey(high.low.dt, high.exposure, date)

# difference between mean 3-factor adjusted returns of high and low exposure groups
high.low.dret <- dcast(
  high.low.dt, caldt ~ high.exposure, value.var = "ra.gross.ff3")[
  , dra.gross.ff3 := `High exposure` - `Low exposure`]

# mean outcomes by outflow group
high.low.sof.dt <- untainted.dt[, lapply(.SD, mean, na.rm = TRUE),
  by = .(high.outflow, date),
  .SDcols = c(paste0("f", var.list), "ra.gross.ff3")]
high.low.sof.dt[, caldt := as.Date(date)]
setkey(high.low.sof.dt, high.outflow, date)

# difference between mean 3-factor adjusted returns of high and low outflow groups
high.low.sof.dret <- dcast(
  high.low.sof.dt, caldt ~ high.outflow, value.var = "ra.gross.ff3")[
  , dra.gross.ff3 := `High outflow` - `Low outflow`]


# Plot: Flows ------------------------------------------------------------------

# flows by scandal status
p.scandal.flows <- scandal.flows %>%
  ggplot() +
  aes(Date, flow, group = scandal.fund) +
  ylab("Monthly flows in %") +
  geom_vline(xintercept = as.Date("2003-08-15"),
    colour = "red", linetype = 2) +
  geom_line(aes(linetype = scandal.fund, colour = scandal.fund)) +
  scale_linetype_manual("", values = c("solid", "longdash")) +
  scale_colour_manual("", values = c(azure, orangebrown)) +
  theme_bw() +
  theme(
    legend.position = "bottom",
    legend.key.width = unit(1, "strwidth", "Involved"))

# fraction of industry involved in the scandal by news date
break.vec <- as.Date(c("2003-09-01", "2003-12-01", "2004-03-01", "2004-08-01", "2004-10-01"))
p.scandal.size <- scandal.size.date %>%
  ggplot() +
  aes(Date, scandal.size.date) +
  xlab("News date of investigation") +
  ylab("Involved fund size") +
  scale_x_date(date_labels= "%b %y", breaks = break.vec) +
  coord_cartesian(ylim = c(0, .15)) +
  geom_col(col = azure, fill = azure, alpha = .3) +
  theme_bw() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))

# label plots
scandal.flow.plots <- list(
  results = list(flows = p.scandal.flows, size = p.scandal.size),
  title = "Flows and size by scandal involvement.",
  caption = "The left panel plots mean monthly net flows. The vertical line corresponds to August 2003, the month before the announcement of the first investigations. The right panel shows the total net assets of funds coming under investigation in a given month, relative to the total size of funds in my sample.")


# Plot: DiD --------------------------------------------------------------------

theme.type <- "bw"

# log(CompetitorSize)
p.ln.CS <- DidPlot(high.low.dt, "fln.CS", "high.exposure",
  expression(ln(C.S)), expression(ln(CompetitorSize)),
  theme.type = theme.type)

# log(Active Share)
p.ln.AS <- DidPlot(high.low.dt[month(date) %in% c(3, 6, 9, 12)], "fln.AS",
  "high.exposure",
  expression(ln(AS)), expression(ln(AS)),
  theme.type = theme.type)

# 3-factor adjusted returns
p.ff3 <- DidBarPlot(high.low.dret, "dra.gross.ff3",
  expression(R[high]^{FF3} - R[low]^{FF3}), expression(paste(R^{FF3})),
  theme.type = theme.type)

# log(TL)
p.ln.TL <- DidPlot(high.low.dt, "fln.TL", "high.exposure",
  expression(ln(T/sqrt(L))), expression(ln(TL^-frac(1,2))),
  theme.type = theme.type)

# log(T)
p.ln.T <- DidPlot(high.low.dt, "fln.T", "high.exposure",
  expression(ln(T)), expression(ln(T)),
  theme.type = theme.type)

# log(L)
p.ln.L <- DidPlot(high.low.dt, "fln.L", "high.exposure",
  expression(ln(L)), expression(ln(L)),
  theme.type = theme.type)

# label plots
did.plots <- list(
  results = list(ln.CS = p.ln.CS, ln.AS = p.ln.AS, ff3 = p.ff3,
                 ln.TL =  p.ln.TL, ln.T = p.ln.T, ln.L = p.ln.L),
  title = "Untainted fund outcomes by exposure to competition from scandal funds.",
  caption = "Funds are sorted into high and low exposure groups depending on whether their $ScandalExposure$ is above or below the cross-sectional median. The $\\ln(CompetitorSize)$, $\\ln(AS)$, and $\\ln(TL^{-1/2})$ panels plot cross-sectional means of the variables' deviations from their respective within fund means across groups. The $R^{FF3}$ panel plots the difference between the cross-sectional means of the within fund deviations of three factor adjusted gross returns across groups. The shaded area corresponds to the scandal period Sep 2003-Oct 2004.")


# Plot: DiD for ScandalOutFlow -------------------------------------------------

# log(CompetitorSize)
p.sof.ln.CS <- DidPlot(high.low.sof.dt, "fln.CS", "high.outflow",
                       expression(ln(C.S)), expression(ln(CompetitorSize)),
                       theme.type = theme.type)

# log(Active Share)
p.sof.ln.AS <- DidPlot(high.low.sof.dt[month(date) %in% c(3, 6, 9, 12)],
                       "fln.AS", "high.outflow",
                       expression(ln(AS)), expression(ln(AS)),
                       theme.type = theme.type)

# 3-factor adjusted returns
p.sof.ff3 <- DidBarPlot(high.low.sof.dret, "dra.gross.ff3",
                        expression(R[high]^{FF3} - R[low]^{FF3}), expression(paste(R^{FF3})),
                        theme.type = theme.type)

# log(TL)
p.sof.ln.TL <- DidPlot(high.low.sof.dt, "fln.TL",
                       "high.outflow",
                       expression(ln(T/sqrt(L))), expression(ln(TL^-frac(1,2))),
                       theme.type = theme.type)

# log(T)
p.sof.ln.T <- DidPlot(high.low.sof.dt, "fln.T", "high.outflow",
                      expression(ln(T)), expression(ln(T)),
                      theme.type = theme.type)

# log(L)
p.sof.ln.L <- DidPlot(high.low.sof.dt, "fln.L", "high.outflow",
                      expression(ln(L)), expression(ln(L)),
                      theme.type = theme.type)

# label plots
did.sof.plots <- list(
  results = list(ln.CS = p.sof.ln.CS, ln.AS = p.sof.ln.AS, ff3 = p.sof.ff3,
                 ln.TL =  p.sof.ln.TL, ln.T = p.sof.ln.T, ln.L = p.sof.ln.L),
  title = "Untainted fund outcomes by mean $ScandalOutFlow$.",
  caption = "Funds are sorted into high and low groups depending on whether their mean $ScandalOutflow$ is above or below the cross-sectional median. The $\\ln(CompetitorSize)$, $\\ln(AS)$, and $\\ln(TL^{-1/2})$ panels plot cross-sectional means of the variables' deviations from their respective within fund means across groups. The $R^{FF3}$ panel plots the difference between the cross-sectional means of the within fund deviations of three factor adjusted gross returns across the two groups. The shaded area corresponds to the scandal period Sep 2003-Oct 2004.")


# Plot: ScandalOutFlow ---------------------------------------------------------

# mean treatment effect by date
p.betas <- mean.betas %>%
  ggplot() +
  aes(Date, mean.beta) +
  ylab(expression(beta[j^{(d)}][t])) +
  geom_line(col = azure) +
  theme_bw()

# ScandalOutFlow percentiles by date
p.sof <- sof.pctiles %>%
  ggplot +
  aes(Date, value, group = variable) +
  ylab(bquote("ScandalOutFlow " %*%.(sof.scale))) +
  geom_line(aes(linetype = variable, colour = variable)) +
  scale_linetype_manual("", values = 1:3) +
  scale_colour_manual("", values = c(azure, orangebrown, lgreen)) +
  theme_bw() +
  theme(
    legend.position = c(.01, .99),
    legend.justification = c(0, 1),
    legend.key.width = unit(1.3, "strwidth", "p25")
  )

# label plots
sof.plots <- list(
  results = list(betas = p.betas, pctiles = p.sof),
  title = "Estimated abnormal outflows from scandal funds.",
  caption = "The left panel shows the cross-sectional mean coefficient on post-scandal cohort $\\times$ time fixed effects from Equation \\@ref(eq:cohortReg). The right panel shows the time series of cross-sectional percentiles of $ScandalOutFlow$ across untainted funds.")


# Combine and Save -------------------------------------------------------------

scandal.plots <- list(
  flows   = scandal.flow.plots,
  did     = did.plots,
  sof.did = did.sof.plots,
  sof     = sof.plots)
saveRDS(scandal.plots, "fig/scandal_plots.Rds")
