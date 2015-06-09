
require(Rcmdr)
source('utils.R')

gh <- read.table("repos_cmt_day_maior_age.csv",
  header=TRUE, sep=";", na.strings="NA", dec=".", strip.white=TRUE)

#remove dupls!
gh <- gh[!duplicated(gh$Name),]

# write.csv2(gh, file = "limpo.csv", row.names=FALSE, fileEncoding = "UTF-8")
attach(gh)
gh_users <-  gh[which(Owner.Type=='User'),]
gh_org <-  gh[which(Owner.Type=='Organization'),]
detach(gh)

## hist e plots
dfplot(gh, 'total')
dfplot(gh_users, 'user')
dfplot(gh_org, 'org')

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

require(FactoMineR)
gh.PCA<-gh[, c("Num..Cmts..Dom", "Num..Cmts..Seg", "Num..Cmts..Ter",
  "Num..Cmts..Qua", "Num..Cmts..Qui", "Num..Cmts..Sex", "Num..Cmts..Sab")]
res<-PCA(gh.PCA , scale.unit=TRUE, ncp=5, graph = FALSE)

png(paste('total', "analies_fat_cmts_ind.png", sep=''))
plot.PCA(res, axes=c(1, 2), choix="ind", habillage="none", col.ind="black",
  col.ind.sup="blue", col.quali="magenta", label=c("ind", "ind.sup", "quali"),
  new.plot=TRUE)
dev.off()

png(paste('total', "analise_fat_cmts_var.png", sep=''))
plot.PCA(res, axes=c(1, 2), choix="var", new.plot=TRUE, col.var="black",
  col.quanti.sup="blue", label=c("var", "quanti.sup"), lim.cos2.var=0)
dev.off()
summary(res, nb.dec = 3, nbelements=10, nbind = 10, ncp = 3, file="")
