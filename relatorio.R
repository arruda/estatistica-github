
require(Rcmdr)
source('utils.R')

gh <- read.table("repos_cmt_day_maior_age.csv",
  header=TRUE, sep=";", na.strings="NA", dec=".", strip.white=TRUE)

attach(gh)
gh_users <-  gh[which(Owner.Type=='User'),]
gh_org <-  gh[which(Owner.Type=='Organization'),]
detach(gh)

# 134 organizacoes
# 167 users

attach(gh_users)
gh_users_sample <- gh_users[sample(1:nrow(gh_users), 167, replace=FALSE),]
detach(gh_users)

attach(gh_org)
gh_org_sample <- gh_org[sample(1:nrow(gh_org), 134, replace=FALSE),]
detach(gh_org)

gh_sample_final <- mergeRows(gh_users_sample, gh_org_sample, common.only=FALSE)

## hist e plots
dfplot(gh, 'total')
dfplot(gh_users_sample, 'user')
dfplot(gh_org_sample, 'org')
dfplot(gh_sample_final, 'final')

### shapiro test

## total
filename <- paste("shapiro_test/", 'total', '_', 'all.txt', sep='')
sink(filename, append=FALSE, split=FALSE)
    allShapiro(gh)
sink()

# user
filename <- paste("shapiro_test/", 'user', '_', 'all.txt', sep='')
sink(filename, append=FALSE, split=FALSE)
    allShapiro(gh_users_sample)
sink()

# Organization
filename <- paste("shapiro_test/", 'org', '_', 'all.txt', sep='')
sink(filename, append=FALSE, split=FALSE)
    allShapiro(gh_org_sample)
sink()

# final
filename <- paste("shapiro_test/", 'final', '_', 'all.txt', sep='')
sink(filename, append=FALSE, split=FALSE)
    allShapiro(gh_sample_final)
sink()

# Infos sobre Porcentagens das Qualitativas:

sink("porcentagens_qualitativas.txt", append=FALSE, split=FALSE)
local({
  .Table <- with(gh, table(Owner.Type))
  cat("\ncounts:\n")
  print(.Table)
  cat("\npercentages:\n")
  print(round(100*.Table/sum(.Table), 2))
})
local({
  .Table <- with(gh, table(Has.Wiki))
  cat("\ncounts:\n")
  print(.Table)
  cat("\npercentages:\n")
  print(round(100*.Table/sum(.Table), 2))
})


local({
  .Table <- with(gh, table(Language))
  cat("\ncounts:\n")
  print(.Table)
  cat("\npercentages:\n")
  print(round(100*.Table/sum(.Table), 2))
})
sink()

# Correlacoes
correlacoes(gh, 'total')
correlacoes(gh_users_sample, 'user')
correlacoes(gh_org_sample, 'org')
correlacoes(gh_sample_final, 'final')


