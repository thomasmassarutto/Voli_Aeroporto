-- Elimino i dati delle tabelle
DELETE FROM VOLO WHERE TRUE;
DELETE FROM HOSTESS WHERE TRUE;
DELETE FROM STEWARD WHERE TRUE;
DELETE FROM PILOTA WHERE TRUE;
DELETE FROM EQUIPAGGIO WHERE TRUE;
DELETE FROM AEROMOBILE WHERE TRUE;
DELETE FROM MODELLO WHERE TRUE;
DELETE FROM SPECIFICHE_TECNICHE WHERE TRUE;

-- Popolo le tabelle con i csv
DO $$
    DECLARE
        common_path TEXT := '<la/tua/path>/Voli_aeroporto/database/TABLES/';
    BEGIN
        EXECUTE 'COPY EQUIPAGGIO (id_equipaggio) FROM ' || quote_literal(common_path || 'EQUIPAGGIO.csv') || ' DELIMITER '','' CSV HEADER;';
        EXECUTE 'COPY STEWARD (codice_fiscale, id_equipaggio) FROM ' || quote_literal(common_path || 'STEWARD.csv') || ' DELIMITER '','' CSV HEADER;';
        EXECUTE 'COPY HOSTESS (codice_fiscale, id_equipaggio) FROM ' || quote_literal(common_path || 'HOSTESS.csv') || ' DELIMITER '','' CSV HEADER;';
        EXECUTE 'COPY PILOTA (codice_fiscale, id_equipaggio) FROM ' || quote_literal(common_path || 'PILOTA.csv') || ' DELIMITER '','' CSV HEADER;';
        EXECUTE 'COPY SPECIFICHE_TECNICHE (peso, lunghezza, apertura_alare) FROM ' || quote_literal(common_path || 'SPECIFICHE_TECNICHE.csv') || ' DELIMITER '','' CSV HEADER;';
        EXECUTE 'COPY MODELLO (nome_modello, azienda_costruttrice, carico_max, persone_max, peso, lunghezza, apertura_alare) FROM ' || quote_literal(common_path || 'MODELLO.csv') || ' DELIMITER '','' CSV HEADER;';
        EXECUTE 'COPY AEROMOBILE (id_aereo, nome_modello, azienda_costruttrice) FROM ' || quote_literal(common_path || 'AEROMOBILE.csv') || ' DELIMITER '','' CSV HEADER;';
        EXECUTE 'COPY VOLO (gate, ora, destinazione, id_equipaggio, id_aereo) FROM ' || quote_literal(common_path || 'VOLO.csv') || ' DELIMITER '','' CSV HEADER;';
    END $$;