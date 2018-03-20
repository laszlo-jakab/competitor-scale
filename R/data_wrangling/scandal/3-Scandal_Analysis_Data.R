# Laszlo Jakab
# Mar 6, 2018

# Setup ------------------------------------------------------------------------

# datasets
combined         <- readRDS("data/combined/combined.Rds")
scandal.wficns   <- readRDS("data/scandal/scandal_wficns_2018-Mar-06.Rds")
scandal.exposure.dt <- readRDS("data/scandal/scandal_exposure.Rds")
scandal.outflow.dt  <- readRDS("data/scandal/scandal_outflow.Rds")


# Aug 2003 Scandal Info --------------------------------------------------------

# keep two years pre- and post- scandal period
combined <- combined["Sep 2001" <= date & date < "Nov 2006"]

# keep only if fund is in sample as of Aug 2003
combined <- combined[
  , is.aug2003 := date == "Aug 2003"][
  , exists.aug2003 := max(is.aug2003), by = wficn][
  exists.aug2003 == 1][
  , c("is.aug2003", "exists.aug2003") := NULL]

# scandal status as of Aug 2003
combined <- combined[scandal.wficns, on = "wficn", nomatch = 0]

# add in scandal exposure
combined <- merge(combined, scandal.exposure.dt, by = "wficn", all.x = TRUE)

# add in scandal outflow
combined <- merge(combined, scandal.outflow.dt, by = c("wficn", "date"), all.x = TRUE)
combined[scandal.fund == 0 & is.na(scandal.outflow), scandal.outflow := 0]


# Data Prep --------------------------------------------------------------------

# convenient variable names
setnames(combined,
  c("comp.size", "activeshare", "exp_ratio", "To"),
  c("CS", "AS", "f", "T"))

# generate log variables
var.to.log <- c("CS", "AS", "fund.size", "f", "L", "S", "D", "C", "B", "T")
combined[, (paste0("ln.", var.to.log)) := lapply(.SD, log), .SDcols = var.to.log]

# post X scandal exposure (with scandal exposure normalized by IQR)
combined[, post.scandal := as.numeric(date >= "Sep 2003")]
scandal.exposure.iqr <- scandal.exposure.dt[, IQR(scandal.exposure)]
combined[, postXscan := post.scandal * scandal.exposure / scandal.exposure.iqr]

# normalize ScandalOutFlow by its IQR
scandal.outflow.iqr <- scandal.outflow.dt[, IQR(scandal.outflow)]
combined[, scandal.outflow := scandal.outflow / scandal.outflow.iqr]

# get variables identifying 1 and 2 year did sample
combined[  # keep only if fund exists in both pre- and post- period
  , exists.pre.post :=
    any(date < "Sep 2003") & any(date >= "Nov 2004"), by = wficn][
  # 1 year DiD window
  , W1.did := ("Sep 2002" <= date & date < "Sep 2003") |
          ("Nov 2004" <= date & date < "Nov 2005")][
  # 2 year DiD window
  , W2.did := ("Sep 2001" <= date & date < "Sep 2003") |
          ("Nov 2004" <= date & date < "Nov 2006")][
  # 1 year DiD sample
  , did.1yr := scandal.fund == 0 & exists.pre.post == TRUE & W1.did == TRUE][
  # 2 year DiD sample
  , did.2yr := scandal.fund == 0 & exists.pre.post == TRUE & W2.did == TRUE][
  # drop helper variables
  , c("exists.pre.post", "W1.did", "W2.did") := NULL]

# variables identifying 1 and 2 year estimation samples, including scandal period
combined[
  , sample.1yr := scandal.fund == 0 & "Sep 2002" <= date & date < "Nov 2005"][
  , sample.2yr := scandal.fund == 0 & "Sep 2001" <= date & date < "Nov 2006"]

# sort and save
setkey(combined, wficn, date)
saveRDS(combined, "data/scandal/scandal_dt.Rds")
