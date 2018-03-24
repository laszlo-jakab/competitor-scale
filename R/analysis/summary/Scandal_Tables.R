# Laszlo Jakab
# Mar 10, 2018

# Setup ------------------------------------------------------------------

# dataset
scandal.dt <- readRDS("data/scandal/scandal_dt.Rds")


# Fund Char. by Scandal Involvement, Aug 2003 ----------------------------------

# means by scandal involvement
scandal.snapshot.dt <- scandal.dt[
  # restrict to Aug 2003
  date == "Aug 2003", .(
  # calculate means
    N = .N,
    `$CompetitorSize \\times 10^2$` = mean(CS, na.rm = TRUE) * 10^2,
    `TNA (100m \\$)` = mean(tna, na.rm = TRUE) / 100,
    `$R^{FF3}$` = mean(ra.gross.ff3, na.rm = TRUE),
    `Fund age` = mean(fund.age, na.rm = TRUE),
    `Expense ratio` = mean(f, na.rm = TRUE),
    `$AS$` = mean(AS, na.rm = TRUE),
    `$T$` = mean(T, na.rm = TRUE),
    `$L$` = mean(L, na.rm = TRUE),
    `$ln(TL^{-1/2})$` = mean(ln.TL, na.rm = TRUE))
  , by = scandal.fund]

# reshape the table to convenient format
scandal.snapshot.dt <- dcast(melt(
  scandal.snapshot.dt, id.vars = "scandal.fund"), variable ~ scandal.fund)
setnames(scandal.snapshot.dt, c("Scandal involvement", "No", "Yes"))

# label table
scandal.snapshot = list(
  results = scandal.snapshot.dt,
  title = "Fund Characteristics as of August 2003 by Scandal Involvement",
  caption = "Means of various characteristics as of August 2003, depending on whether the family the fund belongs to was later implicated in the late trading scandal. Returns are annualized, in percentages.")


# Snapshot of Untainted Funds, Aug 2003 ----------------------------------------

untainted.snapshot.dt <- scandal.dt[
  # untainted funds as of Aug 2003
  scandal.fund == 0 & date == "Aug 2003"][
  # split by median scandal exposure
  , high.exp :=
    ifelse(scandal.exposure > median(scandal.exposure), "High", "Low")][
  # calculate means
  , .(
    N = .N,
    `$CompetitorSize \\times 10^2$` = mean(CS, na.rm = TRUE) * 10^2,
    `TNA (100m \\$)` = mean(tna, na.rm = TRUE) / 100,
    `$R^{FF3}$` = mean(ra.gross.ff3, na.rm = TRUE),
    `Fund age` = mean(fund.age, na.rm = TRUE),
    `Expense ratio` = mean(f, na.rm = TRUE),
    `$AS$` = mean(AS, na.rm = TRUE),
    `$T$` = mean(T, na.rm = TRUE),
    `$L$` = mean(L, na.rm = TRUE),
    `$ln(TL^{-1/2})$` = mean(ln.TL, na.rm = TRUE))
  , by = high.exp]

# reshape the table to convenient format
untainted.snapshot.dt <- dcast(melt(
  untainted.snapshot.dt, id.vars = "high.exp"), variable ~ high.exp)
setcolorder(untainted.snapshot.dt, c("variable", "Low", "High"))
setnames(untainted.snapshot.dt, c("$ScandalExposure$:", "Below median", "Above median"))
# format numbers for display
untainted.snapshot.dt <- untainted.snapshot.dt[, `:=`
  (`Below median` = round(`Below median`, 2),
    `Above median` = round(`Above median`, 2))]

# label table
untainted.snapshot = list(
  results = untainted.snapshot.dt,
  title = "Snapshot of Untainted Fund Characteristics as of August 2003",
  caption = "Means of various characteristics as of Aug 2003 for untainted funds, depending on whether the fund's $ScandalExposure$ is above the cross-sectional median.")

# Save Output Tables -----------------------------------------------------------

# collect results and save
scandal.tables = list(by.scandal = scandal.snapshot, by.exposure = untainted.snapshot)
saveRDS(scandal.tables, "tab/summary_stats_scandal.Rds")
