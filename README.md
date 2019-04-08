---
title: "mixtureSPRT"
---



mixtureSPRT is a package for performing mixture Sequential Probability Ratio tests. It includes functions for calculating mixing variance and test statistic, as well as methods for plotting and printing. It also contains an option carry out the calculations in C++ as it reduced runtime substantially. This is particularly useful when many tests are performed to see for example sampling distributions or compare the mSPRT to other tests. 

- `calcTau()`
- `mSPRT()`




## Installation


```r
devtools::install_github("shitoushan/mixtureSPRT")
```

## Usage


```r
library(microbenchmark)
y <- rnorm(1000)
x <- rnorm(1000)
sigma = 1
tau = calcTau(0.05,1,100)
theta = 0
distribution="normal"
alpha=0.05


m <- mSPRT(x, y, sigma, tau, useCpp = F)
mcpp <-  mSPRT(x, y, sigma, tau, useCpp = T)

microbenchmark(m,mcpp)
```

```
## Unit: nanoseconds
##  expr min lq   mean median   uq  max neval
##     m  49 70 105.17   79.0 87.5 2606   100
##  mcpp  43 66  87.03   76.5 88.0 1091   100
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
##     m <- mSPRT(x, y, sigma, tau, useCpp = F) 583.583 915.1265 1248.7865
##  mcpp <- mSPRT(x, y, sigma, tau, useCpp = T) 246.521 368.1525  451.4082
##     median       uq      max neval
##  1078.8535 1211.521 6446.875   100
##   387.2655  467.846 2132.278   100
```
