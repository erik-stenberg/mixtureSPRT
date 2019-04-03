#' print.mSPRT
#' 
#' @param x An object of class \code{mSPRT}
#' @param ... Further arguments
#' @export
print.mSPRT <- function(x,...){
  cat("Decision: ", x$decision,"\n")
  cat(x$text)
}