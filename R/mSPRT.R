#' @export
mSPRT <-
  function(x,y,sigma,tau,theta=0,distribution="normal",alpha=0.05) UseMethod("mSPRT")