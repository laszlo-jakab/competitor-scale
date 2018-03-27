# Laszlo Jakab
# Mar 2018

# Setup ------------------------------------------------------------------------

# load packages
library(compsizer)


# Load Data --------------------------------------------------------------------

# list of included funds
funds.in.sample <- readRDS("data/funds_included/funds_in_sample.Rds")

# portfolio weights
pw <- readRDS("data/portfolio/portfolio_weights.Rds")[, w := NULL]

# fund size
size <- readRDS("data/clean/fund_level_crsp.Rds")[, .(wficn, date, tna)]

# total market cap of CRSP universe
total.mktcap <- readRDS("data/clean/total_mktcap.Rds")[, .(date, totcap)]


# Prep Datasets ----------------------------------------------------------------

# filter portfolio weight dataset
pw <- pw[
  # keep only funds that meet sample criteria
  funds.in.sample, on = "wficn", nomatch = 0]

# filter fund size dataset
size <- size[
  # keep only funds that meet sample criteria
  funds.in.sample, on = "wficn", nomatch = 0][
  # keep only sample period
  "Mar 1980" <= date & date <= "Dec 2016"][
  # restrict to quarter-end months
  month(date) %in% c(3, 6, 9, 12)]

# normalize tna by total mkt cap
size <- size[
  total.mktcap, on = "date", nomatch = 0][
  , fund.size := tna * 10^6 / totcap][
  , c("tna", "totcap") := NULL]


# Split by Date and Calculate Cosine Similarity ----------------------------------------------------------------

# csl is list of wide-form weight matrices and fund size matrices by date
csl <- SplitByDate(pw, size, w.var = "w.adj")

# clean up memory
rm(pw, size, funds.in.sample, total.mktcap)

# replace weight matrix with
# cosine similarity matrix (diagonal set to zero)
i.list <- seq_along(csl)
pb <- txtProgressBar(max = length(i.list), style = 3)
for (i in i.list) {
  csl[[i]][[1]] <- CosSim(csl[[i]][[1]])
  diag(csl[[i]][[1]]) <- 0
  setTxtProgressBar(pb, i)
}
close(pb)


# Delta (log) CompetitorSize ---------------------------------------------------

# perform the calculations quarter-by-quarter
# loop through time and get ln_DCS
dcs.dt <- data.table(
  wficn = numeric(), date = character(), dln.comp.size = numeric())
for (i in (2:length(csl))) {

  # last period's similarity, fund size
  cos.sim.last   <- csl[[i-1]][[1]]
  fund.size.last <- csl[[i-1]][[2]]

  # last period competitor size
  if (!identical(rownames(cos.sim.last), rownames(fund.size.last))) {
    stop("Last period funds do not match")
  }
  cs.last <- cos.sim.last %*% fund.size.last

  # this period's fund size
  fund.size.this <- csl[[i]][[2]]

  # intersect last period's similarity and this period's fund size
  wficns.this <- intersect(
    rownames(cos.sim.last), rownames(fund.size.this))

  # funds that are both in last quarter's cosine similarity and
  # this quarter's fund size
  cos.sim.this   <- cos.sim.last[wficns.this, wficns.this]
  fund.size.this <- fund.size.this[wficns.this, , drop = FALSE]

  # competitor size using this period's fund size
  if (!identical(rownames(cos.sim.this), rownames(fund.size.this))) {
    stop("This period funds do not match")
  }
  cs.this <- cos.sim.this %*% fund.size.this

  # keep only if observe fund size at both t-1 and t
  wficns.both <- intersect(rownames(cs.last), rownames(cs.this))
  cs.last <- cs.last[wficns.both, , drop = FALSE]
  cs.this <- cs.this[wficns.both, , drop = FALSE]
  if (!identical(rownames(cs.last), rownames(cs.this))) {
    stop("Funds must match for calculating Delta CS")
  }
  cs.dl <- data.table(log(cs.this)-log(cs.last), keep.rownames = TRUE)
  setnames(cs.dl, c("wficn", "dln.comp.size"))
  cs.dl[, wficn := as.numeric(wficn)]
  cs.dl[, date:= csl[[i]][[3]]]

  # output
  dcs.dt <- rbind(dcs.dt, cs.dl)
}

# fix date variable
dcs.dt[, date := as.yearmon(date)]
# sort and save
setkey(dcs.dt, wficn, date)
saveRDS(dcs.dt, "data/competitor_size/dln_competitor_size.Rds")
