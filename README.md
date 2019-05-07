# mixtureSPRT


mixtureSPRT is a package for performing mixture Sequential Probability Ratio tests. It includes functions for calculating mixing variance and test statistic, as well as methods for plotting and printing. It also contains an option carry out the calculations in C++ as it reduced runtime substantially. This is particularly useful when many tests are performed to see for example sampling distributions or compare the mSPRT to other tests.

- `calcTau()`
- `mSPRT()`

## Under development
This package is developed entirely for the purpose of using it in my thesis. It is under development, and functions will or may change. Use at your own risk.


## Installation


```r
devtools::install_github("shitoushan/mixtureSPRT")
```

## Usage


```r
    set.seed(1337)
     n <- 10000
     m <- mSPRT(x = rnorm(n),
           y = rnorm(n, mean = 0.05),
           sigma = 1,
           tau =  calcTau(alpha = 0.05, sigma = 1, truncation = n),
           theta = 0,
           distribution = "normal",
           alpha = 0.05)

       plot(m)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)



### C++


```r
library(mixtureSPRT)
library(microbenchmark)

y <- rnorm(100)
x <- rnorm(100)
sigma = 1
tau = calcTau(0.05,1,100)
theta = 0
distribution="normal"
alpha=0.05

microbenchmark(
  m <- mSPRT(x,y,sigma,tau,
                     useCpp = F),
  mcpp <-  mSPRT(x,y,sigma,tau,
                         useCpp = T)
)
```

```
## Unit: microseconds
##                                         expr     min       lq      mean
##     m <- mSPRT(x, y, sigma, tau, useCpp = F) 628.662 714.1985 1048.1518
##  mcpp <- mSPRT(x, y, sigma, tau, useCpp = T) 286.912 353.7755  475.9794
##     median       uq      max neval
##  1147.2635 1187.437 2161.006   100
##   470.3565  496.774 2353.099   100
```
