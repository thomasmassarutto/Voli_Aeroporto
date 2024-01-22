-- Creazione delle tabelle
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
    età            INT                                                NOT NULL,
    id_equipaggio  VARCHAR(255) REFERENCES EQUIPAGGIO (id_equipaggio) NOT NULL
);

CREATE TABLE EQUIPAGGIO
(
    id_equipaggio VARCHAR(255) PRIMARY KEY,
    -- TODO: resolve id_equipaggio
);

CREATE TABLE VOLO
(
    gate                INT PRIMARY KEY,
    ora                 VARCHAR(255) PRIMARY KEY,  -- potremmo usare TIME
    destinazione        VARCHAR(255)                                              NOT NULL,
    capacità_passeggeri INT                                                       NOT NULL,
    id_equipaggio       VARCHAR(255) REFERENCES EQUIPAGGIO (id_equipaggio) UNIQUE NOT NULL,
    id_aereo            VARCHAR(255) REFERENCES AEROMOBILE (id_aereo) UNIQUE      NOT NULL
);

CREATE TABLE AEROMOBILE
(
    id_aereo             VARCHAR(255) PRIMARY KEY,
    nome_modello         VARCHAR(255) REFERENCES MODELLO (nome_modello)         NOT NULL,
    azienda_costruttrice VARCHAR(255) REFERENCES MODELLO (azienda_costruttrice) NOT NULL
);

CREATE TABLE MODELLO
(
    nome_modello         VARCHAR(255) PRIMARY KEY,
    azienda_costruttrice VARCHAR(255) PRIMARY KEY,
    carico_max           INT NOT NULL,
    persone_max          INT NOT NULL,
    peso                 INT REFERENCES SPECIFICHE_TECNICHE (peso) NOT NULL,
    apertura_alare       INT REFERENCES SPECIFICHE_TECNICHE (apertura_alare) NOT NULL,
    lunghezza            INT REFERENCES SPECIFICHE_TECNICHE (lunghezza) NOT NULL
);

-- TODO: E' corretto dividere i reference in piu' righe, oppure bisognerebbe collegarle tutte in una sola riga?

CREATE TABLE SPECIFICHE_TECNICHE
(
    peso           INT PRIMARY KEY,
    apertura_alare INT PRIMARY KEY,
    lunghezza      INT PRIMARY KEY
);