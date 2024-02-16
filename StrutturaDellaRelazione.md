# RELAZIONE BASE DI DATI - AEROPORTO

1. Analisi dei requisti
    1. [x] 1.1 Sintesi del testo
    2. [x] 1.2 Glossario
    3. [x] 1.3 Specifiche sui dati
    4. [x] 1.4 Specifiche sulle operazioni

2. Progettazione concettuale
    1. [x] 2.1 Schema ER
        1. [x] 2.1.1 Prima revisione Schema ER
        2. [x] 2.1.2 Schema ER Finale
        3. [x] 2.1.3 Tabella delle cardinalità
    2. [x] 2.2 Documentazione schema ER
        1. [x] 2.2.1 Dizionario dei dati
        2. [x] 2.2.2 Regole di vincolo 
        3. [x] 2.2.3 Regole di derivazione 

3. Progettazione Logica
    1. [x] 3.1 Operazioni
    2. [x] 3.2 Ristrutturazione dello schema ER
        1. [X] 3.2.1 Tabelle dei volumi
        2. [X] 3.2.2 Tabelle delle frequenze
        3. [x] 3.2.3 Analisi ridondanza 
        4. [x] 3.2.4 Ristrutturazione schema ER
    3. [X] 3.3 Traduzione verso il relazionale
        1. [X] 3.3.1 Modello relazionale    
        2. [x] 3.3.2 Vincoli di dominio
        3. [x] 3.3.3 Vincoli d'integrita'
        4. [x] 3.3.4 Diagramma dei vincoli d'integrità referenziale

4. Progettazione Fisica
    1. [ ] 4.1 Analisi Indici
    2. [ ] 4.2 Implementazioni file sql
       1. [ ] 4.2.1 creazione database
       2. [ ] 4.2.2 creazione tabelle
       3. [ ] 4.2.3 creazione indici

5. Implementazione
    1. [ ] 5.1 Trigger / check
    2. [ ] 5.2 Query
    3. [ ] 5.3 Popolazione database

6. Analisi con linguaggio R
    1. [x] 6.1 Connessione con libreria RPostgres
    2. [x] 6.1 Analisi età media personale
    3. [x] 6.1 Analisi steward


### Proposta

Progettazione Fisica:
1. Scelta del DBMS: Selezionare il sistema di gestione di database (DBMS) che meglio si adatta ai requisiti del progetto (es. MySQL, PostgreSQL, SQL Server).
2. Definizione degli Indici: Identificare e creare gli indici necessari per ottimizzare le prestazioni delle query.
3. Tuning delle Prestazioni: Ottimizzare la progettazione del database per migliorare le prestazioni, considerando ad esempio l'uso di partizionamento delle tabelle o di caching.

Implementazione:
1. Creazione del Database: Tradurre lo schema relazionale nella struttura fisica del database utilizzando il DBMS selezionato.
2. Caricamento dei Dati: Popolare le tabelle del database con i dati iniziali.
3. Test del Database: Verificare la corretta implementazione del database eseguendo test, query di verifica e assicurandosi che risponda agli scopi previsti.

Analisi con Linguaggio R:
1. Analisi dei Dati: Utilizzare il linguaggio R per eseguire analisi sui dati presenti nel database, potrebbe includere l'uso di librerie specializzate per l'analisi statistica o la creazione di visualizzazioni dei dati.
