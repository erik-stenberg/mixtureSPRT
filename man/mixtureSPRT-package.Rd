\name{mixtureSPRT-package}
\alias{mixtureSPRT-package}
\alias{mixtureSPRT}
\docType{package}
\title{
  mixture Sequential Probability Ratio test
}
\description{
  Perform mixture Sequential Probability Ratio Test (mSPRT).
}
\details{
  This package implements the mixture Sequential Probability Ratio Test (mSPRT) with normally distributed data and normal mixture distribution, as described in \emph{"Peeking at A/B Tests: Why it matters, and what to do about it"}. It containts a function for actual calculation of the test statistic, as well as plot and print methods and decision. It also contains a function to calculate the optimal mixture variance given desired significance level, population variance and truncation time of the test.
}
\author{
Erik Stenberg

Maintainer: Erik Stenberg <erik.stnb@gmail.com>
}
\references{
  \emph{Johari, R., Koomen, P., Pekelis, L. & Walsh, D. 2017, "Peeking at A/B Tests: Why it matters, and what to do about it", ACM, pp. 1517}
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
