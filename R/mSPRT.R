#' Calculate mixture Sequential Probability Ratio Test
#'
#' @param x,y Numeric vectors
#' @param sigma Population standard deviation
#' @param theta Hypothesised difference between \code{x} and \code{y}
#' @param tau Mixture variance
#' @param alpha Significance level
#' @param distribution The desired distribution. Currently, only \code{normal} is implemented.
#' @return The likelihood ratio
#' @references \emph{Johari, R., Koomen, P., Pekelis, L. & Walsh, D. 2017, "Peeking at A/B Tests: Why it matters, and what to do about it", ACM, , pp. 1517}
#' @export
#' 
mSPRT <-
  function(x, y, sigma, tau, theta=0, distribution="normal", alpha=0.05) {
    UseMethod("mSPRT")
  } 