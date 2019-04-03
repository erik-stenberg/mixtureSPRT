#' Print mSPRT
#'
#' @param x An object of class \code{mSPRT}
#' @param ... other
#' @export
#' 
print.mSPRT <- function(x,...){
  cat("Decision: ", x$decision,"\n")
  cat(x$text)
}