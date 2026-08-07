rm(list=ls())
graphics.off()
setwd("C:/Users/Usuario/Documents/Artigo_Vibe Coding")
#install.packages("bibliometrix")

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

{
  S1 <- convert2df("C:/Users/Usuario/Documents/Artigo_Vibe Coding/scopus.bib", dbsource = "scopus", format = "bibtex")
}

{
  W1 <- convert2df("C:/Users/Usuario/Documents/Artigo_Vibe Coding/wos.bib", dbsource = "wos", format = "bibtex")
}


N <- mergeDbSources(W1, S1, remove.duplicated = TRUE)   # WoS,Scopus, Pubmed, Cochrane
M <- distinct(N,DI, .keep_all= TRUE)


M <- convert2df(
  file = "vibecoding1.csv",
  dbsource = "scopus",
  format = "csv"
)

# Verificar tamanho do corpus
nrow("M")

nrow(M)


risk_terms <- c(
  "risk", "risks",
  "concern", "concerns",
  "challenge", "challenges",
  "limitation", "limitations",
  "ethical", "ethics",
  "bias", "fairness",
  "plagiarism", "cheating", "dishonesty",
  "overreliance", "dependency",
  "cognitive offloading", "automation bias",
  "privacy", "data protection",
  "misuse"
)


M$risk_flag <- grepl(
  pattern = paste(risk_terms, collapse = "|"),
  x = paste(M$TI, M$AB),
  ignore.case = TRUE
)

subcorpus_risk <- M[M$risk_flag == TRUE, ]

# Tamanho esperado: ~120–300 artigos
nrow(subcorpus_risk)

risk_pedagogic <- c(
  "guideline", "curricula","educational setting"
)


subcorpus_risk$risk_flag2 <- grepl(
  pattern = paste(risk_pedagogic, collapse = "|"),
  x = paste(subcorpus_risk$TI, subcorpus_risk$AB),
  ignore.case = TRUE
)

subcorpus_risk_pedagogic <- subcorpus_risk[subcorpus_risk$risk_flag2 == TRUE, ]

nrow(subcorpus_risk_pedagogic)

write.csv(
  subcorpus_risk_ethic,
  file = "riscos_eticos.csv",
  row.names = FALSE
)

# Ver exemplos de títulos selecionados
head(subcorpus_risk$TI, 10)

# Percentual do corpus original
nrow(subcorpus_risk) / nrow(M) * 100


biblioshiny()

rio::export(subcorpus_risk_pedagogic,file = "C:/Users/Usuario/Documents/Artigo_Vibe Coding/riscos_pedagogicos.xlsx")


