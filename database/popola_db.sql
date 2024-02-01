COPY EQUIPAGGIO (id_equipaggio)
FROM '/TABLES/EQUIPAGGIO.csv' 
DELIMITER ',' 
CSV HEADER;

COPY STEWARD (codice_fiscale, id_equipaggio)
FROM '/TABLES/STEWARD.csv' 
DELIMITER ',' 
CSV HEADER;

COPY HOSTESS (codice_fiscale, id_equipaggio)
FROM '/TABLES/HOSTESS.csv' 
DELIMITER ',' 
CSV HEADER;

COPY PILOTA (codice_fiscale, id_equipaggio)
FROM '/TABLES/PILOTA.csv' 
DELIMITER ',' 
CSV HEADER;

COPY SPECIFICHE_TECNICHE (peso, lunghezza, apertura_alare)
FROM '/TABLES/SPECIFICHE_TECNICHE.csv' 
DELIMITER ',' 
CSV HEADER;

COPY MODELLO (nome_modello, azienda_costruttrice, carico_max, persone_max, peso, lunghezza, apertura_alare)
FROM '/TABLES/MODELLO.csv' 
DELIMITER ',' 
CSV HEADER;

COPY AEROMOBILE (id_aereo, nome_modello, azienda_costruttrice)
FROM '/TABLES/AEREOMOBILE.csv' 
DELIMITER ',' 
CSV HEADER;

COPY VOLO (gate, ora, destinazione, id_equipaggio, id_aereo)
FROM '/TABLES/VOLO.csv' 
DELIMITER ',' 
CSV HEADER;

