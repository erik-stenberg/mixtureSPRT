#' Calculate Mixture Variance
#' 
#' @param alpha Significance level
#' @param sigma Population standard deviation
#' @param truncation Desired truncation time for mSPRT
#' @return tau Optimal mixture variance \eqn{\tau} for mSPRT.
#' @references \emph{Johari, R., Koomen, P., Pekelis, L. & Walsh, D. 2017, "Peeking at A/B Tests: Why it matters, and what to do about it", ACM, , pp. 1517} 
calcTau <- function(alpha, sigma, truncation) {
  is.numeric(alpha) & alpha > 0 & alpha < 1 || stop("Alpha must be between 0 and 1")
  b <- (2*log(alpha^(-1)))/(truncation*sigma^2)^(1/2)
  return(round(sigma^2 *( pnorm(-b) / ((1/b)*dnorm(b) - pnorm(-b)) ),2))
}