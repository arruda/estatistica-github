
require(Rcmdr)
source('utils.R')

gh <- read.table("repos_cmt_day_maior_age.csv",
  header=TRUE, sep=";", na.strings="NA", dec=".", strip.white=TRUE)

#remove dupls!
gh <- gh[!duplicated(gh$Name),]

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
    allShapiro(gh_users)
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


