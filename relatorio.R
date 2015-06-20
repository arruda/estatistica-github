
library(FactoMineR)
require(Rcmdr)
source('utils.R')

gh <- read.table("repos_cmt_day_maior_age.csv",
  header=TRUE, sep=";", na.strings="NA", dec=".", strip.white=TRUE)

#remove dupls!
gh <- gh[!duplicated(gh$Name),]
# vars qualitativas
gh <- within(gh, {
  Created.at..Day. <- as.factor(Created.at..Day.)
  Created.at..Month. <- as.factor(Created.at..Month.)
  Created.at..Year. <- as.factor(Created.at..Year.)
  Last.Updated.at..Day. <- as.factor(Last.Updated.at..Day.)
  Last.Updated.at..Month. <- as.factor(Last.Updated.at..Month.)
  Last.Updated.at..Year. <- as.factor(Last.Updated.at..Year.)
})

# write.csv2(gh, file = "limpo.csv", row.names=FALSE, fileEncoding = "UTF-8")
attach(gh)
gh_users <-  gh[which(Owner.Type=='User'),]
gh_org <-  gh[which(Owner.Type=='Organization'),]
detach(gh)

## hist e plots
dfplot(gh, 'total')
dfplot(gh_users, 'user')
dfplot(gh_org, 'org')

png(paste('correlacoes/', "total_cmts_created_year.png", sep=''))
Boxplot(Total.Commits~Created.at..Year., data=gh, id.method="y")
dev.off()
### shapiro test

## total
filename <- paste("shapiro_test/", 'total', '_', 'all.txt', sep='')
sink(filename, append=FALSE, split=FALSE)
    allShapiro(gh)
sink()

# user
filename <- paste("shapiro_test/", 'user', '_', 'all.txt', sep='')
sink(filename, append=FALSE, split=FALSE)
#     allShapiro(gh_users)
sink()

# Organization
filename <- paste("shapiro_test/", 'org', '_', 'all.txt', sep='')
sink(filename, append=FALSE, split=FALSE)
    allShapiro(gh_org)
sink()

# Infos sobre Porcentagens das Qualitativas:
porcentagens(gh, 'total')
porcentagens(gh_users, 'user')
porcentagens(gh_org, 'org')

# Correlacoes
correlacoes(gh, 'total')
correlacoes(gh_users, 'user')
correlacoes(gh_org, 'org')




# Analise fatorial

gh <- analise_fat(gh, 'total')
gh_users <- analise_fat(gh_users, 'user')
gh_org <- analise_fat(gh_org, 'org')


# gh.PCA<-gh[, c("Num..Cmts..Dom", "Num..Cmts..Seg", "Num..Cmts..Ter",
#   "Num..Cmts..Qua", "Num..Cmts..Qui", "Num..Cmts..Sex", "Num..Cmts..Sab")]
# res<-PCA(gh.PCA , scale.unit=TRUE, ncp=5, graph = FALSE)

# png(paste('total', "analies_fat_cmts_ind.png", sep=''))
# plot.PCA(res, axes=c(1, 2), choix="ind", habillage="none", col.ind="black",
#   col.ind.sup="blue", col.quali="magenta", label=c("ind", "ind.sup", "quali"),
#   new.plot=TRUE)
# dev.off()

# png(paste('total', "analise_fat_cmts_var.png", sep=''))
# plot.PCA(res, axes=c(1, 2), choix="var", new.plot=TRUE, col.var="black",
#   col.quanti.sup="blue", label=c("var", "quanti.sup"), lim.cos2.var=0)
# dev.off()
# summary(res, nb.dec = 3, nbelements=10, nbind = 10, ncp = 3, file="")


gh.PCA<-gh[, c("Num..Cmts..Dom", "Num..Cmts..Seg", "Num..Cmts..Ter", "Num..Cmts..Qua",
  "Num..Cmts..Qui", "Num..Cmts..Sex", "Num..Cmts..Sab")]
res<-PCA(gh.PCA , scale.unit=TRUE, ncp=5, graph = FALSE)
res.hcpc<-HCPC(res ,nb.clust=-1,consol=TRUE,min=15,max=15,graph=TRUE)
plot.PCA(res, axes=c(1, 2), choix="ind", habillage="none", col.ind="black", col.ind.sup="blue",
  col.quali="magenta", label=c("ind", "ind.sup", "quali"),new.plot=TRUE)
plot.PCA(res, axes=c(1, 2), choix="var", new.plot=TRUE, col.var="black", col.quanti.sup="blue",
  label=c("var", "quanti.sup"), lim.cos2.var=0)

gh <- within(gh, {clusters_cmts <- dd$clust}




#lixo
# gh.PCA<-gh[, c("Num..Cmts..Dom", "Num..Cmts..Seg", "Num..Cmts..Ter",
#   "Num..Cmts..Qua", "Num..Cmts..Qui", "Num..Cmts..Sex", "Num..Cmts..Sab",
#   "Owner.Type")]
# res<-PCA(gh.PCA , scale.unit=TRUE, ncp=5, quali.sup=c(8: 8), graph = FALSE)
# res.hcpc<-HCPC(res ,nb.clust=-1,consol=TRUE,min=15,max=15,graph=TRUE)
# plot.PCA(res, axes=c(1, 2), choix="ind", habillage="none", col.ind="black",
#   col.ind.sup="blue", col.quali="magenta", label=c("ind.sup", "quali"),new.plot=TRUE,
#   title="")
# plot.PCA(res, axes=c(1, 2), choix="var", new.plot=TRUE, col.var="black",
#   col.quanti.sup="blue", label=c("var", "quanti.sup"), lim.cos2.var=0, title="")
# summary(res, nb.dec = 3, nbelements=10, nbind = 10, ncp = 3, file="")
# remove(gh.PCA)



# gh.MCA<-gh[, c("Created.at..Year.", "Language")]
# res<-MCA(gh.MCA, ncp=5, graph = FALSE)
# plot.MCA(res, axes=c(2, 3), new.plot=TRUE, col.ind="black", col.ind.sup="blue",
#   col.var="darkred", col.quali.sup="darkgreen", label=c("ind.sup", "quali.sup",
#   "var"), invisible=c("ind"), title="", xlim=c(-5, 5), ylim=c(-3, 3))
# plot.MCA(res, axes=c(2, 3), new.plot=TRUE, choix="var", col.var="darkred",
#   col.quali.sup="darkgreen", label=c("quali.sup", "var"), title="")
# plot.MCA(res, axes=c(2, 3), new.plot=TRUE, choix="quanti.sup",
#   col.quanti.sup="blue", label=c("quanti.sup"), title="")
# summary(res, nb.dec = 3, nbelements=10, nbind = 10, ncp = 3, file="")




# #outra opt de quali x quali

# gh.MCA<-gh[, c("Created.at..Year.", "Language")]
# res<-MCA(gh.MCA, ncp=5, graph = FALSE)
# plot.MCA(res, axes=c(1, 2), new.plot=TRUE, col.ind="black", col.ind.sup="blue",
#   col.var="darkred", col.quali.sup="darkgreen", label=c("ind.sup", "quali.sup",
#   "var"), invisible=c("ind"), title="", xlim=c(-3, 3), ylim=c(-2, 2))
# plot.MCA(res, axes=c(1, 2), new.plot=TRUE, choix="var", col.var="darkred",
#   col.quali.sup="darkgreen", label=c("quali.sup", "var"), title="")
# plot.MCA(res, axes=c(1, 2), new.plot=TRUE, choix="quanti.sup",
#   col.quanti.sup="blue", label=c("quanti.sup"), title="")
# summary(res, nb.dec = 3, nbelements=10, nbind = 10, ncp = 3, file="")
# remove(gh.MCA)


