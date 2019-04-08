---
title: "mixtureSPRT"
---



mixtureSPRT is a package for performing mixture Sequential Probability Ratio tests. It includes functions for calculating mixing variance and test statistic, as well as methods for plotting and printing. It also contains an option carry out the calculations in C++ as it reduced runtime substantially. This is particularly useful when many tests are performed to see for example sampling distributions or compare the mSPRT to other tests. 

- `calcTau()`
- `mSPRT()`

#### UNDER DEVELOPMENT
This package is under development. Functions may or will change.

## Installation


```r
devtools::install_github("shitoushan/mixtureSPRT")
```

## Usage


```r
library(microbenchmark)
y <- rnorm(100)
x <- rnorm(100)
sigma = 1
tau = calcTau(0.05,1,100)
theta = 0
distribution="normal"
alpha=0.05

microbenchmark(
  m <- mSPRT(x, y, sigma, tau, useCpp = F),
  mcpp <-  mSPRT(x, y, sigma, tau, useCpp = T)
  )
```

```
## Unit: microseconds
##                                         expr     min       lq      mean
##     m <- mSPRT(x, y, sigma, tau, useCpp = F) 496.605 615.2770 1155.8921
##  mcpp <- mSPRT(x, y, sigma, tau, useCpp = T) 212.730 293.8095  373.8806
##    median       uq       max neval
##  971.9935 1026.951 16331.536   100
##  360.5650  405.710  1154.613   100
```



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
##     m <- mSPRT(x, y, sigma, tau, useCpp = F) 492.069 899.1660 1052.9664
##  mcpp <- mSPRT(x, y, sigma, tau, useCpp = T) 211.314 307.0265  331.3337
##   median       uq       max neval
##  916.083 986.6410 15558.835   100
##  332.403 355.4645   779.424   100
```

