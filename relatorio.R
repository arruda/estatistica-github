# store the current directory
require(Rcmdr)
initial.dir<-getwd()
gh <- read.table("repos_cmt_day_maior.csv",
  header=TRUE, sep=";", na.strings="NA", dec=".", strip.white=TRUE)



# lapply(colnames(gh), function(x) if(is.numeric(x)){
#     fname <- paste("histograms/",x,".png", sep="")
# })

# lapply(colnames(gh), function(x) if(is.numeric(x)){
#     fname <- paste("histograms/",x,".png", sep="")
#     png(fname)
#     with(gh, Hist(x, scale="frequency", breaks="Sturges", col="darkgray"))
# })

png("histograms/Forks.png")
with(gh, Hist(Forks, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()

png("histograms/Num..Cmts..Dom.png")
with(gh, Hist(Num..Cmts..Dom, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()


png("histograms/Num..Cmts..Seg.png")
with(gh, Hist(Num..Cmts..Seg, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()


png("histograms/Num..Cmts..Ter.png")
with(gh, Hist(Num..Cmts..Ter, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()

png("histograms/Num..Cmts..Qua.png")
with(gh, Hist(Num..Cmts..Qua, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()

png("histograms/Num..Cmts..Qui.png")
with(gh, Hist(Num..Cmts..Qui, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()

png("histograms/Num..Cmts..Sex.png")
with(gh, Hist(Num..Cmts..Sex, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()

png("histograms/Num..Cmts..Sab.png")
with(gh, Hist(Num..Cmts..Sab, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()

png("histograms/Total.Commits.png")
with(gh, Hist(Total.Commits, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()

png("histograms/Size.png")
with(gh, Hist(Size, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()

png("histograms/Stars.png")
with(gh, Hist(Stars, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()


png("histograms/Watchers.png")
with(gh, Hist(Watchers, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()

png("histograms/Open.Issues.png")
with(gh, Hist(Open.Issues, scale="frequency", breaks="Sturges", col="darkgray"))
dev.off()


# shapiro test

sink("shapiro_test/all.txt", append=FALSE, split=FALSE)
sapply(gh, function(x) with(gh, shapiro.test(x)))
sink()
