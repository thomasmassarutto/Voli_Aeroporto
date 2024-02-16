-- VINCOLI DI DOMINIO
ALTER TABLE PILOTA
    ADD CONSTRAINT ck_eta
        CHECK (eta BETWEEN 18 AND 100);

ALTER TABLE VOLO
    ADD CONSTRAINT ck_gate
        CHECK (gate > 0);

ALTER TABLE VOLO
    ADD CONSTRAINT ck_ora
        CHECK (ora BETWEEN TIME '00:00:00' AND TIME '23:59:59');

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


-- VINCOLI
-- (RV2) Il numero di persone che compone l'equipaggio deve essere minore o uguale al numero massimo di persone trasportabili dall'aeromobile con cui volano.
ALTER TABLE VOLO ADD CONSTRAINT ck_numero_equipaggio
    CHECK ((
        SELECT persone_max
         FROM AEROMOBILE a
              JOIN MODELLO USING (nome_modello, azienda_costruttrice)
         WHERE a.id_aereo = VOLO.id_aereo
        ) >= (
        SELECT COUNT(*)
        FROM EQUIPAGGIO e
             JOIN HOSTESS h ON e.id_equipaggio = h.id_equipaggio
             JOIN STEWARD s ON e.id_equipaggio = s.id_equipaggio
             JOIN PILOTA p ON e.id_equipaggio = p.id_equipaggio
        WHERE e.id_equipaggio = VOLO.id_equipaggio
        ));

-- TODO: ALTERNATIVA TRIGGER
-- CREATE FUNCTION check_numero_equipaggio()
--     RETURNS TRIGGER AS $$
-- BEGIN
--     IF (
--         (SELECT persone_max
--         FROM AEROMOBILE a
--              JOIN MODELLO USING (nome_modello, azienda_costruttrice)
--         WHERE a.id_aereo = NEW.id_aereo)
--         <
--         (SELECT COUNT(*)
--         FROM EQUIPAGGIO e
--              JOIN HOSTESS h ON e.id_equipaggio = h.id_equipaggio
--              JOIN STEWARD s ON e.id_equipaggio = s.id_equipaggio
--              JOIN PILOTA p ON e.id_equipaggio = p.id_equipaggio
--         WHERE e.id_equipaggio = NEW.id_equipaggio )
--     ) THEN
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
--     EXECUTE FUNCTION check_numero_equipaggio();





-- VINCOLI SU EQUIPAGGIO
-- - Ogni EQUIPAGGIO deve essere collegato a un VOLO
-- - Ogni EQUIPAGGIO deve essere collegato ad almeno uno tra HOSTESS e STEWARD
--
-- $$
-- \begin{cases}
-- \forall \space x \neq y \neq z \in PILOTA \quad | \quad x.id\textunderscore equipaggio = y.id\textunderscore equipaggio \implies x.id\textunderscore equipaggio \neq z.id\textunderscore equipaggio \\
-- \forall \space x'\in EQUIPAGGIO \quad \exists \space x \neq y \in PILOTA \quad | \quad x'.id\textunderscore equipaggio = x.id\textunderscore equipaggio = y.id\textunderscore equipaggio \\
-- \end{cases}
-- $$
ALTER TABLE EQUIPAGGIO
    ADD CONSTRAINT ck_equipaggio_volo
        CHECK (
            EXISTS (SELECT *
                    FROM VOLO
                    WHERE id_equipaggio = EQUIPAGGIO.id_equipaggio)
            );

ALTER TABLE EQUIPAGGIO
    ADD CONSTRAINT fk_equipaggio_hostess_steward
        CHECK (
            (id_equipaggio IN (SELECT id_equipaggio FROM HOSTESS)) OR
            (id_equipaggio IN (SELECT id_equipaggio FROM STEWARD))
            );

ALTER TABLE EQUIPAGGIO
    ADD CONSTRAINT fk_equipaggio_piloti
        CHECK (
            (SELECT COUNT(DISTINCT(p.codice_fiscale))
            FROM PILOTA p
            WHERE p.id_equipaggio = EQUIPAGGIO.id_equipaggio)
            = 2
            );

-- TODO: versione alternativa
-- ALTER TABLE EQUIPAGGIO
--     ADD CONSTRAINT ck_equipaggio_due_piloti
--         CHECK (
--             (EXISTS (
--                 SELECT *
--                 FROM PILOTA p1, PILOTA p2
--                 WHERE p1.codice_fiscale <> p2.codice_fiscale
--                   AND EQUIPAGGIO.id_equipaggio = p1.id_equipaggio = p2.id_equipaggio
--                 ))
--             AND
--             (NOT EXISTS (
--                     SELECT *
--                     FROM PILOTA p1, PILOTA p2, PILOTA p3
--                     WHERE p1.codice_fiscale <> p2.codice_fiscale <> p3.codice_fiscale
--                       AND EQUIPAGGIO.id_equipaggio = p1.id_equipaggio = p2.id_equipaggio = p3.id_equipaggio
--                 ))
--             );







-- TODO: Versione con il TRIGGER
CREATE OR REPLACE FUNCTION check_equipaggio_integrity()
    RETURNS TRIGGER AS $$
BEGIN
    IF ((id_equipaggio NOT IN (SELECT id_equipaggio FROM HOSTESS)) OR
        (id_equipaggio IN (SELECT id_equipaggio FROM STEWARD))) THEN
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





-- TODO: Inserimenti con deferred per i vincoli circolari
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