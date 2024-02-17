-- VINCOLI DI DOMINIO [CHECK]
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




-- TRIGGER
DROP TRIGGER IF EXISTS trigger_insert_update_equipaggio ON EQUIPAGGIO;
DROP TRIGGER IF EXISTS trigger_delete_hostess ON HOSTESS;
DROP TRIGGER IF EXISTS trigger_delete_steward ON STEWARD;


--  VINCOLO tra EQUIPAGGIO, HOSTESS e STEWARD
--      - equipaggio non puo' essere inserito senza hostess oppure steward
--      - equipaggio deve avere sempre almeno un hostess oppure uno steward (quindi se viene eliminato anche l'ultimo S o H dall'equipaggio questo viene eliminato di conseguenza)
--  ND.: la chiave esterna in hostess e steward garantisce:
--      - non puo' esistere hostess o steward senza equipaggio
--      - equipaggio non puo' essere eliminato se ha qualche hostess o steward associati
CREATE OR REPLACE FUNCTION trigger_function_insert_update_equipaggio()
    RETURNS TRIGGER AS $$
BEGIN
    IF NOT (
                NEW.id_equipaggio IN (SELECT id_equipaggio FROM HOSTESS) OR
                NEW.id_equipaggio IN (SELECT id_equipaggio FROM STEWARD))
    THEN
        RAISE EXCEPTION 'INSERT/UPDATE FAILED: id_equipaggio deve avere almeno uno tra HOSTESS o STEWARD';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_function_delete_hostess_steward()
    RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM HOSTESS
        WHERE id_equipaggio = OLD.id_equipaggio
    ) AND NOT EXISTS (
        SELECT 1
        FROM STEWARD
        WHERE id_equipaggio = OLD.id_equipaggio
    ) THEN
        DELETE FROM EQUIPAGGIO WHERE id_equipaggio = OLD.id_equipaggio;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_update_equipaggio
    BEFORE INSERT OR UPDATE ON EQUIPAGGIO
    FOR EACH ROW
EXECUTE FUNCTION trigger_function_insert_update_equipaggio();

CREATE TRIGGER trigger_delete_hostess
    AFTER DELETE ON HOSTESS
    FOR EACH ROW
EXECUTE FUNCTION trigger_function_delete_hostess_steward();

CREATE TRIGGER trigger_delete_steward
    AFTER DELETE ON STEWARD
    FOR EACH ROW
EXECUTE FUNCTION trigger_function_delete_hostess_steward();

-- FUNZIONI per L'INSERIMENTO E LA CANCELLAZIONE DI HOSTESS/STEWARD/EQUIPAGGIO
--  Inserimento:
--      La tabella hostess e steward hanno "DEFERRABLE" sulle chiavi esterne di moda da poterle ritardare al termine della transazione
--      Per inserire un equipaggio vanno associati almeno un hostess oppure uno steward, con questa procedura lo si puo' fare comodamente
--      NB.: L'utente deve usare una transazione impostando i due vincoli di chiave esterna a "DEFERRED"

-- esempio di utilizzo per inserire un equipaggio con uno steward
START TRANSACTION;
SET CONSTRAINTS fk_hos_equipaggio, fk_stw_equipaggio DEFERRED;
CALL insert_equipaggio_with_H_S('E01', NULL, 'SRLSDTL95E62F631I');
COMMIT;

CREATE OR REPLACE PROCEDURE insert_equipaggio_with_H_S(
    id_equipaggio VARCHAR(255),
    codice_fiscale_hostess CHAR(16),
    codice_fiscale_steward CHAR(16)
)
AS $$
BEGIN
    -- L'inserimento di hostess e/o steward sono fatti prima dell'inserimento di equipaggio per non violare il vincolo di chiave esterna
    IF codice_fiscale_hostess IS NOT NULL THEN
        INSERT INTO HOSTESS (codice_fiscale, id_equipaggio) VALUES (codice_fiscale_hostess, id_equipaggio);
    END IF;
    IF codice_fiscale_steward IS NOT NULL THEN
        INSERT INTO STEWARD (codice_fiscale, id_equipaggio) VALUES (codice_fiscale_steward, id_equipaggio);
    END IF;

    INSERT INTO EQUIPAGGIO (id_equipaggio) VALUES (id_equipaggio);
END;
$$ LANGUAGE plpgsql;





-- TODO: STAGING AREA

-- TODO: STAGING AREA



-- VINCOLI
-- (RV2) Il numero di persone che compone l'equipaggio deve essere minore o uguale al numero massimo di persone trasportabili dall'aeromobile con cui volano.
CREATE FUNCTION check_numero_equipaggio()
    RETURNS TRIGGER AS $$
BEGIN
    IF ((SELECT persone_max
        FROM AEROMOBILE a
            JOIN MODELLO USING (nome_modello, azienda_costruttrice)
            WHERE a.id_aereo = NEW.id_aereo
        ) < (
        SELECT COUNT(*)
        FROM EQUIPAGGIO e
            JOIN HOSTESS h ON e.id_equipaggio = h.id_equipaggio
            JOIN STEWARD s ON e.id_equipaggio = s.id_equipaggio
            JOIN PILOTA p ON e.id_equipaggio = p.id_equipaggio
        WHERE e.id_equipaggio = NEW.id_equipaggio ))
    THEN
        RAISE EXCEPTION 'Il numero di membri dell''equipaggio supera la capacità dell''aereo.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_numero_equipaggio_trigger
    BEFORE INSERT OR UPDATE
    ON VOLO
    FOR EACH ROW
    EXECUTE FUNCTION check_numero_equipaggio();


-- ALTER TABLE VOLO ADD CONSTRAINT ck_numero_equipaggio
--     CHECK ((
--         SELECT persone_max
--          FROM AEROMOBILE a
--               JOIN MODELLO USING (nome_modello, azienda_costruttrice)
--          WHERE a.id_aereo = VOLO.id_aereo
--         ) >= (
--         SELECT COUNT(*)
--         FROM EQUIPAGGIO e
--              JOIN HOSTESS h ON e.id_equipaggio = h.id_equipaggio
--              JOIN STEWARD s ON e.id_equipaggio = s.id_equipaggio
--              JOIN PILOTA p ON e.id_equipaggio = p.id_equipaggio
--         WHERE e.id_equipaggio = VOLO.id_equipaggio
--         ));





-- VINCOLI SU EQUIPAGGIO
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

