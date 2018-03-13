# Laszlo Jakab
# Mar 2018

# Setup ---------------------------------------------------

# packages
library(ggplot2)
library(magrittr)

# datasets
combined        <- readRDS("data/combined/combined.Rds")
shrcls.crsp     <- readRDS("data/clean/share_class_crsp_data.Rds")
mfl.crsp        <- readRDS("data/clean/mfl_crsp_nodup.Rds")
funds.in.sample <- readRDS("data/funds_included/funds_in_sample.Rds")
wficn.rdate     <- readRDS("data/clean/wficn_rdate.Rds")


# CompetitorSize Distribution --------------------------------------------------

# convenience function
HistFn <- function(dt, x, nb, title, xlab){
  p <-
    dt %>%
      ggplot() +
      aes_string(x, "..density..") +
      xlab(xlab) +
      ylab("Density") +
      ggtitle(title) +
      geom_histogram(
        bins = nb,
        col = azure,
        fill = azure,
        alpha = .3) +
      theme_bw() +
      theme(plot.title = element_text(hjust = 0.5))
  return(p)
}

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

# convenience function
CRSPPlot <- function(dt, title) {
  p <-
    dt %>%
      ggplot() +
        aes(caldt, N) +
        ylab("#share classes") +
        ggtitle(title) +
        geom_line(colour = azure) +
        theme_bw() +
        theme(plot.title = element_text(hjust = 0.5))
  return(p)
}

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
  title = "Data Availability in the CRSP Mutual Fund Dataset.",
  caption = "Number of share class level observations passing filters for identifying actively managed domestic equity funds. Note that consistent mtna records begin January 1991. Further, there were over 300 share classes added to the dataset in Jan 1991, whose returns come online Feb 1992. However, these added share classes do not have size and expense ratio information, so do not majorly influence the fund level dataset used in the analysis.")


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
    theme_bw() +
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
  caption = "Time series plot of the number of funds reporting during a given month.")


# Industry Size Time Series ----------------------------------------------------

isize <- combined[, .(CompetitorSize = mean(comp.size),
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
    theme_bw() +
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
