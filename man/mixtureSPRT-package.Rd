\name{mixtureSPRT-package}
\alias{mixtureSPRT-package}
\alias{mixtureSPRT}
\docType{package}
\title{
  Performs mixture Sequential Probability Ratio test
}
\description{
  A more detailed description of what the package does. A length
  of about one to five lines is recommended.
}
\details{
  \code{mixtureSPRT} includes two functions, \code{mSPRT} for the actual test and \code{calcTau} which calculated a mixture variance based on significance level, population variance andand desired truncation time 
}
\author{
Erik Stenberg

Maintainer: Erik Stenberg <erik.stnb@gmail.com>
}
\references{
  \emph{Johari, R., Koomen, P., Pekelis, L. & Walsh, D. 2017, "Peeking at A/B Tests: Why it matters, and what to do about it", ACM, , pp. 1517}
}
\keyword{ package }
\seealso{
  
}
\examples{
  \dontrun{
    library(mixtureSPRT)
    set.seed(12345)
     n <- 10000
     m <- mSPRT(x = rnorm(n),
           y = rnorm(n, mean = 0.06),
           sigma = 1,
           tau =  calcTau(alpha = 0.05, sigma = 1, truncation = n),
           theta = 0,
           distribution = "normal",
           alpha = 0.05)

       plot(m)
  }
}
