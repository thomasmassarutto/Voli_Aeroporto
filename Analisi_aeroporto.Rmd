---
title: "Analisi_aeroporto"
author: "Thomas Massarutto"
date: "2024-02-12"
output: pdf_document
---

```{r setup, include=FALSE, echo=FALSE}
knitr::opts_chunk$set(echo = TRUE)

library(RPostgres)
library(ggplot2)
library(tidyverse)
```

```{r inizializza_postgresSQL, include=TRUE, echo=FALSE}
db_name = "Aereoporto"
db_user = "postgres"
db_password = "thomas"
db_host = "localhost"
db_port = 5432
db_driver = dbDriver("Postgres")

con = dbConnect( db_driver,
                  dbname = db_name,
                  user = db_user,
                  password = db_password,
                  host = db_host,
                  port = db_port
)
```

```{r funzioni_utility, include=FALSE, echo=FALSE}
## Data una stringa valida come codice fiscale, ritorna l'eta della persona
## Le poersone devono avere meno di 100 anni
eta_codice_fiscale <- function(cf) {
  
  eta= NA
  
  codice_fiscale = cf
  anno_corrente =  year(Sys.Date())
  
  ## Valore soglia per calcolare l'eta
  base = 2000
  threshold = anno_corrente - base
  
  ## Sottostringa che contiene data di nascita
  data_nascita = substr(codice_fiscale, 7, 12)
  ## Anno di nascita
  anno_nascita <- as.numeric(substr(data_nascita, 1, 2))
  
  ## Threshold
  if (anno_nascita > threshold){
    anno_nascita = (base - 100) + anno_nascita
  } else{
    anno_nascita= base + anno_nascita
  }
  
  eta= anno_corrente - anno_nascita
  
  return(eta)
}

## dato il nome di una tabella crea il dataframe corrispondente
## necessita di connessione aperta
create_df <- function(nome_tabella){
  
  query = paste("SELECT * FROM", nome_tabella, sep = " ")
  result = dbGetQuery(con, query)
  df= data.frame(result)
  
  return (df)
}
```


```{r wrapper_query, include=FALSE, echo=FALSE}
##
## WRAPPING QUERY DB!
## 
## Interfaccia che si assicura una corretta comunicazione con il db
##
## PRECONDIZIOINI: 
## connessione a db gia presente in var: con
## le funzioni devono essere implementate sul db
## POSTCONDIZIONI
## la veriabile query deve sempre essere azzerata con NA

query = NA

## Return: numeric
nr_Steward_Aerei_Pesanti <- function(min, max){
  
  query = paste("SELECT Steward_Aerei_Pesanti(", min, ", ", max, ")")
  nr_Steward_Aerei_Pesanti <- dbGetQuery(con, query)
  query = NA
  return(as.numeric(nr_Steward_Aerei_Pesanti))
}
```

```{r eta_media_steward_hostess_pilota, echo=FALSE}
## Generazione df
df_hostess = create_df("hostess")
df_steward = create_df("steward")
df_pilota = create_df("pilota")

## Creazione colonna eta
df_hostess$eta= sapply(df_hostess$codice_fiscale, eta_codice_fiscale)
df_steward$eta= sapply(df_steward$codice_fiscale, eta_codice_fiscale)


ggplot() +
  ## Hostess
  geom_boxplot(data = df_hostess, 
               aes(x = "Hostess", 
                   y = eta,
                   fill = "Hostess")) +
  ## Steward
  geom_boxplot(data = df_steward, 
               aes(x = "Steward", 
                   y = eta, 
                   fill = "Steward")) +
  ## Pilota
    geom_boxplot(data = df_pilota, 
               aes(x = "Piloti", 
                   y = eta, 
                   fill = "Pilota")) +
  ## Aggiungi i punti di media
    stat_summary(data = df_hostess, 
               aes(x = "Hostess", 
                   y = eta), 
               fun = mean, 
               geom = "point", 
               color = "black", 
               size = 3) +
      stat_summary(data = df_steward, 
               aes(x = "Steward", 
                   y = eta), 
               fun = mean, 
               geom = "point", 
               color = "black", 
               size = 3) +
      stat_summary(data = df_pilota, 
               aes(x = "Piloti", 
                   y = eta), 
               fun = mean, 
               geom = "point", 
               color = "black", 
               size = 3) +
  
  
  ## Etichette
  labs(title = "Età media del personale imbarcato", fill= "Personale", x="", y="Età")

eta_media_hostess= mean(df_hostess$eta)
eta_media_steward= mean(df_steward$eta)
eta_media_piloti= mean(df_pilota$eta)

```



```{r steward_aerei_pesanti, echo=FALSE}

peso_min = 150000L
peso_max = 250000L

tot_steward= nrow(df_steward)
steward_aerei_pesanti= (nr_Steward_Aerei_Pesanti(peso_min,peso_max))/tot_steward


## Calcola la proporzione
proporzioni <- c(1-steward_aerei_pesanti, steward_aerei_pesanti)

## Crea un data frame con le proporzioni
df_proporzioni <- data.frame(categoria = c("steward_normali", "steward_aerei_pesanti"), proporzione = proporzioni)


## Piechart
ggplot( data= df_proporzioni, 
        aes(x = "", 
            y = proporzione, 
            fill = categoria)) +
  geom_bar(stat = "identity", 
           width = 1) +
  coord_polar("y", 
              start = 0) +
  geom_text(aes(label = sprintf("%.1f%%", proporzione * 100)),
            position = position_stack(vjust = 0.5))+## centra la visualizzazione delle percentuali
    ## Etichette
  labs(title = paste("Proporzione steward imbarcati su voli con carico max (", peso_min, "," , peso_max, ")"), 
       fill= "Personale", x="", y="")

```