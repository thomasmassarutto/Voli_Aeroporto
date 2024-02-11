-- Clean up delle tabelle
DROP TABLE IF EXISTS VOLO;
DROP TABLE IF EXISTS HOSTESS;
DROP TABLE IF EXISTS STEWARD;
DROP TABLE IF EXISTS PILOTA;
DROP TABLE IF EXISTS EQUIPAGGIO;
DROP TABLE IF EXISTS AEROMOBILE;
DROP TABLE IF EXISTS MODELLO;
DROP TABLE IF EXISTS SPECIFICHE_TECNICHE;


-- Creazione delle tabelle
CREATE TABLE EQUIPAGGIO
(
    id_equipaggio VARCHAR(255) PRIMARY KEY
);

CREATE TABLE HOSTESS
(
    codice_fiscale CHAR(16) PRIMARY KEY,
    id_equipaggio  VARCHAR(255) REFERENCES EQUIPAGGIO (id_equipaggio) NOT NULL
);

CREATE TABLE STEWARD
(
    codice_fiscale CHAR(16) PRIMARY KEY,
    id_equipaggio  VARCHAR(255) REFERENCES EQUIPAGGIO (id_equipaggio) NOT NULL
);

CREATE TABLE PILOTA
(
    codice_fiscale CHAR(16) PRIMARY KEY,
    -- TODO: va bene hardcoddare 2024 all'interno cosi'
    eta INT GENERATED ALWAYS AS
        ( 2024 - (1900 + CAST(SUBSTRING(codice_fiscale FROM 7 FOR 2) AS INT)) ) STORED,
    id_equipaggio VARCHAR(255) REFERENCES EQUIPAGGIO (id_equipaggio) NOT NULL
);

CREATE TABLE SPECIFICHE_TECNICHE
(
    peso           INT,
    apertura_alare INT,
    lunghezza      INT,
    PRIMARY KEY (peso, apertura_alare, lunghezza)
);

CREATE TABLE MODELLO
(
    nome_modello         VARCHAR(255),
    azienda_costruttrice VARCHAR(255),
    carico_max           INT NOT NULL,
    persone_max          INT NOT NULL,
    peso                 INT NOT NULL,
    apertura_alare       INT NOT NULL,
    lunghezza            INT NOT NULL,
    CONSTRAINT fk_specifiche_tecniche
        FOREIGN KEY (peso, apertura_alare, lunghezza)
            REFERENCES SPECIFICHE_TECNICHE (peso, apertura_alare, lunghezza),
    PRIMARY KEY (nome_modello, azienda_costruttrice)
);

CREATE TABLE AEROMOBILE
(
    id_aereo             VARCHAR(255) PRIMARY KEY,
    nome_modello         VARCHAR(255) NOT NULL,
    azienda_costruttrice VARCHAR(255) NOT NULL,
    CONSTRAINT fk_modello FOREIGN KEY (nome_modello, azienda_costruttrice)
        REFERENCES MODELLO (nome_modello, azienda_costruttrice)
);


CREATE TABLE VOLO
(
    gate          INT,
    ora           VARCHAR(255), -- potremmo usare TIME
    destinazione  VARCHAR(255)                                              NOT NULL,
    id_equipaggio VARCHAR(255) REFERENCES EQUIPAGGIO (id_equipaggio) UNIQUE NOT NULL,
    id_aereo      VARCHAR(255) REFERENCES AEROMOBILE (id_aereo) UNIQUE      NOT NULL,
    PRIMARY KEY (gate, ora)
);

-- Soluzione per capacita' passeggeri
CREATE VIEW VOLO_COMPLETO AS
SELECT
    v.gate,
    v.ora,
    v.destinazione,
    (
        SELECT m.persone_max
        FROM VOLO v1
            JOIN AEROMOBILE a USING (id_aereo)
            JOIN MODELLO m USING (nome_modello, azienda_costruttrice)
        WHERE v1.gate = v.gate AND v1.ora = v.ora
    ) - 2 - (
        SELECT COUNT(*)
        FROM VOLO v2
            JOIN EQUIPAGGIO e USING (id_equipaggio)
            JOIN HOSTESS h USING (id_equipaggio)
            JOIN STEWARD s USING (id_equipaggio)
        WHERE v2.gate = v.gate AND v2.ora = v.ora
    ) AS capacita_passeggeri,
    v.id_equipaggio,
    v.id_aereo
FROM VOLO v;



-- TODO: vedi se si puo' implementare la capacita' passeggeri con un trigger
-- CREATE FUNCTION calcola_cap_passeggeri()
--     RETURNS TRIGGER AS $$
-- BEGIN
--     NEW.capacita_passeggeri :=
--         -- capacita' massima passeggeri dell'aereo
--         (SELECT m.persone_max
--          FROM VOLO v
--                   JOIN AEROMOBILE a USING (id_aereo)
--                   JOIN MODELLO m USING (nome_modello, azienda_costruttrice)
--          WHERE v.gate = NEW.gate AND v.ora = NEW.ora )
--         -- sempre due piloti
--         - 2 -
--         -- conta il numero degli assistenti
--         (SELECT COUNT (*)
--         FROM VOLO v
--             JOIN EQUIPAGGIO e ON v.id_equipaggio = e.id_equipaggio
--             JOIN HOSTESS h ON e.id_equipaggio = h.id_equipaggio
--             JOIN STEWARD s ON e.id_equipaggio = s.id_equipaggio
--         WHERE v.gate = NEW.gate AND v.ora = NEW.ora );
--
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- CREATE TRIGGER deriva_cap_passeggeri
--     AFTER INSERT OR UPDATE
--     ON VOLO
--     FOR EACH ROW
--     EXECUTE FUNCTION calcola_cap_passeggeri();
