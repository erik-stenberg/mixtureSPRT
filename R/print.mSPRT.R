#' print.mSPRT
#' 
#' @param x An object of class \code{mSPRT}
#' @param ... Further arguments
#' @export
print.mSPRT <- function(x,...){

  cat(" Decision: ", x$decision,"\n",
      x$text)
  cat(if(x$decision == "Accept H0"){" (truncated)"},
      "\n", "Distribution:", x$distribution,"\n",
      "Significance level:", x$alpha, "\n")
  if(max(x$spr) < x$alpha^(-1)){
    cat(" Probability Ratio after last observation:", round(max(x$spr),2),"\n",
        "Rejection Region: ", "Prob. Ratio > ", x$alpha^(-1))
  }
}

