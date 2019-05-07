#' Perform mixture Sequential Probability Ratio Test
#'
#' @param x,y Numeric vectors
#' @param xpre,ypre Numeric vectors of pre-experiment data
#' @param sigma Population standard deviation
#' @param tau Mixture variance
#' @param theta Hypothesised difference between \code{x} and \code{y}
#' @param distribution The desired distribution. Currently, only \code{normal} is implemented.
#' @param alpha Significance level
#' @return The likelihood ratio
#' @references Johari, R., Koomen, P., Pekelis, L. & Walsh, D. 2017, "Peeking at A/B Tests: Why it matters, and what to do about it", ACM, , pp. 1517
#' @name mSPRT.default
#' @export
#' @useDynLib mixtureSPRT
#' @importFrom Rcpp sourceCpp
NULL


# Validations ------------
mSPRT.default <- function(x, y, xpre = NULL, ypre = NULL, sigma, tau, theta=0, distribution='normal', alpha=0.05, useCpp=F){
  !is.null(x) & !is.null(y) || stop("x and y cannot be empty")
  length(x) == length(y) || stop("x and y must be of same length")
  burnIn = 100
  
  x <- tryCatch(expr = as.numeric(x),
                warning = function(w) {
                  message("x and y must be numerical vectors")
                  stop()
                })
  
  # sigma
  if(distribution=="normal"){
    is.numeric(sigma) || stop("sigma must be numeric")  
  }
  
  # theta
  is.numeric(theta) || stop("theta must be numeric")
  
  # tau
  (is.numeric(tau) & tau > 0) || stop("tau must be numeric and positive")
  
  # tau
  (is.numeric(alpha) & alpha > 0 & alpha < 1 ) || stop("Significance level must be between 0 and 1")
  
  
  # distribution
  distribution <- as.character(distribution)
  if(!tolower(distribution) %in% c("normal","bernoulli")){
    stop("Distribution should be either 'normal' or 'bernoulli'")
  }
  
  
  ##################
  
  n <- length(x)
  z <- x-y
  
  ###################
  ### CALC IN C++ ###
  ###################
  
  if(useCpp == T){
    
    ### Normal ### 
    
    if(distribution == "normal") {
      
      out <- mixtureSPRT::cppmSPRT(x = x,
                                   y = y,
                                   xpre = xpre,
                                   ypre = ypre,
                                   sigma = sigma,
                                   tau = tau,
                                   theta = theta,
                                   distribution = distribution)
      
      
      ### Bernoulli ###
      
    } else if (distribution == "bernoulli") {
      
      out <- mixtureSPRT::cppmSPRT(x = x,
                                   y = y,
                                   xpre = xpre,
                                   ypre = ypre,
                                   sigma = sigma,
                                   tau = tau,
                                   theta = theta,
                                   distribution = distribution)
      
      
    }
    
  } 
  
  #################
  ### CALC IN R ###
  #################
  
  else if(useCpp == F){
    
    ### Normal ###
    
    out <- matrix(NA,length(x))
    if(distribution == "normal"){
     
       if(!is.null(xpre) & !is.null(ypre)){
        
        for(i in burnIn:length(x)){
          
          k <- 0.5 * ((cov(xpre[1:i], x[1:i])/var(xpre[1:i])) + (cov(ypre[1:i], y[1:i])/var(ypre[1:i])))
          
          xn <- x[1:i] - k * xpre[1:i]
          yn <- y[1:i] - k * ypre[1:i]
          rho <- 0.5*(cor(x[1:i],xpre[1:i]) + cor(y[1:i],ypre[1:i]))
          
          out[i] <- sqrt((2*sigma^2*(1-rho^2))/(2*sigma^2*(1-rho^2) + i*tau^2)) * exp(((i)^2*tau^2*(mean(xn)-mean(yn) - theta)^2) / (4*sigma^2*(1-rho^2)*(2*sigma^2*(1-k^2) + i*tau^2)))
          
        }
         out[1:burnIn] <- 0
        
      } else if( is.null(xpre) | is.null(ypre)) {
        
        for(i in 1:length(z)){
          out[i] <- sqrt((2*sigma^2)/(2*sigma^2 + i*tau^2)) * exp(((i)^2*tau^2*(mean(x[1:i]) - mean(y[1:i]) - theta)^2) / (4*sigma^2*(2*sigma^2 + i*tau^2)))  

        }
      }
      
      out <- as.vector(out)
    }
      
      
      ### Bernoulli ###
      
      else if(distribution == "bernoulli"){
        
        if(!is.null(xpre) & !is.null(ypre)){
          
          for(i in burnIn:length(x)){
            k <- 0.5 * ((cov(xpre[1:i], x[1:i])/var(xpre[1:i])) + (cov(ypre[1:i], y[1:i])/var(ypre[1:i])))
            
            xn <- x[1:i] - k * xpre[1:i]
            yn <- y[1:i] - k * ypre[1:i]
            
            Vn <- mean(xn[1:i]) * (1 - mean(xn[1:i]))  +   mean(yn[1:i]) * (1 - mean(yn[1:i]))
            
            out[i] <- sqrt((Vn)/(Vn + i*tau^2)) * exp(((i)^2*tau^2*(mean(xn[1:i])-mean(yn[1:i]) - theta)^2) / (2*Vn*(Vn + i*tau^2)))  
          }
        } else if( is.null(xpre) | is.null(ypre)){
          
          
          for(i in burnIn:length(z)){
            Vn <- mean(x[0:i]) * (1-mean(x[0:i])) + mean(y[0:i]) * (1-mean(y[0:i]))
            out[i] <- sqrt((Vn)/(Vn + i*tau^2)) * exp(((i)^2*tau^2*(mean(z[1:i]) - theta)^2) / (2*Vn*(Vn + i*tau^2)))  
          }
        }
        out[1:burnIn] <- 0
        out <- as.vector(out)
      }
    }
    
    #################
    
    
    ##########
    # Output #
    ##########
    
    
    # Decision and text
    n.rejection <- if(max(out,na.rm = T) > alpha^(-1)){
      min(which(out>alpha^(-1)))
    }else{
      length(z)
    }
    
    decision <- ifelse(n.rejection < length(x), paste0("Accept H1"), paste0("Accept H0"))
    text <- paste0("Decision made after ",n.rejection," observations were collected")
    
    
    output <- list(
      distribution = distribution,
      n = length(x),
      spr = out,
      n.rejection = n.rejection,
      decision = decision,
      text = text,
      alpha = alpha
    )
    class(output) <- "mSPRT"
    return(output)
    
  }
  
  
  