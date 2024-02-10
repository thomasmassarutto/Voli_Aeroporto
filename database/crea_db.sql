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

-- TODO: MODIFICATO
CREATE TABLE PILOTA
(
    codice_fiscale CHAR(16) PRIMARY KEY,
--     eta            INT                                                NOT NULL,
    id_equipaggio  VARCHAR(255) REFERENCES EQUIPAGGIO (id_equipaggio) NOT NULL
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

-- TODO: MODIFICATA
CREATE TABLE VOLO
(
    gate          INT,
    ora           VARCHAR(255), -- potremmo usare TIME
    destinazione  VARCHAR(255)                                              NOT NULL,
--     capacità_passeggeri INT                                                       NOT NULL,
    id_equipaggio VARCHAR(255) REFERENCES EQUIPAGGIO (id_equipaggio) UNIQUE NOT NULL,
    id_aereo      VARCHAR(255) REFERENCES AEROMOBILE (id_aereo) UNIQUE      NOT NULL,
    PRIMARY KEY (gate, ora)
);