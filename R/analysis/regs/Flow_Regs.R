# Laszlo Jakab
# Mar, 2018

# Setup ------------------------------------------------------------------------

# packages
library(lfe)
library(laszlor)

# load data
combined <- readRDS("data/combined/combined.Rds")
scandal  <- readRDS("data/scandal/")


# Data Prep ---------------------------------------------------

# net log flows
combined[, flow.log.raw := log(tna / (tna.lagged * (1 + r.net / (12 * 100))))]
combined[, flow.log := psych::winsor(flow.log.raw, trim = .01)]

combined[, diff := round((date - shift(date))*12), by = wficn]
combined[diff == 1, flow.next := shift(flow, type = "lead"), by = wficn]

merge(cpi, copy(cpi)[, date := date + 1/12], by = "date", all.x = TRUE)


# Flows and Competitor Scale ---------------------------------------------------




hist(combined[, flow])


