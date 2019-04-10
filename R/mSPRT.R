#' Calculate mixture Sequential Probability Ratio Test
#'
#' @param x,y Numeric vectors
#' @param sigma Population standard deviation
#' @param tau Mixture variance
#' @param theta Hypothesised difference between \code{x} and \code{y}
#' @param distribution The desired distribution.
#' @param alpha Significance level
#' @param useCpp Boolean. Use C++ for calculations? Useful for running many tests as it reduces runtime substantially
#' @return The likelihood ratio
#' @references Johari, R., Koomen, P., Pekelis, L. & Walsh, D. 2017, 'Peeking at A/B Tests: Why it matters, and what to do about it', ACM, , pp. 1517
#' @section Details:
#' With normal data and normal prior, the closed form solution of the probability ratio after \eqn{n} observations have been collected is:
#' \deqn{\tilde{\Lambda}_n = \sqrt{\frac{2\sigma^2}{V_n + n\tau^2}}\exp{\left(\frac{n^2\tau^2(\bar{Y}_n - \bar{X}_n-\theta_0)^2}{4\sigma2(2\sigma^2+n\tau^2)}\right)}.}
#' With Bernoulli data, the closed form solution is:
#' \deqn{\tilde{\Lambda}_n = \sqrt{\frac{V_n}{V_n + n\tau^2}}\exp{\left(\frac{n^2\tau^2(\bar{Y}_n - \bar{X}_n-\theta_0)^2}{2V_n(V_n+n\tau^2)}\right)}.}
#' @export


mSPRT <- function(x, y, sigma, tau, theta=0, distribution='normal', alpha=0.05, useCpp=F) {
    UseMethod("mSPRT")
  }