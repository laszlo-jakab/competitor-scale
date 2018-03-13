# Calculates cosine similarity between the columns of a matrix.
# Returns a (K x K) matrix of similarities.
# By default, the returned matrix is symmetric.
# If lower.tri.only = TRUE, the returned matrix
# only includes the lower triangle. This is useful for saving space.
#
# Note: I require the input matrix to have named columns, as I use
# these names in later calculations.

CosSim <- function(x, lower.tri.only = FALSE) {

  # check argument
  if (class(x) != "matrix") {
    stop("Argument must be a matrix")
  }
  if (any(!is.finite(x))) {
    stop("Argument must have no missing values")
  }
  if (is.null(colnames(x))) {
    stop("Please name matrix columns")
  }

  # numerator: dot products between columns
  cos.sim.numerator <- crossprod(x)
  # denominator: product of column magnitudes
  cos.sim.denominator <- tcrossprod(sqrt(colSums(x^2)))
  # cosine similarity
  cos.sim <- cos.sim.numerator / cos.sim.denominator

  # do you want the lower
  if (lower.tri.only == TRUE) {
    cos.sim[upper.tri(cos.sim)] <- NA
  }

  return(cos.sim)
}
