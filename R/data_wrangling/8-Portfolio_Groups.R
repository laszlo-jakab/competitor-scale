# Laszlo Jakab
# Feb 27, 2018

# Setup ------------------------------------------------------------------------

# load packages
pkgs <- c("foreach",
          "doParallel")
lapply(pkgs, library, character.only = TRUE)

# directories
pw.dir <- "data/portfolio"
cs.dir <- "data/competitor_size"


# Load Data --------------------------------------------------------------------

# portfolio weights
pw <- readRDS(file.path(pw.dir, "portfolio_weights.Rds"))[
  , w.adj := NULL]

# fund-month pairs to include (taken from competitor size file for convenience)
wficn.date <- unique(readRDS(file.path(cs.dir, "competitor_size.Rds"))[, .(wficn, date)])
setkey(wficn.date, wficn, date)


# Prep Portfolio Weights -------------------------------------------------------

# keep only fund-month pairs for which both fund size info is available
setkey(pw, wficn, date)
pw <- pw[wficn.date, on = c("wficn", "date"), nomatch = 0]

# split by date
setkey(pw, date, wficn, permno)
pwl <- split(pw, by = "date", keep.by = FALSE)

# list of dates
datel <- sort(unique(wficn.date$date))

# list of portfolio weights and dates
pgl <- Map(list, pwl, datel)

# clean up
rm(pw, pwl, datel)


# Portfolio Groups -------------------------------------------------------------

PortfolioGroups <- function(dt) {

  # get data.table of wide-form portfolio weights
  #   - col 1 includes stock permno
  #   - col 2:k: each includes the portfolio weights for a given fund
  w <- dcast(dt[[1]], wficn ~ permno, value.var = "w", fill = 0)
  fund.ids <- w$wficn
  # extract portfolio weights as a matrix
  w <- as.matrix(w[, 2:dim(w)[2]])

  # get peer group clusters via kmeans
  k = kmeans(w, 10)

  # record portfolio groups
  pg = cbind(fund.ids, year(dt[[2]]), month(dt[[2]]), k$cluster)

  # portfolio centers
  pc = cbind(year(dt[[2]]), month(dt[[2]]),
    as.numeric(colnames(k$centers)), t(k$centers))

  # group size
  gs = cbind(year(dt[[2]]), month(dt[[2]]), t(k$size))

  # append list of output
  list('pg' = pg, 'pc' = pc, 'gs' = gs)
}

# function for binding the results together
cfun <- function(a,b) mapply(rbind, a, b, SIMPLIFY = FALSE)

#setup parallel backend to use all but one of the cores
n.cores <- detectCores()
cl <- makeCluster(n.cores - 1)
#cl <- makeCluster(n.cores)
# register the cluster
registerDoParallel(cl)
# perform the calculations month-by-month
pg.list <-
  foreach (i = pgl,
    .packages = c("data.table", "zoo"),
    .combine = "cfun",
    .inorder = FALSE
  ) %dopar% PortfolioGroups(i)
# unlink cluster
stopCluster(cl)


# sort and save ----------------------------------------------------------------

# portfolio groups
pg.list$pg <- data.table(pg.list$pg)
setnames(pg.list$pg, c("wficn", "year", "month", "port.grp"))
pg.list$pg[
  # date variable corresponding to year and month
  , date := as.yearmon(paste0(year, "-", month))][
  # drop year and month
  , c("year", "month") := NULL]
setcolorder(pg.list$pg, c("wficn", "date", "port.grp"))
setkey(pg.list$pg, wficn, date)
saveRDS(pg.list$pg, file.path(pw.dir, "portfolio_grp.Rds"))

# portfolio centers (i.e. model portfolios)
pg.list$pc <- data.table(pg.list$pc)
setnames(pg.list$pc, c("year", "month", "permno", paste0("port.grp.", seq(10))))
pg.list$pc[
  # date variable corresponding to year and month
  , date := as.yearmon(paste0(year, "-", month))][
  # drop year and month
  , c("year", "month") := NULL]
setcolorder(pg.list$pc, c("permno", "date", paste0("port.grp.", seq(10))))
setkey(pg.list$pc, date, permno)
saveRDS(pg.list$pc, file.path(pw.dir, "portfolio_grp_center.Rds"))

# group size
pg.list$gs <- data.table(pg.list$gs)
setnames(pg.list$gs, c("year", "month", paste0("port.grp.size.", seq(10))))
pg.list$gs <- pg.list$gs[
  # date variable corresponding to year and month
  , date := as.yearmon(paste0(year, "-", month))][
  # drop year and month
  , c("year", "month") := NULL]
setcolorder(pg.list$gs, c("date", paste0("port.grp.size.", seq(10))))
setkey(pg.list$gs, date)
saveRDS(pg.list$gs, file.path(pw.dir, "portfolio_grp_size.Rds"))
