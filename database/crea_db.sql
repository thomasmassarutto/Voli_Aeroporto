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
    età            INT                                                NOT NULL,
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

CREATE TABLE VOLO
(
    gate                INT,
    ora                 VARCHAR(255),  -- potremmo usare TIME
    destinazione        VARCHAR(255)                                              NOT NULL,
    id_equipaggio       VARCHAR(255) REFERENCES EQUIPAGGIO (id_equipaggio) UNIQUE NOT NULL,
    id_aereo            VARCHAR(255) REFERENCES AEROMOBILE (id_aereo) UNIQUE      NOT NULL,
    PRIMARY KEY (gate, ora)
);







-- Aggiunta di vincoli per la tabella PILOTA
ALTER TABLE PILOTA
-- TODO: Vincolo complesso

-- Verifico che ogni equipaggio abbia almeno uno tra hostess o steward
ALTER TABLE EQUIPAGGIO
    ADD CONSTRAINT fk_equipaggio_hostess_steward
        CHECK (
                (id_equipaggio IN (SELECT id_equipaggio FROM HOSTESS)) OR
                (id_equipaggio IN (SELECT id_equipaggio FROM STEWARD))
            );

ALTER TABLE EQUIPAGGIO
    ADD CONSTRAINT fk_equipaggio_piloti
        CHECK (
                (SELECT COUNT(*) FROM PILOTA WHERE id_equipaggio = EQUIPAGGIO.id_equipaggio) = 2
            );

ALTER TABLE EQUIPAGGIO
    ADD CONSTRAINT fk_equipaggio_volo
        FOREIGN KEY (id_equipaggio)
            REFERENCES VOLO (id_equipaggio);

-- Aggiunta di vincoli per la tabella AEROMOBILE
ALTER TABLE AEROMOBILE
    ADD CONSTRAINT fk_aeromobile_volo
        FOREIGN KEY (id_aereo)
            REFERENCES VOLO (id_aereo);

-- Aggiunta di vincoli per la tabella MODELLO
ALTER TABLE MODELLO
    ADD CONSTRAINT fk_modello_aeromobile
        FOREIGN KEY (nome_modello, azienda_costruttrice)
            REFERENCES AEROMOBILE (nome_modello, azienda_costruttrice);

-- Aggiunta di vincoli per la tabella SPECIFICHE_TECNICHE
ALTER TABLE SPECIFICHE_TECNICHE
    ADD CONSTRAINT fk_specifiche_tecniche_modello
        FOREIGN KEY (peso, apertura_alare, lunghezza)
            REFERENCES MODELLO (peso, apertura_alare, lunghezza);
