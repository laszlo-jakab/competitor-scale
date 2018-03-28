# Laszlo Jakab
# Mar 2018

# Setup ---------------------------------------------------

# packages
library(ggplot2)
library(magrittr)

# load functions
source("R/functions/Plot_Fn.R")

# datasets
combined        <- readRDS("data/combined/combined.Rds")
shrcls.crsp     <- readRDS("data/clean/share_class_crsp_data.Rds")
mfl.crsp        <- readRDS("data/clean/mfl_crsp_nodup.Rds")
funds.in.sample <- readRDS("data/funds_included/funds_in_sample.Rds")
wficn.rdate     <- readRDS("data/clean/wficn_rdate.Rds")

# set ggplot theme
th <- theme_bw()


# CompetitorSize Distribution --------------------------------------------------

# unconditional distribution
p.hist.uncond <- HistFn(combined[, .(comp.size)], "comp.size", 50,
  "Unconditional distribution", "CompetitorSize")

# within-fund distribution
combined[, csw := comp.size - mean(comp.size, na.rm = TRUE), by = wficn]
p.hist.within <- HistFn(combined[, .(csw)], "csw", 50,
  "Within-fund distribution", "CompetitorSize")

# annotate plots
hist.plots <- list(
  results = list(unconditional = p.hist.uncond, within.fund = p.hist.within),
  title = "Histograms of $CompetitorSize$.",
  caption = "The left panel illustrates the variable's unconditional distribution. The right panel shows the distribution after demeaning fund-by-fund.")


# Data Availability in CRSP ----------------------------------------------------

# restrict CRSP dataset to sample and time period
shrcls.crsp <- shrcls.crsp[
  # add in wficn
  mfl.crsp, on = "crsp_fundno", nomatch = 0][
  # keep only funds that make the cut
  funds.in.sample, on = "wficn", nomatch = 0][
  # keep only Mar 1980-Dec 2016
  "Mar 1980" <= as.yearmon(caldt) & as.yearmon(caldt) <= "Dec 2016"]

# plot and annotate
crsp.plots <- list(
  results = list(
    mret = CRSPPlot(shrcls.crsp[!is.na(mret), .N, keyby = caldt],
      "Panel A: Share classes with mret"),
    mtna = CRSPPlot(shrcls.crsp[!is.na(mtna), .N, keyby = caldt],
      "Panel B: Share classes with mtna"),
    exp_ratio = CRSPPlot(shrcls.crsp[!is.na(exp_ratio), .N, keyby = caldt],
      "Panel C: Share classes with exp_ratio")
    ),
  title = "Data availability in the CRSP Mutual Fund dataset.",
  caption = "Number of actively managed domestic equity fund share classes with non-missing \\texttt{mret}, \\texttt{mtna}, and \\texttt{exp\\_ratio} in the CRSP Mutual Fund Dataset by date.")


# Report Dates in Thomson ---------------------------------------------------

rdate.freq <- wficn.rdate[
  # keep only funds meeting filter criteria
  funds.in.sample, on = "wficn", nomatch = 0][
  # count frequencies by month
  "Mar 1980" <= rdate.mon & rdate.mon <= "Dec 2016", .N, by = rdate.mon][
  # flag mid-qtr observations
  , mid.qtr := !month(rdate.mon) %in% c(3, 6, 9, 12)][
  , date := as.Date(rdate.mon)]

# produce plot
p.rdate <-
  rdate.freq %>%
    ggplot(aes(date, N)) +
    ylab("Number of funds reporting") +
    xlab("Report date") +
    th +
    geom_bar(stat = "identity", aes(fill = mid.qtr)) +
    theme(
      legend.position = c(.01, .99),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.justification=c(0, 1)
      ) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 1500)) +
    scale_fill_manual("", values = c(orangebrown, azure),
                      labels = c("End of quarter", "Mid quarter"))

# annotate plot
rdate.plot <- list(
  results = p.rdate,
  title = "Fund report dates in Thomson.",
  caption = "Time series plot of the number of funds reporting portfolio holdings during a given month. End-of-quarter months (March, June, September, December) are differentiated from mid-quarter months by a distinct color.")


# Industry Size Time Series ----------------------------------------------------

isize <- combined[, .(CompetitorSize = mean(comp.size, na.rm = TRUE),
  IndustrySize = mean(industry.size)), keyby = date]
isize[, CompetitorSize := CompetitorSize * 40]
p.isize <- melt(isize, id.vars = "date") %>%
  ggplot() +
    aes(as.Date(date), value, group = variable) +
    geom_line(aes(colour = variable, linetype = variable)) +
    xlab("Date") +
    ylab("Size relative to market") +
    scale_colour_manual("", values = c(azure, orangebrown)) +
    scale_linetype_manual("", values = c("solid", "longdash")) +
    th +
    theme(legend.position = "bottom")

# annotate plot
isize.plot <- list(
  results = p.isize,
  title = "Time series of $CompetitorSize$.",
  caption = "Cross-sectional mean of $CompetitorSize$ (scaled by 40 for exposition) against the time series of $IndustrySize$.")


# Save -------------------------------------------------------------------------

summary.plots <- list(
  histograms = hist.plots,
  crsp = crsp.plots,
  rdates = rdate.plot,
  industry = isize.plot)
saveRDS(summary.plots, "fig/summary_plots.Rds")
