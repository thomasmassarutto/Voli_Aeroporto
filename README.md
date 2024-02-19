# README - Progetto Basi di Dati

Questo repository contiene il codice SQL per il progetto di basi di dati relativo a un sistema di gestione di equipaggi aerei e voli. Di seguito sono fornite istruzioni su come utilizzare il codice e popolare il database.

## Prerequisiti

Assicurati di avere un sistema di gestione di database PostgreSQL installato e configurato. Puoi scaricarlo [qui](https://www.postgresql.org/download/).

## Collegamento al Server PostgreSQL

Per interagire con il database, è necessario connettersi al server PostgreSQL utilizzando per esempio il terminale.
Per connetterti al server utilizza il seguente comando:

```bash
psql -U nome_utente
```

## Creazione del Database

Prima di eseguire il codice SQL, crea un database e accedi a esso. Puoi farlo utilizzando gli strumenti forniti da PostgreSQL o eseguendo i seguenti comandi:

```sql
CREATE DATABASE nome_database;
\c nome_database;
```

## Esecuzione del Codice SQL

Ora puoi eseguire il codice SQL fornito. Puoi eseguire il codice utilizzando gli strumenti di PostgreSQL o importando lo script SQL tramite un'interfaccia grafica o la riga di comando. Il codice si trova nel file `database/sqls/final.sql`.

```bash
psql -U username -d nome_database -a -f database/sqls/final.sql
```

## Popolamento del Database

Prima di eseguire il codice SQL, assicurati di modificare la variabile `common_path` nella sezione "Popolazione delle tabelle" con il percorso locale corretto.

## Pulizia del Database

Se è necessario pulire dati, tabelle o funzioni, puoi utilizzare il file `database/sqls/cleanup.sql`.

```bash
psql -U username -d nome_database -a -f database/sqls/cleanup.sql
```

## Utilizzo delle Funzioni

Il codice include alcune funzioni che possono essere utili. Puoi utilizzare le seguenti funzioni come esempi per le tue query:

- `Ricerca_Voli_Destinazione(destinazione_desiderata VARCHAR)` | Restituisce l'elenco dei voli che partono in giornata e raggiungono la destinazione specificata.

- `Steward_Aerei_Pesanti(X INT, Y INT)` | Restituisce il numero di steward che lavorano su voli con aerei con peso compreso tra X e Y.

- `Aerei_Di_Linea()` | Restituisce gli aerei con "persone_max" minimo comandati da piloti con età compresa tra 30 e 60 inclusi.

## Procedure di Inserimento

Il codice include alcune procedure di inserimento che semplificano l'inserimento di dati nelle tabelle. Assicurati di eseguire le transazioni necessarie e di impostare i vincoli di chiave esterna a "DEFERRED", come nel seguente esempio:

```sql
START TRANSACTION;
SET CONSTRAINTS fk_plt_equipaggio DEFERRED;
-- inserimento nelle tabelle
COMMIT;
```

[//]: # (TODO: Thomas aggiungi qui roba per l'analisi R)