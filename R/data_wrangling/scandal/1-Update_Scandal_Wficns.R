# Laszlo Jakab
# Mar 4, 2018

# Setup ------------------------------------------------------------------------

# load packages
pkgs <- c("rio")
lapply(pkgs, library, character.only = TRUE)

# load datasets
scandal.wficns <- data.table(
  import("data/scandal/old_data/scandal_wficns_200308_v26082017.dta"))
combined <- readRDS("data/combined/combined.Rds")
fund.hdr <- readRDS("data/clean/fund_hdr.Rds")
mfl.crsp <- readRDS("data/clean/mfl_crsp_nodup.Rds")

# add in wficn to fund header
fund.hdr <- fund.hdr[mfl.crsp, on = "crsp_fundno", nomatch = 0]


# Identify New Funds -----------------------------------------------------------

# funds that appear in the current dataset but did not in the last
wficn.aug2003.new <- combined[
  # keep Aug 2003 only from new combined dataset
  date == "Aug 2003"][
  # keep only obs without a match to the old list
  # indicating scandal status as of Aug 2003
  !scandal.wficns, on = "wficn"][
  # add in caldt
  , caldt := as.Date("2003-08-29")][
  # keep only fund identifier and date for convenience
  , .(wficn, caldt)]


# Match New Funds to CRSP Fund Names -------------------------------------------

# setup
wficn.aug2003.new[, caldt2 := caldt]
setkey(wficn.aug2003.new, wficn, caldt, caldt2)
setkey(fund.hdr, wficn, begdt, enddt)
# match
funds.aug2003.new <- foverlaps(wficn.aug2003.new, fund.hdr)[
  # drop unnecessary variables
  , c("open_to_inv", "caldt", "caldt2", "retail_fund", "inst_fund", "m_fund",
      "index_fund_flag", "vau_fund", "et_flag") := NULL]

# split fund_name by family and fund
funds.aug2003.new[, c("fund_family", "fund") := tstrsplit(fund_name, ":")]

# output as excel spreadsheet
setkey(funds.aug2003.new, wficn, crsp_fundno)
export(funds.aug2003.new, "data/scandal/new_data/scandal_fund_update_2018-Mar-06.xlsx")




# Identify Old Funds -----------------------------------------------------------

# funds that appear in the current dataset but did not in the last
wficn.aug2003.old <- combined[
  # keep Aug 2003 only from new combined dataset
  date == "Aug 2003"][
  # keep only obs with a match to the old list
  # indicating scandal status as of Aug 2003
  scandal.wficns, on = "wficn"][
  # add in caldt
  , caldt := as.Date("2003-08-29")][
  # keep only fund identifier, date, and scandal variables
  , .(wficn, caldt, scandal_fund, news_date, formal_charges, settlement)]


# Match Old Funds to CRSP Fund Names -------------------------------------------

# setup
wficn.aug2003.old[, caldt2 := caldt]
setkey(wficn.aug2003.old, wficn, caldt, caldt2)
setkey(fund.hdr, wficn, begdt, enddt)
# match
funds.aug2003.old <- foverlaps(wficn.aug2003.old, fund.hdr)[
  # drop unnecessary variables
  , c("open_to_inv", "caldt", "caldt2", "retail_fund", "inst_fund", "m_fund",
      "index_fund_flag", "vau_fund", "et_flag") := NULL]

# split fund_name by family and fund
funds.aug2003.old[, c("fund_family", "fund1", "fund2") := tstrsplit(fund_name, ":")]

# output as excel spreadsheet
setkey(funds.aug2003.old, wficn, crsp_fundno)
export(funds.aug2003.old, "data/scandal/new_data/scandal_fund_check_2018-Mar-06.xlsx")
