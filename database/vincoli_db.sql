
-- TODO: Derivare i valori in maniera diversa (la colonna capacita_passeggeri esiste gia')
ALTER TABLE VOLO
    ADD COLUMN capacita_passeggeri INT GENERATED ALWAYS AS (MODELLO.persone_max - 2 - (SELECT COUNT(*) FROM HOSTESS)) STORED;

ALTER TABLE PILOTA
    ADD COLUMN anno_di_nascita INT GENERATED ALWAYS AS (
        CAST(SUBSTRING(codice_fiscale FROM 12 FOR 4) AS INT)
        ) STORED;




-- TODO: chiedi
--  CHECK
--  TRANSACTION (stored transaction)
--  quando usare trigger e quando usare gli assert
--  ROLLBACK, COMMIT e CONSTRAIN DEFFERED
--  differenze tra FUNCTION e PROCEDURE




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








-- TODO: Da proporre al prof

CREATE OR REPLACE FUNCTION check_equipaggio_integrity()
    RETURNS TRIGGER AS $$ -- ci va il ";"?
BEGIN
    IF NOT EXISTS (SELECT 1 FROM HOSTESS WHERE id_equipaggio = NEW.id_equipaggio) AND
       NOT EXISTS (SELECT 1 FROM STEWARD WHERE id_equipaggio = NEW.id_equipaggio) THEN
        RAISE EXCEPTION 'Violazione del vincolo di integrità: l''id_equipaggio deve essere presente in HOSTESS o STEWARD.';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER equipaggio_integrity_trigger
    BEFORE INSERT OR UPDATE
                         ON EQUIPAGGIO
                         FOR EACH ROW
                         EXECUTE FUNCTION check_equipaggio_integrity();


CREATE OR REPLACE PROCEDURE insert_equipaggio(
    id_equipaggio VARCHAR(255),
    codice_fiscale_hostess CHAR(16),
    codice_fiscale_steward CHAR(16)
)
AS $$
BEGIN
    BEGIN TRANSACTION;
    SET CONSTRAINTS all DEFERRED; -- posticipo il controllo dei vincoli di chiave esterna per hostess e steward

    IF codice_fiscale_hostess IS NOT NULL THEN
                INSERT INTO HOSTESS (codice_fiscale, id_equipaggio) VALUES (codice_fiscale_hostess, id_equipaggio);
    END IF;
        IF codice_fiscale_steward IS NOT NULL THEN
                INSERT INTO STEWARD (codice_fiscale, id_equipaggio) VALUES (codice_fiscale_steward, id_equipaggio);
    END IF;
    INSERT INTO EQUIPAGGIO (id_equipaggio) VALUES (id_equipaggio);

    IF trigger_triggered THEN -- trova un modo per fare questo
            ROLLBACK;
    ELSE
            COMMIT;
    END IF;
END;
$$ LANGUAGE plpgsql;


















-- TODO: Da revisionare

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




