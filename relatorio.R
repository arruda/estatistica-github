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

    # se for a variavel Language, então muda o tamanho da tela, caso contrario deixa normal
    if(names(df)[i] == "Language"){
        png(filename, width=2050)
    }
    else{
        png(filename)
    }

    if(is.factor(df[,i])){
        plot(df[,i],main=names(df)[i])
    }
    else{
        Hist(df[,i],main=names(df)[i], scale="frequency", breaks="Sturges", col="darkgray", xlab=names(df)[i])
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
sink()

# Correlacoes


png("correlacoes/stars_vs_has_wiki.png")
Boxplot(Stars~Has.Wiki, data=gh, id.method="y")
dev.off()

png("correlacoes/stars_vs_Watchers.png")
scatterplot(Watchers~Stars, reg.line=lm, smooth=FALSE, spread=TRUE, id.method='mahal', id.n = 2,
   boxplots=FALSE, span=0.5, data=gh)
dev.off()

png("correlacoes/cmtsSab_vs_mtsDom.png")
scatterplot(Num..Cmts..Sab~Num..Cmts..Dom, reg.line=lm, smooth=TRUE,
  spread=TRUE, id.method='mahal', id.n = 2, boxplots=FALSE, span=0.5, data=gh)
dev.off()

png("correlacoes/todosCmtsSemana.png", width=1024, height=1024)
scatterplotMatrix(~Num..Cmts..Dom+Num..Cmts..Qua+Num..Cmts..Qui+Num..Cmts..Sab+Num..Cmts..Seg+Num..Cmts..Sex+Num..Cmts..Ter,
   reg.line=lm, smooth=TRUE, spread=FALSE, span=0.5, id.n=0, diagonal =
  'density', data=gh)
dev.off()

png("correlacoes/TotalCmts_vs_OwnerType.png")
with(gh, Hist(Total.Commits, groups=Owner.Type, scale="percent",
  breaks="Sturges", col="darkgray"))
dev.off()


