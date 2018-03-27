# Laszlo Jakab
# Feb 27, 2018

# Setup ------------------------------------------------------------------------

# directories
data.dir <- "data/clean"
out.dir  <- "data/funds_included"

# load datasets
s12type1 <- readRDS(file.path(data.dir, "tfn_s12type1_fvint.Rds"))
mfl.tfn  <- readRDS(file.path(data.dir, "mfl_tfn.Rds"))
mfl.crsp <- readRDS(file.path(data.dir, "mfl_crsp_nodup.Rds"))
fund.hdr <- readRDS(file.path(data.dir, "fund_hdr.Rds"))
fund.style <- readRDS(file.path(data.dir, "fund_style.Rds"))
ret.fund.level <- readRDS(file.path(data.dir, "fund_level_crsp.Rds"))


# Filter funds -----------------------------------------------------------------

# add in wficn to thomson, fund header
s12type1 <- s12type1[mfl.tfn, on = c("fundno", "fdate"), nomatch = 0]
fund.hdr <- fund.hdr[mfl.crsp, on = "crsp_fundno", nomatch = 0]
fund.style <- fund.style[mfl.crsp, on = "crsp_fundno", nomatch = 0]

# get list of included wficns
# list is updated as we proceed (keep track of number of obs in separate vector)
wficns.incl <- intersect(unique(fund.hdr$wficn), unique(s12type1$wficn))
track.obs <- c("Intersect Thomson, CRSP, MFLINKS", length(wficns.incl))

# drop funds that did not meet expense ratio, size, data availability standards
wficns.incl <- intersect(wficns.incl, ret.fund.level[, wficn])
track.obs <- c("Insufficient size, exp. ratio, or data", length(wficns.incl))

# drop fund if ever classified as ioc %in%
# 1 (international), 5 (municipal bond), 6 (bond&preferred), 7 (balanced), 8 (metals)
wficns.incl <- intersect(wficns.incl,
  s12type1[, if (max(ioc %in% c(1, 5:8)) == 0) .SD
           , by = fundno][, wficn])
track.obs <- rbind(track.obs, c("Drop by Thomson IOC", length(wficns.incl)))

# drop index funds (based on index_fund_flag)
wficns.incl <- intersect(wficns.incl,
  fund.hdr[, if (max(index_fund_flag != "") == 0) .SD
           , by = wficn][, wficn])
track.obs <- rbind(track.obs, c("Drop by index_fund_flag", length(wficns.incl)))

# drop index funds (based on "index" in the name)
wficns.incl <- intersect(wficns.incl,
  fund.hdr[, if (max(grepl("index", fund_name, ignore.case = TRUE)) == 0) .SD
           , by = wficn][, wficn])
track.obs <- rbind(track.obs, c("Drop 'index' in name", length(wficns.incl)))

# drop based on non-equity policies
pol.excl <- c("B & P", "Bal", "Bonds", "C & I", "Hedge", "Leases", "GS", "MM",
              "Pfd", "Spec", "TF", "TFE", "TFM")
wficns.incl <- intersect(wficns.incl,
  fund.style[, if (max(policy %in% pol.excl) == 0) .SD
             , by = wficn][, wficn])
track.obs <- rbind(track.obs, c("Drop by policy code", length(wficns.incl)))

# drop if ever classified as target date or sector fund
wficns.incl <- intersect(wficns.incl,
  fund.style[, if (max(crsp_obj_cd == "MT", grepl("^EDS", crsp_obj_cd)) == 0) .SD
             ,by = wficn][, wficn])
track.obs <- rbind(track.obs, c("Drop target date + sector", length(wficns.incl)))

# drop based on fund names
name.excl <- paste(c(
  "internat", "euro", "japan", "emerging market",
  "balanced", " bond fund",
  "20[0-9][0-9]", "retire", "target",
  paste0("tax[- ]", c("manage", "efficien", "exempt", "smart",
                      "advantage", "aware", "sensitive"))
), collapse = "|")
wficns.incl <- intersect(wficns.incl,
  fund.hdr[, if (max(grepl(name.excl, fund_name, ignore.case = TRUE)) == 0) .SD
           , by = wficn][, wficn])
track.obs <- rbind(track.obs, c("Drop by name", length(wficns.incl)))

# define domestic equity
# consider lipper class first
lipper.include <- c("EIEI", "G", "LCCE", "LCGE", "LCVE", "MCCE", "MCGE",
  "MCVE", "MLCE", "MLGE", "MLVE", "SCCE", "SCGE", "SCVE")
fund.style[, domestic.equity := lipper_class %in% lipper.include]

# SI obj code next
si.include <- c("AGG", "GMC", "GRI", "GRO", "ING", "SCG")
fund.style[is.na(lipper_class), domestic.equity := si_obj_cd %in% si.include]

# Wbrger codes last
wbrger.include <- c("G", "G-I", "GCI", "LTG", "MCG", "SCG")
fund.style[is.na(lipper_class) & is.na(si_obj_cd),
  domestic.equity := wbrger_obj_cd %in% wbrger.include]

# any domestic equity?
wficns.incl <- intersect(wficns.incl,
  fund.style[, if (max(domestic.equity) == 1) .SD
  , by = .(wficn)][, wficn])
track.obs <- rbind(track.obs, c("Ever domestic equity", length(wficns.incl)))

# drop if ever classified as a bond fund
wficns.incl <- intersect(wficns.incl,
  fund.style[, if (max(grepl("^I", crsp_obj_cd)) == 0) .SD
  , by = wficn][, wficn])
track.obs <- rbind(track.obs, c("Drop if ever bond fund", length(wficns.incl)))


# drop if the fund is categorized as "foreign" for over a 25% of its lifetime
mean.foreign <- fund.style[
  # select only funds that are in our sample so far
  wficn %in% wficns.incl][
  # length of classification (in days)
  , duration := as.numeric(enddt - begdt + 1)][
  # foreign fund indicator
  , foreign := as.numeric(grepl("^EF", crsp_obj_cd))][
  # fraction of time years for which classified as foreign
  , .(ef.mean = sum(foreign * duration) / sum(duration)), by = wficn]

wficns.incl <- intersect(wficns.incl,
  mean.foreign[, if (ef.mean <= 0.25) .SD
  , by = wficn][, wficn])
track.obs <- rbind(track.obs, c("Drop if foreign > 25% of time", length(wficns.incl)))

# sort and save
wficns.incl <- as.data.frame(wficns.incl)
setDT(wficns.incl)
setnames(wficns.incl, "wficns.incl", "wficn")
setkey(wficns.incl, wficn)
saveRDS(wficns.incl, file.path(out.dir, "funds_in_sample.Rds"))
saveRDS(track.obs, file.path(out.dir, "track_obs.Rds"))
track.obs
