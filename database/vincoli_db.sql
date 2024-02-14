-- Vincoli


-- (RV2) - Il numero di persone che compone l'equipaggio deve essere minore o uguale al numero massimo di persone trasportabili dall'aeromobile con cui volano.
ALTER TABLE VOLO ADD CONSTRAINT ck_numero_equipaggio
    CHECK (
            (SELECT persone_max
             FROM AEROMOBILE a
                      JOIN MODELLO m ON a.nome_modello = m.nome_modello AND a.azienda_costruttrice = m.azienda_costruttrice
             WHERE a.id_aereo = VOLO.id_aereo)
            >= (
                SELECT COUNT(*)
                FROM EQUIPAGGIO e
                         JOIN HOSTESS h ON e.id_equipaggio = h.id_equipaggio
                         JOIN STEWARD s ON e.id_equipaggio = s.id_equipaggio
                         JOIN PILOTA p ON e.id_equipaggio = p.id_equipaggio
                WHERE e.id_equipaggio = VOLO.id_equipaggio
            )
        );

-- TODO: ALTERNATIVA TRIGGER
-- CREATE FUNCTION check_numero_equipaggio()
--     RETURNS TRIGGER AS $$
-- BEGIN
--     IF (
--             (SELECT persone_max
--              FROM AEROMOBILE a
--                       JOIN MODELLO m ON a.nome_modello = m.nome_modello AND a.azienda_costruttrice = m.azienda_costruttrice
--              WHERE a.id_aereo = NEW.id_aereo)
--             < (
--                 SELECT COUNT(*)
--                 FROM EQUIPAGGIO e
--                          JOIN HOSTESS h ON e.id_equipaggio = h.id_equipaggio
--                          JOIN STEWARD s ON e.id_equipaggio = s.id_equipaggio
--                          JOIN PILOTA p ON e.id_equipaggio = p.id_equipaggio
--                 WHERE e.id_equipaggio = NEW.id_equipaggio
--             )
--         ) THEN
--         RAISE EXCEPTION 'Il numero di membri dell''equipaggio supera la capacità dell''aereo.';
--     END IF;
--
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- CREATE TRIGGER check_numero_equipaggio_trigger
--     BEFORE INSERT OR UPDATE
--     ON VOLO
--     FOR EACH ROW
-- EXECUTE FUNCTION check_numero_equipaggio();





-- VINCOLI DI DOMINIO
-- PILOTA
-- - PILOTA.eta: deve essere un valore positivo compreso tra 18 e 100
--
-- VOLO
-- - VOLO.gate: deve essere un valore numerico positivo
-- - VOLO.ora: deve essere un valore di tempo valido ('HH:MM:SS')
--
-- MODELLO
-- - MODELLO.persone_max: devono essere un valore positivo
-- - MODELLO.carico_max: devono essere un valore positivo
--
-- SPECIFICHE_TECNICHE
-- - SPECIFICHE_TECNICHE.peso: deve essere un valore numerico positivo
-- - SPECIFICHE_TECNICHE.apertura_alare: deve essere un valore numerico positivo
-- - SPECIFICHE_TECNICHE.lunghezza: deve essere un valore numerico positivo

ALTER TABLE PILOTA
    ADD CONSTRAINT ck_eta
        CHECK (eta BETWEEN 18 AND 100);

ALTER TABLE VOLO
    ADD CONSTRAINT ck_gate
        CHECK (gate > 0);

ALTER TABLE VOLO
    ADD CONSTRAINT ck_ora
        CHECK (ora BETWEEN '00:00' AND '23:59');

ALTER TABLE MODELLO
    ADD CONSTRAINT ck_persone_max
        CHECK (persone_max > 0);

ALTER TABLE MODELLO
    ADD CONSTRAINT ck_carico_max
        CHECK (carico_max > 0);

ALTER TABLE SPECIFICHE_TECNICHE
    ADD CONSTRAINT ck_peso_st
        CHECK (peso > 0);

ALTER TABLE SPECIFICHE_TECNICHE
    ADD CONSTRAINT ck_apertura_alare_st
        CHECK (apertura_alare > 0);

ALTER TABLE SPECIFICHE_TECNICHE
    ADD CONSTRAINT ck_lunghezza_st
        CHECK (lunghezza > 0);






-- (RV2) - L'entità "EQUIPAGGIO" deve sempre includere almeno un membro fra hostess e steward.


-- PILOTA
-- $$
-- \begin{cases}
--    \forall \space x,y,z \in PILOTA \quad | \quad x \neq y \neq z \space \wedge \space x.id\textunderscore equipaggio = y.id\textunderscore equipaggio \implies x.id\textunderscore equipaggio \neq z.id\textunderscore equipaggio \\
--    \exists \space x,y \in PILOTA \quad | \quad x.id\textunderscore equipaggio = y.id\textunderscore equipaggio \\
-- \end{cases}
-- $$
--
--
-- EQUIPAGGIO
-- Ogni EQUIPAGGIO deve essere collegato ad almeno uno tra HOSTESS e STEWARD
-- Ogni EQUIPAGGIO deve essere collegato ad almeno un PILOTA
-- $$
--    \forall \space x \in EQUIPAGGIO \quad \exist y \in PILOTA \quad | x.id\textunderscore equipaggio = y.id\textunderscore equipaggio \\
-- $$
-- Ogni EQUIPAGGIO deve essere collegato a un VOLO
























-- TODO: chiedi
--  CHECK
--  TRANSACTION (stored transaction)
--  quando usare trigger e quando usare gli assert
--  ROLLBACK, COMMIT e CONSTRAIN DEFFERED
--  differenze tra FUNCTION e PROCEDURE
--  TRANSACTION FA DA SOLA IL ROLLBACK? Quando usare il rollback?


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




