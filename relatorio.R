# store the current directory
require(Rcmdr)
initial.dir<-getwd()
gh <- read.table("repos_cmt_day_maior.csv",
  header=TRUE, sep=";", na.strings="NA", dec=".", strip.white=TRUE)


dfplot <- function(data.frame)
{
  df <- data.frame
  ln <- length(names(data.frame))
  for(i in 1:ln){
    mname <- substitute(df[,i])
    filename <- paste("histograms/", names(df)[i], '.png', sep='')
    png(filename)
    if(is.factor(df[,i])){
        plot(df[,i],main=names(df)[i])
    }
    else{
        hist(df[,i],main=names(df)[i], scale="frequency", breaks="Sturges", col="darkgray")
    }
    dev.off()
  }
}

dfplot(gh)

# shapiro test
sink("shapiro_test/all.txt", append=FALSE, split=FALSE)
do.call(rbind, lapply(gh, function(x) if(is.numeric(x)){
    shapiro.test(x)[c("statistic", "p.value")]
}))
sink()