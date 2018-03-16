# Laszlo Jakab
# Mar, 2018

# Setup ------------------------------------------------------------------------

# packages
library(lfe)

# source functions for displaying regressions
source("R/functions/RegDisplay_Fn.R")

# load data
combined <- readRDS("data/combined/combined.Rds")


# data prep

# standardize variables
combined[, `:=` (
  csize.std  = comp.size / sd(comp.size, na.rm = TRUE),
  isize.std = industry.size / sd(industry.size, na.rm = TRUE),
  fsize.std  = fund.size /
    (quantile(fund.size, .5, na.rm = TRUE)-quantile(fund.size, .1, na.rm = TRUE))
)]



# Investor Reaction ---------------------------------------





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
  caption = "The regression sample contains actively managed domestic equity mutual funds from 1980 to 2016. The dependent variable is three-factor adjusted gross returns, in annualized percentages. Size variables are as defined in Section \\@ref(sec:CompetitorSize). $CompetitorSize$ and $IndustrySize$ are normalized by their respective sample standard deviations. $FundSize$ is normalized by the difference between the 50th and 10th percentile of its distribution. Each fund is assigned to one of ten portfolio group clusters each month based on k-means clustering of most recent portfolio holdings. Standard errors are double clustered by fund and year-month $\\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: \\*\\*\\* p<0.01, \\*\\* p<0.05, \\* p<0.1.")









