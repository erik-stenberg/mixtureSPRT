#' plot.mSPRT
#' 
#' @importFrom ggplot2 ggplot geom_line geom_hline aes labs theme_minimal xlab ylab ylim
#' @importFrom graphics plot
#' @param x An object of class \code{mSPRT}
#' @param ... Further arguments
#' @export

plot.mSPRT <- function(x, ...) {

  if (requireNamespace("ggplot2", quietly = TRUE)) {

    xp <- as.data.frame(x$"spr")
    plot(stats::ts(xp),
         xlab = "Observations Collected",
         ylab = "Probability Ratio")
    abline(h = (x$alpha)^(-1))
    #colnames(xp) <- "spr"
    #ggplot(xp, aes(y = spr, x = 1:nrow(xp)))+
     # geom_line()+
    #  ylab("Probability Ratio")+
    #  xlab("Observations Collected")+
    #  geom_hline(yintercept = x$alpha^(-1))+
    #  ylim(c(0,max(x$alpha^(-1)+2,max(x$spr))))+
    #  theme_minimal()+
    #  labs(title="Mixture Sequential Probability Ratio Test",
    #                subtitle = ifelse(x$n.rejection < nrow(xp),
    #                         paste0("Null Hypothesis Rejected After ",x$n.rejection, " Observations"),
    #                         paste0("Null Hypothesis Accepted"))
    } 
  else {
    print("ggplot2 required for plot")
  }
 
}

