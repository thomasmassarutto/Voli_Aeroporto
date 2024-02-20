# README - Progetto Basi di Dati

Questo repository contiene il codice SQL per il progetto di basi di dati relativo a un sistema di gestione di equipaggi aerei e voli. Di seguito sono fornite istruzioni su come utilizzare il codice e popolare il database.

## Struttura della repo

```
.
└── Voli_Aereoporto
    ├── database
    │   ├── sql
    │   │   ├── final.sql
    │   │   └── ...
    │   └── TABLES   (contiene i file .csv per popolare il database)
    │       └── ...
    ├── grafici_analisi_R
    │   └── ...
    ├── grafici_analisi_ridondanza
    │   └── ...
    ├── markdown  (contiene le bozze .md della relazione)
    │   └── ...
    ├── schemi  (contiene i diagrammi utilizzati nelle bozze della relazione)
    │   └── ...
    ├── Analisi_aeroporto.Rmd
    ├── massarutto_stan_svara.docx
    ├── massarutto_stan_svara.pdf
    └── README.md
```

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
-- scollegarsi dal server
\q
```

## Esecuzione del Codice SQL

Ora puoi eseguire il codice SQL fornito. Puoi eseguire il codice utilizzando gli strumenti di PostgreSQL o importando lo script SQL tramite un'interfaccia grafica o la riga di comando. Il codice si trova nel file `<your/path/to/local/nome_repo>/database/sqls/final.sql`.

Prima di eseguire il codice SQL, assicurati di modificare la variabile `common_path` nella sezione "Popolazione delle tabelle" del file `final.sql`, con il percorso locale corretto.

```bash
psql -U username -d nome_database -a -f esempio/di/path/database/sqls/final.sql
```

## Pulizia del Database

Se è necessario pulire dati, tabelle o funzioni, puoi utilizzare il file `<your/path/to/local/nome_repo>database/sqls/cleanup.sql`.

```bash
psql -U username -d nome_database -a -f esempio/di/path/database/sqls/cleanup.sql
```

## Utilizzo delle Funzioni

Il codice include alcune funzioni che possono essere utili. Puoi utilizzare le seguenti funzioni come esempi per le tue query:

- `Ricerca_Voli_Destinazione(destinazione_desiderata VARCHAR)` | Restituisce l'elenco dei voli che partono in giornata e raggiungono la destinazione specificata.

- `Steward_Aerei_Pesanti(X INT, Y INT)` | Restituisce il numero di steward che lavorano su voli con aerei con peso compreso tra X e Y.

- `Aerei_Di_Linea()` | Restituisce gli aerei con "persone_max" minimo comandati da piloti con età compresa tra 30 e 60 inclusi.

## Procedura di Inserimento

Il codice comprende una procedura per l'inserimento dei voli, la quale offre un'interfaccia intuitiva. La procedura `insert_volo_con_personale()` accetta come argomenti un equipaggio e il suo personale.

Assicurati di eseguire tutte le transazioni necessarie e di impostare i vincoli di chiave esterna su "DEFERRED". Inoltre, verifica di aver inserito una nuova aeromobile che sarà disponibile per essere assegnata al volo appena inserito.

```sql
-- inserire una nuova aeromobile
INSERT INTO AEROMOBILE 
    -- ... ;
START TRANSACTION;
SET CONSTRAINTS fk_hos_equipaggio, fk_stw_equipaggio, fk_plt_equipaggio, fk_volo_equipaggio DEFERRED;
CALL insert_volo_con_personale( 
    -- ... 
);
COMMIT;
```


[//]: # (TODO: Thomas aggiungi qui roba per l'analisi R)
[//]: # (TODO: Thomas, rifai l'ultimo diagramma togliendo la riga sopra il diagramma che parla di carico max, e cambia l'intestazione steward_normali con steward_non_pesanti)