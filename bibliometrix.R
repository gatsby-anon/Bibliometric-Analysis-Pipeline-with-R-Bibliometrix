rm(list=ls())
graphics.off()
setwd("C:/Users/Usuario/Downloads/tcc")
install.packages("bibliometrix")
install.packages("plyr")
install.packages("dplyr")
install.packages("jsonlite")
install.packages("remotes")


{
  library(plyr)
  library(dplyr)
  library(rlist)
  library(bibliometrix)
  library(openxlsx)
  library(tidyverse)
  library(readr)
  library(stringr)
  library(data.table)
  library(forcats)
  library(ggplot2)
  library(tidyr)
  library(purrr)
}


############### ETAPA 1 - CARREGAMENTO E CONVERSÃO DOS DADOS -- SCOPUS ###############

# SCOPUS: Converter os dados   para o padrão do bibliometrix
{
  SCOPUS <- convert2df("C:/Users/Usuario/Desktop/pipeline artigo/arquivos_originais/scopus.bib", dbsource = "scopus", format = "bibtex")
}


############### ETAPA 2 - REMOÇÃO DE DUPLICADOS -- SCOPUS ###############
SCOPUS_SEMDUPLICATA <- mergeDbSources(SCOPUS, remove.duplicated = TRUE)   # WoS,Scopus, Pubmed, Cochrane
SCOPUS_FINAL <- distinct(SCOPUS_SEMDUPLICATA,DI, .keep_all= TRUE)

############### ETAPA 3 - CARREGAMENTO E CONVERSÃO DOS DADOS -- WOS ###############

# SCOPUS: Converter os dados   para o padrão do bibliometrix
{
  WOS <- convert2df("C:/Users/Usuario/Desktop/pipeline artigo/arquivos_originais/WOS.bib", dbsource = "scopus", format = "bibtex")
}


############### ETAPA 4 - REMOÇÃO DE DUPLICADOS -- WOS ###############
WOS_SEMDUPLICATA <- mergeDbSources(WOS, remove.duplicated = TRUE)   # WoS,Scopus, Pubmed, Cochrane
WOS_FINAL <- distinct(WOS_SEMDUPLICATA,DI, .keep_all= TRUE)


############### ETAPA 5 - JUNTAR BASES DE DADOS ###############

BASES_JUNTAS <- mergeDbSources(SCOPUS_FINAL,WOS_FINAL, remove.duplicated = TRUE)   # WoS,Scopus, Pubmed, Cochrane
ARQUIVO FINAL <- distinct(BASES_JUNTAS,DI, .keep_all= TRUE)


############### ETAPA 6 - CRIAÇÃO DE ARQUIVO .csv ###################  
# P<- M[,c("AU","TI","AB","DE","ID","SO","TC","PY","LA","DT","DI")] # WoS, Scopus
#P<- N[,c("AU","TI","AB","DE","DE","SO","TC","PY","DE","DE","DI")]   # WoS,Scopus, Cochrane, Pubmed
write.table(ARQUIVO FINAL, "C:/Users/Usuario/Desktop/pipeline artigo/artigos_final.csv", sep=";", row.names=FALSE) # Para gerar com separador ";".


############### ETAPA 7 - VISUALIZAÇÃO DOS DADOS ###############

####  Resumo dos resultados na console do RStudio
Resultados <- biblioAnalysis(ARQUIVO FINAL) # BiblioAnalysis - Processamento dos dados.
Resumo <- summary(object = Resultados, k = 10)
plot(Resultados, k=10)   # GrÃ¡ficos com dados bibliomÃ©tricos bÃ¡sicos.


#### Para visualizar os resultados via web-interface (browser)
biblioshiny()

