#' Perform mixture Sequential Probability Ratio Test
#'
#' @param x,y Numeric vectors
#' @param sigma Population standard deviation
#' @param tau Mixture variance
#' @param theta Hypothesised difference between \code{x} and \code{y}
#' @param distribution The desired distribution. Currently, only \code{normal} is implemented.
#' @param alpha Significance level
#' @return The likelihood ratio
#' @references \emph{Johari, R., Koomen, P., Pekelis, L. & Walsh, D. 2017, "Peeking at A/B Tests: Why it matters, and what to do about it", ACM, , pp. 1517}
#' @export
#' 
#' @useDynLib mixtureSPRT
#' @importFrom Rcpp sourceCpp
#' NULL


# Validations ------------
mSPRT.default <- function(x, y, sigma, tau, theta=0, distribution='normal', alpha=0.05, useCpp=F){
  # x,y
  is.numeric(x) & is.numeric(y) || stop("x and y must be numeric vectors")
  !is.null(x) & !is.null(y) || stop("x and y cannot be empty")
  length(x) == length(y) || stop("x and y must be of same length")
  
  if(!is.numeric(x) | !is.numeric(y)){
    stop("x and y must be numerical vectors")
  }
  
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
  
  
  ###########
  # FUNC #
  ###########
  n <- length(x)
  z <- x-y
  
  ### Cpp
  if(useCpp == T){
    out <- mixtureSPRT::testing(x = x,
                                y = y,
                                sigma = sigma,
                                tau = tau,
                                theta = theta,
                                distribution = distribution)
  } else if(useCpp == F){
    
    
    
    #################
    
    out <- matrix(NA,length(z))
    if(distribution == "normal"){
      for(i in 1:length(z))
        out[i] <- sqrt((2*sigma^2)/(2*sigma^2 + i *tau^2)) * exp(((i)^2*tau^2*(mean(z[1:i]) - theta)^2) / (4*sigma^2*(2*sigma^2 + i*tau^2)))  
    }
    
    if(distribution == "bernoulli"){
      for(i in 1:length(z)){
        Vn <- mean(x) * (1-mean(x)) + mean(y) * (1-mean(y))
        out[i] <- sqrt((Vn)/(Vn + i*tau^2)) * exp(((i)^2*tau^2*(mean(z[1:i]) - theta)^2) / (2*Vn*(Vn + i*tau^2)))  
      }
    }
    
    #################
  }
  
  
  ##########
  # Output #
  ##########
  
  
  # Decision and text
  n.rejection <- if(max(out) > alpha^(-1)){
    min(which(out>alpha^(-1)))
  }else{
    length(z)
  }
  
  decision <- ifelse(n.rejection < length(z), paste0("Accept H1"), paste0("Accept H0"))
  text <- paste0("Decision made after ",n.rejection," observations were collected")
  
  
  output <- list(
    distribution = distribution,
    n = length(z),
    spr = out,
    n.rejection = n.rejection,
    decision = decision,
    text = text,
    alpha = alpha
  )
  class(output) <- "mSPRT"
  return(output)
  
}


