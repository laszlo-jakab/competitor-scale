# Laszlo Jakab
# 2-21-2018


# Setup ------------------------------------------------------------------------

# load packages
pkgs <- c(
  "rio",
  "FredR")
lapply(pkgs, library, character.only = TRUE)

# relative path for output
data.dir <- "./data/raw/"


# Active share -----------------------------------------------------------------

# source url (Antti Petajisto's website)
activeshare.url <- "http://www.petajisto.net/data/activeshare.sas7bdat"
# download source file (in SAS format, as data.table)
petajisto.activeshare <- data.table(import(activeshare.url))
# keep only important variables
petajisto.activeshare <- petajisto.activeshare[,
  .(wficn, rdate, index, index_min, activeshare, activeshare_min)]
# rename rdate as date and format
setnames(petajisto.activeshare, "rdate", "date")
petajisto.activeshare[, date := as.yearmon(as.Date(date))]
# sort and save as Rds
setkey(petajisto.activeshare, wficn, date)
saveRDS(petajisto.activeshare, file.path(data.dir, "petajisto_activeshare.Rds"))


# Index based factor returns ---------------------------------------------------

cpz.factors.url <- "http://www.petajisto.net/data/factorret_cpz_monthly.sas7bdat"
cpz.factors <- data.table(import(cpz.factors.url))
# UMD and RD are duplicated from Ken French's website; delete them here
cpz.factors[, c("umd", "rf") := NULL]
# standardize date
cpz.factors[, date := as.Date(date)]
setkey(cpz.factors, date)
saveRDS(cpz.factors, file.path(data.dir, "cpz_factors.Rds"))


# CPI --------------------------------------------------------------------------

# load FRED API key
fred.key <- Sys.getenv("FRED_API_KEY")
# start session
fred <- FredR(fred.key)
# download CPI
fred.cpiaucsl <- fred$series.observations(series_id = 'CPIAUCSL')
# clean data
fred.cpiaucsl <- fred.cpiaucsl[, date := as.Date(date)]
fred.cpiaucsl <- fred.cpiaucsl[, .(date, value)] # keep only relevant variables
setnames(fred.cpiaucsl, "value", "cpi")          # rename variables
setkey(fred.cpiaucsl, date)                      # sort by date
# save
saveRDS(fred.cpiaucsl, file.path(data.dir, "fred_cpiaucs.Rds"))


# Sentiment (Baker and Wurgler) ------------------------------------------------

# source url
sentiment.url <- "http://people.stern.nyu.edu/jwurgler/data/Copy%20of%20Investor_Sentiment_Data_20160331_POST.xlsx"
# read in excel spreadsheet
bw.sentiment  <- data.table(import(sentiment.url, sheet = "DATA", na = "."))
# fix time variable
bw.sentiment[, date := as.Date(
    paste(floor(yearmo/100), yearmo - floor(yearmo/100)*100, "01", sep = "-"))]
# keep only sentiment variables (if not missing)
bw.sentiment  <- bw.sentiment[!is.na(SENT), c("date", "SENT^", "SENT")]
# rename, sort and save
setnames(bw.sentiment, old = c("SENT^", "SENT"), new = c("sent_o", "sent"))
setkey(bw.sentiment, date)
saveRDS(bw.sentiment, file.path(data.dir, "bw_sentiment.Rds"))


# Mispricing factors -----------------------------------------------------------

# Stambaugh-Yuan mispricing factors (monthly)
sy.factor.url <- "http://www.saif.sjtu.edu.cn/facultylist/yyuan/M4.csv"
sy.factor     <- fread(sy.factor.url)
# standardize date
sy.factor[, date := as.Date(
  paste(floor(YYYYMM/100), YYYYMM - floor(YYYYMM/100)*100, "01", sep = "-"))]
# keep only necessary variables
sy.factor <- sy.factor[, .(date, MGMT, PERF)]
setnames(sy.factor, tolower(names(sy.factor)))
# sort and save
setkey(sy.factor, date)
saveRDS(sy.factor, file.path(data.dir, "sy_factor.Rds"))

# 11 anomalous returns
sy.anomalous11.url <- "http://www.saif.sjtu.edu.cn/facultylist/yyuan/AnomalyRet_11_Long_Short_Spread.csv"
sy.anomalous11     <- fread(sy.anomalous11.url)
# standardize date variable
sy.anomalous11[, `:=` (
  date   = as.Date(
    paste(floor(YYYYMM/100), YYYYMM - floor(YYYYMM/100)*100, "01", sep = "-")),
  YYYYMM = NULL)]
setcolorder(sy.anomalous11, c("date", setdiff(names(sy.anomalous11), "date")))
setnames(sy.anomalous11, tolower(names(sy.anomalous11)))
# sort and save
setkey(sy.anomalous11, date)
saveRDS(sy.anomalous11, file.path(data.dir, "sy_anomalous11.Rds"))

# Stambaugh-Yu-Yuan mispricing measures for individual stocks
sy.mispricing.url <- "http://www.saif.sjtu.edu.cn/facultylist/yyuan/Misp_Score.csv"
sy.mispricing     <- fread(sy.mispricing.url)
# standardize date variable
sy.mispricing[, `:=` (
  date   = as.Date(
    paste(floor(yyyymm/100), yyyymm - floor(yyyymm/100)*100, "01", sep = "-")),
  yyyymm = NULL)]
setcolorder(sy.mispricing, c("permno", "date", "avg_score"))
# sort and save
setkey(sy.mispricing, permno, date)
saveRDS(sy.mispricing, file.path(data.dir, "sy_mispricing.Rds"))
