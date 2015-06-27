

allShapiro <- function(data.frame)
{
    df <- data.frame
    # filename <- paste("shapiro_test/", prefix, '_', 'all.txt', sep='')
    # sink(filename, append=FALSE, split=FALSE)
        do.call(rbind, lapply(df, function(x) if(is.numeric(x)){
            tryCatch({
                shapiro.test(x)[c("statistic", "p.value")]
                },
                error = function(err){
                    print(err)

            })
        }))
    # sink()

}




correlacoes <-function(data.frame, prefix){
    df <- data.frame
    pre_filename <- paste("correlacoes/", prefix, '_', sep='')



    png(paste(pre_filename, "stars_vs_has_wiki.png", sep=''))
    Boxplot(Stars~Has.Wiki, data=df, id.method="y")
    dev.off()

    png(paste(pre_filename, "cmtsSab_vs_mtsDom.png", sep=''))
    scatterplot(Num..Cmts..Sab~Num..Cmts..Dom, reg.line=lm, smooth=TRUE,
      spread=TRUE, id.method='mahal', id.n = 2, boxplots=FALSE, span=0.5, data=df)
    dev.off()

    png(paste(pre_filename, "todosCmtsSemana.png", sep=''), width=1024, height=1024)
    scatterplotMatrix(~Num..Cmts..Dom+Num..Cmts..Qua+Num..Cmts..Qui+Num..Cmts..Sab+Num..Cmts..Seg+Num..Cmts..Sex+Num..Cmts..Ter,
       reg.line=lm, smooth=TRUE, spread=FALSE, span=0.5, id.n=0, diagonal =
      'density', data=df)
    dev.off()

    png(paste(pre_filename, "cmtsDiasUteis.png", sep=''), width=1024, height=1024)
    scatterplotMatrix(~Num..Cmts..Qua+Num..Cmts..Qui+Num..Cmts..Seg+Num..Cmts..Sex+Num..Cmts..Ter,
       reg.line=lm, smooth=TRUE, spread=FALSE, span=0.5, id.n=0, diagonal =
      'density', data=df)
    dev.off()


    png(paste(pre_filename, "TotalCmts_vs_OwnerType.png", sep=''))
    with(df, Hist(Total.Commits, groups=Owner.Type, scale="percent",
      breaks="Sturges", col="darkgray"))
    dev.off()

}


dfplot <- function(data.frame, prefix)
{
  df <- data.frame
  ln <- length(names(data.frame))
  for(i in 1:ln){
    mname <- substitute(df[,i])
    filename <- paste("histograms/", prefix, '_', names(df)[i], '.png', sep='')

    # se for a variavel Language, então muda o tamanho da tela, caso contrario deixa normal
    if(names(df)[i] == "Language"){
        png(filename, width=3050)
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



porcentagens <- function(data.frame, prefix)
{
    df <- data.frame
    filename <- paste("porcentagens/", prefix, '_', 'qualitativas.txt', sep='')

    sink(filename, append=FALSE, split=FALSE)
    local({
      .Table <- with(df, table(Owner.Type))
      cat("\ncounts:\n")
      print(.Table)
      cat("\npercentages:\n")
      print(round(100*.Table/sum(.Table), 2))
    })
    local({
      .Table <- with(df, table(Has.Wiki))
      cat("\ncounts:\n")
      print(.Table)
      cat("\npercentages:\n")
      print(round(100*.Table/sum(.Table), 2))
    })


    local({
      .Table <- with(df, table(Language))
      cat("\ncounts:\n")
      print(.Table)
      cat("\npercentages:\n")
      print(round(100*.Table/sum(.Table), 2))
    })

    print("Matriz de Correlação entre dias da semana")
    print(cor(df[,c("Num..Cmts..Dom","Num..Cmts..Qua","Num..Cmts..Qui",
      "Num..Cmts..Sab","Num..Cmts..Seg","Num..Cmts..Sex","Num..Cmts..Ter")],
      use="complete"))
    sink()
}

analise_fat <-function(data.frame, prefix){
    df <- data.frame
    pre_filename <- paste("analise_fat/", prefix, '_', 'num_commmits.txt', sep='')
    sink(pre_filename, append=FALSE, split=FALSE)

    local({
      .FA <-
      factanal(~Num..Cmts..Dom+Num..Cmts..Qua+Num..Cmts..Qui+Num..Cmts..Sab+Num..Cmts..Seg+Num..Cmts..Sex+Num..Cmts..Ter,
       factors=2, rotation="varimax", scores="regression", data=df)
      print(.FA)
      df <<- within(df, {
        Num.Comts.Finais.Semana <- .FA$scores[,2]
        Num.Comts.Dias.Uteis <- .FA$scores[,1]
      })
    })
    sink()
    return(df)
}




media_cmts_final_semana <-function(data.frame){
    df <- data.frame
    return(with(df, mean(Num..Cmts..Dom + Num..Cmts..Sab)))
}

media_cmts_dias_uteis <-function(data.frame){
    df <- data.frame

    res <- with(df,
        mean(Num..Cmts..Seg + Num..Cmts..Ter +
            Num..Cmts..Qua + Num..Cmts..Qui + Num..Cmts..Sex
        )
    )

    return(res)
}