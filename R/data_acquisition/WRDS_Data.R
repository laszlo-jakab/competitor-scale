# Laszlo Jakab
# Feb 2018

# ------------------------------------------------------------------------------
# Setup
# ------------------------------------------------------------------------------

# relative path where I want output to go
data.dir <- "./data/raw/"

# ------------------------------------------------------------------------------
# connecting to WRDS
# ------------------------------------------------------------------------------

# necessary packages and options
# load packages and set options
library(rJava)
.jinit(parameters="-Xmx8g")
library(RJDBC)

# WRDS username and pw, stored in my .Renviron
user <- Sys.getenv("WRDS_USR")
pass <- Sys.getenv("WRDS_PWD")

# start WRDS session
wrdsconnect <- function(user=user, pass=pass){
  drv <- JDBC("com.sas.net.sharenet.ShareNetDriver",
              "C:/Users/Laszlo/Documents/WRDS_Drivers/sas.intrnet.javatools.jar",
              identifier.quote="`")
  wrds <- dbConnect(drv, "jdbc:sharenet://wrds-cloud.wharton.upenn.edu:8551/",
                    user, pass)
  return(wrds)
}

wrds <- wrdsconnect(user=user, pass=pass)



# ------------------------------------------------------------------------------
# Helper function for performing queries
# ------------------------------------------------------------------------------

# eats:
#  (1) three strings:
#        i.   name of dataset
#        ii.  query for data to be pulled
#        iii. query for variable names or supplied variable names
#  (2) number of records to pull (default is all)
#  (3) database connection (default wrds)
#  (4) output (relative) directory
#
# outputs:
# data.table of the resulting dataset
#
# clean-up:
# (1) save each object as rds
# (2) clear objects from workspace

query.fn <- function(qstr, nobs = -1, con = wrds, out.dir = data.dir) {

  # retrieve data
  db.query <- dbSendQuery(con, qstr[2])                  # send query
  dt <- setDT(dbFetch(db.query, n = nobs))               # pull data
  dbClearResult(db.query)                                # clear query
  # is the query for all variables in the dataset?
  q.all.vars <- grepl("select \\*", qstr[2])

  # if yes, then grab variable names from database and assign to dataset
  if(q.all.vars == TRUE) {
    nm.query <- dbSendQuery(con, qstr[3])                # send query
    dt.names <- dbFetch(nm.query, n = -1)                # pull variable names
    dbClearResult(nm.query)                              # clear query
    dt.names <- gsub("\\s+", "", dt.names$`Column Name`) # clean whitespace
  } else {
    # otherwise, use user-specified list of variable names
    dt.names <- unlist(strsplit(qstr[3], ","))           # user specified
    dt.names <- gsub("\\s+", "", dt.names)               # clean whitespace
  }

  # set clean variable names
  setnames(dt, dt.names)

  # save data
  saveRDS(dt, file.path(data.dir,paste0(qstr[1],".Rds")))
  # clean workspace
  rm(list = c("db.query", "dt", "q.all.vars", "dt.names"))
}

# ------------------------------------------------------------------------------
# Specification of queries
# ------------------------------------------------------------------------------

query.list <- list(
  # MFLINKS: crsp_fundno-wficn
  c("mfl_crsp",
    "select * from MFL.MFLINK1",
    "select name from dictionary.columns where libname='MFL' and memname='MFLINK1'"
  ),
  # MFLINKS: fundno-wficn
  c("mfl_tfn",
    "select FUNDNO, FDATE, WFICN from MFL.MFLINK2 where WFICN is not null",
    "fundno, fdate, wficn"
  ),
  # FF monthly factors
  c("ff_factors",
    "select YEAR, MONTH, MKTRF, SMB, HML, UMD, RF from FF.FACTORS_MONTHLY",
    "year, month, mktrf, smb, hml, umd, rf"
    ),
  # Thomson: S12-Type1
  c("tfn_s12type1",
    "select FUNDNO, FDATE, RDATE, FUNDNAME, MGRCOAB, IOC from TFN.S12TYPE1",
    "fundno, fdate, rdate, fundname, mgrcoab, ioc"
    ),
  # Thomson: S12-Type3
  c("tfn_s12type3",
    "select FUNDNO, FDATE, CUSIP, SHARES from TFN.S12TYPE3",
    "fundno, fdate, cusip, shares"
    ),
  # CRSP: FUND_HDR
  c("crsp_fund_hdr",
    "select * from CRSPQ.FUND_HDR",
    "select name from dictionary.columns where libname='CRSPQ' and memname='FUND_HDR'"
    ),
  # CRSP: FUND_HDR_HIST
  c("crsp_fund_hdr_hist",
    "select * from CRSPQ.FUND_HDR_HIST",
    "select name from dictionary.columns where libname='CRSPQ' and memname='FUND_HDR_HIST'"
  ),
  # CRSP: FUND_HDR_HIST
  c("crsp_fund_hdr_hist",
    "select * from CRSPQ.FUND_HDR_HIST",
    "select name from dictionary.columns where libname='CRSPQ' and memname='FUND_HDR_HIST'"
  ),
  # CRSP: MONTHLY_RETURNS
  c("crsp_mret",
    "select CRSP_FUNDNO, CALDT, MRET from CRSPQ.MONTHLY_RETURNS",
    "crsp_fundno, caldt, mret"
    ),
  # CRSP: MONTHLY_TNA
  c("crsp_mtna",
    "select CRSP_FUNDNO, CALDT, MTNA from CRSPQ.MONTHLY_TNA",
    "crsp_fundno, caldt, mtna"
  ),
  # CRSP: MONTHLY_NAV
  c("crsp_mnav",
    "select CRSP_FUNDNO, CALDT, MNAV from CRSPQ.MONTHLY_NAV",
    "crsp_fundno, caldt, mnav"
  ),
  # CRSP: FUND_FEES
  c("crsp_fund_fees",
    "select * from CRSPQ.FUND_FEES",
    "select name from dictionary.columns where libname='CRSPQ' and memname='FUND_FEES'"
  ),
  # CRSP: FUND_STYLE
  c("crsp_fund_style",
    "select * from CRSPQ.FUND_STYLE",
    "select name from dictionary.columns where libname='CRSPQ' and memname='FUND_STYLE'"
  ),
   # CRSP: FUND_SUMMARY
   c("crsp_fund_summary",
     "select * from CRSPQ.FUND_SUMMARY",
     "select name from dictionary.columns where libname='CRSPQ' and memname='FUND_SUMMARY'"
  ),
   # CRSP: STOCKNAMES
   c("crsp_stocknames",
     "select * from CRSPQ.STOCKNAMES",
     "select name from dictionary.columns where libname='CRSPQ' and memname='STOCKNAMES'"
  ),
  # CRSP: DSEDELIST
  c("crsp_dsedelist",
    "select PERMNO, DLSTDT, DLSTCD, DLRET from CRSPQ.DSEDELIST",
    "permno, dlstdt, dlstcd, dlret"
  ),
  # CRSP: MSEDELIST
  c("crsp_msedelist",
    "select PERMNO, DLSTDT, DLSTCD, DLRET, DLAMT, DLPDT from CRSPQ.MSEDELIST",
    "permno, dlstdt, dlstcd, dlret, dlamt, dlpdt"
  ),
  # CRSP: MSF (monthly stock file)
  c("crsp_msf",
    "select CUSIP, PERMNO, DATE, PRC, RET, SHROUT, CFACPR, CFACSHR
      from CRSPQ.MSF",
    "cusip, permno, date, prc, ret, shrout, cfacpr, cfacshr"
  )
)

# ------------------------------------------------------------------------------
# loop over queries
# ------------------------------------------------------------------------------
for(q in query.list){
  print(q)
  query.fn(q)
  print("done")
}

# close WRDS connection
dbDisconnect(wrds)

