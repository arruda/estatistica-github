# store the current directory
require(Rcmdr)
initial.dir<-getwd()
gh <- read.table("repos_cmt_day_maior.csv",
  header=TRUE, sep=";", na.strings="NA", dec=".", strip.white=TRUE)

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