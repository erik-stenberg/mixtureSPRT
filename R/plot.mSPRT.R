#' @export
plot.mSPRT <- function(x){
  if (requireNamespace("ggplot2", quietly = TRUE)) {
    xp <- as.data.frame(x$spr)
    colnames(xp) <- "spr"
    ggplot2::ggplot(xp, ggplot2::aes(y = spr, x = 1:nrow(xp)))+
      ggplot2::geom_line()+
      ggplot2::ylab("Probability Ratio")+
      ggplot2::xlab("Observations Collected")+
      ggplot2::geom_hline(yintercept = x$alpha^(-1))+
      ggplot2::ylim(c(0,max(x$alpha^(-1)+2,max(x$spr))))+
      ggplot2::theme_minimal()+
      ggplot2::labs(title="Mixture Sequential Probability Ratio Test",
                    subtitle = ifelse(x$n.rejection < nrow(xp),
                             paste0("Null Hypothesis Rejected After ",x$n.rejection, " Observations"),
                             paste0("Null Hypothesis Accepted")))  } 
  else {
    ###
  }
 
}