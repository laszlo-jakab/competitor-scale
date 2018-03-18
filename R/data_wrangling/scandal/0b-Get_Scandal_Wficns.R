# Laszlo Jakab
# 3/6/2018

# Setup ------------------------------------------------------------------------

# packages
library(rio)

# data directory
scandal.dir <- "data/scandal"

# load data
old.wficns <- data.table(
  import(file.path(scandal.dir, "new_data/scandal_fund_check_2018-Mar-06_filled.xlsx"),
    readxl = FALSE))
new.wficns <- data.table(
  import(file.path(scandal.dir, "new_data/scandal_fund_update_2018-Mar-06_filled.xlsx"),
    readxl = FALSE))


# Fund Scandal Status ----------------------------------------------------------

old.scandal <- old.wficns[
  # format news_date (using origin of windows excel dates)
  , news_date := as.Date(news_date, origin = "1899-12-30")][
  # placeholder for missing news_date
  is.na(news_date), news_date := as.Date("2018-01-01")][
  # take max of scandal status and min of news date
  , .(scandal.fund = max(scandal_fund),
      news.date    = min(news_date)), by = wficn][
  # get rid of placeholder date
  year(news.date) >= 2018, news.date := NA]

new.scandal <- new.wficns[
  # format news_date (using origin of windows excel dates)
  , Newsdate := as.Date(Newsdate, origin = "1899-12-30")][
  # placeholder for missing Newsdate
  is.na(Newsdate), Newsdate := as.Date("2018-01-01")][
  # clean missing values for scandal status (signifying non-involvement)
  is.na(Involved), Involved := 0][
  # take max of scandal status, and min of news date
  , .(scandal.fund = max(Involved),
      news.date    = min(Newsdate)), by = wficn][
  # get rid of placeholder date
  year(news.date) >= 2018, news.date := NA]

# append old and new
scandal.wficns <- rbind(old.scandal, new.scandal)

# sort and save
setkey(scandal.wficns, wficn)
saveRDS(scandal.wficns, file.path(scandal.dir, "scandal_wficns_2018-Mar-06.Rds"))
