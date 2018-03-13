# Laszlo Jakab
# Mar 2018

# Setup ---------------------------------------------------

# datasets
combined        <- readRDS("data/combined/combined.Rds")
fload           <- readRDS("data/benchmarked_returns/factor_loadings.Rds")

# Function to Calculate N, mean, sd, quantiles ---------------------------------

SumFn <- function(x) {
  qs <- c(.01, .1, .25, .5, .75, .9, .99)
  c(list(
    sum(!is.na(x)),
    mean(x, na.rm = TRUE),
    sd(x, na.rm = TRUE)),
    quantile(x, qs, na.rm = TRUE))
}
# names for later
col.names <- c("N", "mean", "sd",
  paste0("p", c(.01, .1, .25, .5, .75, .9, .99)*100))


# Adjust Scale -----------------------------------------------------------------
combined[, `:=` (
  fund.sizex104 = fund.size*10^4,
  tna.real2017100 = tna.real2017/100,
  cs102 = comp.size*10^2,
  Lx10 = L*10,
  Dx10 = D*10,
  Cx10 = C*10
)]
fload[, c("a.ff3.gross", "a.ff3.net") :=
  list(a.ff3.gross*100*12, a.ff3.net*100*12)]


# Fund Level -------------------------------------------------------------------

# list of variables
others <- c("exp_ratio", "Lx10", "S", "Dx10", "Cx10", "B")
fund.level.vars <- c("a.ff3.gross", "a.ff3.net", others)

# summary stat table
ss.fund <-  t(
  # FF3 alphas
  fload[, .(wficn, a.ff3.gross, a.ff3.net)][
  # fund-level means from fund-month level data
  combined[, lapply(.SD, mean, na.rm = TRUE), .SDcols = others, by = wficn],
  on = "wficn"][
  # calculate summary stats
  , lapply(.SD, SumFn), .SDcols = fund.level.vars])
# latex-compatible variable labels
rownames(ss.fund) <- c(
    "$\\bar{R}^{FF3}$", "$\\bar{R}^{FF3}$ (net)",
    "$\\overline{\\text{Expense ratio}}$", "$\\bar{L}\\times 10$",
    "$\\bar{S}$", "$\\bar{D}\\times 10$", "$\\bar{C}\\times 10$", "$\\bar{B}$")


# Fund-Month Level -------------------------------------------------------------

# list of variables for which to calculate sumstats
var.list <- c(
  "ra.gross.ff3", "ra.net.ff3", "exp_ratio",
  "cs102", "industry.size",
  "fund.sizex104", "tna.real2017100", "fund.age",
  "activeshare", "ln.TL",
  "To", "Lx10", "S", "Dx10", "Cx10", "B")
# calculate sumstats
ss.fund.month <- t(combined[, lapply(.SD, SumFn), .SDcols = var.list])
# label variables according to latex conventions
rownames(ss.fund.month) <- c(
    "$R^{FF3}$", "$R^{FF3}$ (net)", "Expense ratio", "$CompetitorSize$",
    "$IndustrySize$", "$FundSize \\times 10^4$", "TNA (2017$100m)",
    "$FundAge$", "$AS$", "$\\ln(TL^{-1/2})$", "$T$", "$L\\times 10$",
    "$S$", "$D\\times 10$", "$C\\times 10$", "$B$")


# Output Table -----------------------------------------------------------------

# combine tables and coerce into matrix
colnames(ss.fund) <- col.names
colnames(ss.fund.month) <- col.names
ss.both <- rbind(ss.fund, ss.fund.month)
ss.both <- matrix(unlist(ss.both), dim(ss.both)[1], dim(ss.both)[2])
colnames(ss.both) <- col.names
rownames(ss.both) <- c(rownames(ss.fund), rownames(ss.fund.month))

summary.stats <- list(
  results = ss.both,
  sub.results = list(fund.level = ss.fund, fund.month.level = ss.fund.month),
  title = "Summary Statistics",
  caption = "Alphas, returns, and expense ratios are expressed in annualized percentages. $L$, $S$, $D$, $C$, and $B$ are portfolio liquidity, stock liquidity, diversification, coverage, and balance, respectively, as defined in @pst17L, calculated with respect to the market portfolio of U.S. common equity. $CompetitorSize$ is the portfolio similarity weighted size of each fund's competitors, as defined in Section \\@ref(sec:CompetitorSize). $IndustrySize$ is the total net assets of the funds in the sample, divided by the total market capitalization of all U.S. common equity in CRSP. $FundAge$ is the number of years since the fund's inception. $FundSize$ is the TNA of each fund as a fraction of the total market capitalization of all U.S. common equity in CRSP. $AS$ is active share (relative to self declared benchmarks), as defined in @cp09, @petajisto13. $T$ is turnover ratio as defined by CRSP, winsorized at 1%.")


# Correlation Tables -----------------------------------------------------------

# list of variables for which to calculate correlations
cor.list <- c("comp.size", "ra.gross.ff3", "exp_ratio", "fund.size",
  "fund.age", "activeshare", "To", "L", "ln.TL", "industry.size")

# unconditional pairwise correlations
cor.uncond <- cor(combined[, .SD, .SDcols = cor.list],
  use = "pairwise.complete.obs")
# keep lower triangle only
cor.uncond[upper.tri(cor.uncond)] <- NA

# within-fund correlations
within.fund <- combined[
  , lapply(.SD, function(x) x - mean(x, na.rm = TRUE))
    , by = wficn, .SDcols = cor.list]
# calculate pairwise correlations
cor.within <- cor(within.fund[, .SD, .SDcols = cor.list],
  use = "pairwise.complete.obs")
# keep lower triangle
cor.within[upper.tri(cor.within)] <- NA

# pretty-up results
cor.colnames <- c(
  "$Comp.$ $Size$", "$R^{FF3}$", "Exp. ratio", "$FundSize$", "$Fund$ $Age$",
  "$AS$", "$T$", "$L$", "$\\ln(TL^{-1/2})$", "$Ind.$ $Size$")
cor.rownames <- c(
  "$CompetitorSize$", "$R^{FF3}$", "Expense ratio", "$FundSize$", "$FundAge$",
  "$AS$", "$T$", "$L$", "$\\ln(TL^{-1/2})$", "$IndustrySize$")
colnames(cor.uncond) <- cor.colnames
colnames(cor.within) <- cor.colnames
rownames(cor.uncond) <- cor.rownames
rownames(cor.within) <- cor.rownames
cor.both <- rbind(cor.uncond, cor.within)

correlations <- list(
  results = cor.both,
  sub.results = list(unconditional = cor.uncond, within.fund = cor.within),
  title = "Correlations",
  caption = "The table presents pairwise correlations. Variables are defined in earlier tables.")


# Collect and Save -----------------------------------------------------------

summary.tab <- list(summary.stats = summary.stats, correlations = correlations)
saveRDS(summary.tab, "tab/summary_stats.Rds")
