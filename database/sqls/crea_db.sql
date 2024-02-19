

-- Creazione delle tabelle
CREATE TABLE EQUIPAGGIO
(
    id_equipaggio VARCHAR(255) PRIMARY KEY
);

-- TODO: inserisci nella relazione il motivo del deferrable in hostess e steward
CREATE TABLE HOSTESS
(
    codice_fiscale CHAR(16) PRIMARY KEY,
    id_equipaggio  VARCHAR(255) NOT NULL,
    CONSTRAINT fk_hos_equipaggio FOREIGN KEY (id_equipaggio)
        REFERENCES EQUIPAGGIO (id_equipaggio) DEFERRABLE
);

CREATE TABLE STEWARD
(
    codice_fiscale CHAR(16) PRIMARY KEY,
    id_equipaggio  VARCHAR(255)NOT NULL,
    CONSTRAINT fk_stw_equipaggio FOREIGN KEY (id_equipaggio)
        REFERENCES EQUIPAGGIO (id_equipaggio) DEFERRABLE
);

CREATE TABLE PILOTA
(
    codice_fiscale CHAR(16) PRIMARY KEY,
    eta INT GENERATED ALWAYS AS
        ((2024 - (1900 + (SUBSTRING(codice_fiscale FROM 7 FOR 2))::integer)) % 100) STORED,
    id_equipaggio VARCHAR(255) NOT NULL,
    CONSTRAINT fk_plt_equipaggio FOREIGN KEY (id_equipaggio)
        REFERENCES EQUIPAGGIO (id_equipaggio) DEFERRABLE
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
    ora           TIME,
    destinazione  VARCHAR(255)                                              NOT NULL,
    capacita_passeggeri INT,
    id_equipaggio VARCHAR(255) UNIQUE NOT NULL,
    id_aereo      VARCHAR(255) REFERENCES AEROMOBILE (id_aereo) UNIQUE      NOT NULL,
    CONSTRAINT fk_volo_equipaggio FOREIGN KEY (id_equipaggio)
        REFERENCES EQUIPAGGIO (id_equipaggio) DEFERRABLE,
    PRIMARY KEY (gate, ora)
);

CREATE OR REPLACE FUNCTION trigger_function_calcola_capacita_passeggeri()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.capacita_passeggeri := (
        SELECT m.persone_max
        FROM AEROMOBILE a
            JOIN MODELLO m USING (nome_modello, azienda_costruttrice)
        WHERE a.id_aereo = NEW.id_aereo
    ) - 2 - (
        SELECT COUNT(*)
        FROM HOSTESS h
        WHERE h.id_equipaggio = NEW.id_equipaggio
    ) - (
        SELECT COUNT(*)
        FROM STEWARD s
        WHERE s.id_equipaggio = NEW.id_equipaggio
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calcola_capacita_passeggeri
    BEFORE INSERT OR UPDATE ON VOLO
    FOR EACH ROW
EXECUTE FUNCTION trigger_function_calcola_capacita_passeggeri();