# Calculates CompetitorSize vector.
#
# Two inputs:
#   (1) A symmetric N x N matrix of fund similarities
#   (2) An N x 1 fund size matrix
#
# Output:
#   N x 1 matrix of CompetitorSize values

CompSize <- function(sim.mat, fund.size) {

  # check inputs
  if (class(sim.mat)   != "matrix") {
    stop("First argument must be a matrix")
    }
  if (class(fund.size) != "matrix") {
    stop("Second argument must be a matrix")
    }

  if (!isSymmetric(sim.mat)) {
    stop("Similarity matrix must be symmetric")
  }
  if (any(!is.finite(sim.mat))) {
    stop("Similarity matrix must have no missing values")
  }

  if (any(!is.finite(fund.size))) {
    stop("Fund size must be non-missing")
  }
  if (any(fund.size < 0)) {
    stop("Fund size must be non-negative")
  }

  # make sure funds are lined up correctly
  if (!identical(rownames(sim.mat), rownames(fund.size))) {
    stop("Row names do not match")
  }

  # exclude own fund
  diag(sim.mat) <- 0
  # calculate competitor size
  cs <- sim.mat %*% fund.size
  return(cs)
}
