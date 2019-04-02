#' S3 methods 

##################
#### Printing ####
##################

print.mSPRT <- function(x,...){
  cat("Decision: ", x$decision,"\n")
  cat(x$text)
}


##################
###### Plot ######
##################

plot.mSPRT <- function(x){
  library(ggplot2)
  xp <- as.data.frame(x$spr)
  colnames(xp) <- "spr"
  ggplot(xp, aes(y = spr, x = 1:nrow(xp)))+
    geom_line()+
    ylab("Probability Ratio")+
    xlab("Observations Collected")+
    geom_hline(yintercept = x$alpha^(-1))+
    ylim(c(0,max(x$alpha^(-1)+2,max(x$spr))))+
    theme_minimal()+
    labs(title="Mixture Sequential Probability Ratio Test",
         subtitle = ifelse(x$n.rejection < nrow(xp),
                           paste0("Null Hypothesis Rejected After ",x$n.rejection, " Observations"),
                           paste0("Null Hypothesis Accepted")))
}