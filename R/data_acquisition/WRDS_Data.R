# Laszlo Jakab
# Apr 2018

# Setup ------------------------------------------------------------------------

# load packages and set options
library(rJava)
.jinit(parameters="-Xmx8g")
library(RJDBC)
library(laszlor)

# relative path where I want output to go
data.dir <- "data/raw"


# Connecting to WRDS -----------------------------------------------------------

# WRDS username and pw, stored in my .Renviron
user <- Sys.getenv("WRDS_USR")
pass <- Sys.getenv("WRDS_PWD")

# path to the WRDS driver (needs to be stored in CLASSPATH in .Renviron)
jar.path <- strsplit(Sys.getenv("CLASSPATH"), ";")[[1]][2]

# establish connection to WRDS server
wrds <- WRDSConnect(user, pass, jar.path)


# Specification of queries -----------------------------------------------------

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


# Loop over queries ------------------------------------------------------------

for(q in query.list){
  WRDSDownload(q, out.dir = data.dir)
}

# close WRDS connection
dbDisconnect(wrds)
