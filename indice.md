1. Analisi dei requisti
   1.1 Sintesi del testo ............................ 1
   1.2 Glossario ................................... 2
   1.3 Specifiche sui dati ........................ 3
   1.4 Specifiche sulle operazioni ............... 4
2. Progettazione concettuale
   2.1 Schema Entità-Relazioni
   2.1.1 Prima revisione ..................... 5
   2.1.2 Schema ER ............................ 6
   2.1.3 Tabella di cardinalità delle relazioni 7
   2.2 Documentazione schema ER
   2.2.1 Dizionario dei dati .................. 8
   2.2.2 Regole di vincolo .................... 9
   2.2.3 Regole di derivazione ............... 10
3. Progettazione Logica
   3.1 Operazioni ............................... 11
   3.2 Ristrutturazione dello schema ER
   3.2.1 Tabelle dei volumi .................. 12
   3.2.2 Tabelle delle frequenze .............. 13
   3.2.3 Analisi ridondanza ................... 14
   3.2.4 Ristrutturazione ..................... 15
   3.3 Traduzione verso il relazionale
   3.3.1 Modello relazionale .................. 16
   3.3.2 Vincoli di dominio ................... 17
   3.3.3 Vincoli d'integrita' ................. 18
   3.3.4 Diagramma dei vincoli d'integrità referenziale 19
4. Progettazione Fisica
   4.1 Analisi Indici ............................ 20
   4.2 Implementazione in SQL .................... 21
5. Implementazione
   5.1 Vincoli di integrita con trigger e check
   5.1.1 Vincoli di Dominio .................... 22
   5.1.2 Triggers e Vincoli di Relazione ....... 23
   5.1.3 Procedura di Inserimento .............. 24
   5.2 Operazioni del Database - Query
   5.2.1 Ricerca dei voli per destinazione ..... 25
   5.2.2 Numero di steward su voli con aerei di peso specifico 26
   5.2.3 Aerei di linea comandati da piloti di età specifica 27
   5.3 Popolazione database ...................... 28
6. Analisi con linguaggio R
   6.1 Connessione con libreria RPostgres ........ 29
   6.1 Analisi età media personale ............... 30
   6.1 Analisi steward ............................ 31