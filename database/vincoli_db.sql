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




-- Clean up TRIGGERS
DROP TRIGGER IF EXISTS trigger_atleast_one ON EQUIPAGGIO;
DROP TRIGGER IF EXISTS trigger_delete_hostess ON HOSTESS;
DROP TRIGGER IF EXISTS trigger_delete_steward ON STEWARD;
DROP TRIGGER IF EXISTS trigger_exact_two ON EQUIPAGGIO;
DROP TRIGGER IF EXISTS trigger_nomore_two_piloti ON PILOTA;
DROP TRIGGER IF EXISTS trigger_exists_volo ON VOLO;
DROP TRIGGER IF EXISTS trigger_valid_num_equipaggio ON VOLO;



--  VINCOLO tra EQUIPAGGIO, HOSTESS e STEWARD
--      - equipaggio non puo' essere inserito senza hostess oppure steward
--      - equipaggio deve avere sempre almeno un hostess oppure uno steward (quindi se viene eliminato anche l'ultimo S o H dall'equipaggio questo viene eliminato di conseguenza)
--  NB.: la chiave esterna in hostess e steward (verso equipaggio) garantisce:
--      - non puo' esistere hostess o steward senza equipaggio
--      - equipaggio non puo' essere eliminato se ha qualche hostess o steward associati

CREATE OR REPLACE FUNCTION trigger_function_atleast_one()
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

CREATE TRIGGER trigger_atleast_one
    BEFORE INSERT OR UPDATE ON EQUIPAGGIO
    FOR EACH ROW
EXECUTE FUNCTION trigger_function_atleast_one();

CREATE TRIGGER trigger_delete_hostess
    AFTER DELETE ON HOSTESS
    FOR EACH ROW
EXECUTE FUNCTION trigger_function_delete_hostess_steward();

CREATE TRIGGER trigger_delete_steward
    AFTER DELETE ON STEWARD
    FOR EACH ROW
EXECUTE FUNCTION trigger_function_delete_hostess_steward();


-- FUNZIONI per L'INSERIMENTO DI HOSTESS/STEWARD/EQUIPAGGIO
--  Inserimento:
--      La tabella hostess e steward hanno "DEFERRABLE" sulle chiavi esterne di moda da poterle ritardare al termine della transazione
--      Per inserire un equipaggio vanno associati almeno un hostess oppure uno steward, con questa procedura lo si puo' fare comodamente
--      L'utente deve usare una transazione impostando i due vincoli di chiave esterna a "DEFERRED"

--  esempio di utilizzo:
-- START TRANSACTION;
-- SET CONSTRAINTS fk_hos_equipaggio, fk_stw_equipaggio DEFERRED;
-- INSERT INTO HOSTESS (codice_fiscale, id_equipaggio) VALUES ('STLFSC87E62L491I', 'E01');
-- INSERT INTO STEWARD (codice_fiscale, id_equipaggio) VALUES ('SRLSDT95E62F631I', 'E01');
-- INSERT INTO EQUIPAGGIO (id_equipaggio) VALUES ('E01');
-- COMMIT;







--  VINCOLO tra EQUIPAGGIO e PILOTA
--      - equipaggio non puo' essere inserito senza esattamente due piloti associati
--      - un pilota non puo' essere inserito se l'equipaggio possiede gia' due
--  NB.: la chiave esterna in pilota (verso equipaggio) garantisce:
--      - non puo' esistere un pilota senza equipaggio
--      - equipaggio non puo' essere eliminato se ha un qualche pilota associato

CREATE OR REPLACE FUNCTION trigger_function_exact_two()
    RETURNS TRIGGER AS $$
BEGIN
    IF (
        SELECT COUNT(DISTINCT p.codice_fiscale)
        FROM PILOTA p
        WHERE p.id_equipaggio = NEW.id_equipaggio
    ) != 2 THEN
        RAISE EXCEPTION 'INSERT/UPDATE FAILED: L''equipaggio deve avere esattamente due piloti.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_exact_two
    BEFORE INSERT OR UPDATE ON EQUIPAGGIO
    FOR EACH ROW
EXECUTE FUNCTION trigger_function_exact_two();


CREATE OR REPLACE FUNCTION trigger_function_nomore_two_piloti()
    RETURNS TRIGGER AS $$
BEGIN
    IF (
       SELECT COUNT(DISTINCT p.codice_fiscale)
       FROM PILOTA p
       WHERE p.id_equipaggio = NEW.id_equipaggio
    ) >= 2 THEN
        RAISE EXCEPTION 'INSERT/UPDATE FAILED: L''equipaggio possiede gia'' due piloti';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creazione di un trigger per il secondo controllo
CREATE TRIGGER trigger_nomore_two_piloti
    BEFORE INSERT OR UPDATE ON PILOTA
    FOR EACH ROW
EXECUTE FUNCTION trigger_function_nomore_two_piloti();

-- FUNZIONI per L'INSERIMENTO DI PILOTA/EQUIPAGGIO
--  Inserimento:
--      La tabella pilota ha "DEFERRABLE" sulla chiave esterne di moda da poterle ritardare al termine della transazione
--      Per inserire un equipaggio vanno associati esattamente due piloti, con questa procedura lo si puo' fare comodamente
--      L'utente deve usare una transazione impostando il vincolo di chiave esterna a "DEFERRED"

--  esempio di utilizzo:
-- START TRANSACTION;
-- SET CONSTRAINTS fk_plt_equipaggio DEFERRED;
-- INSERT INTO PILOTA (codice_fiscale, id_equipaggio) VALUES ('ZLCSSC93A69I530I', 'E01');
-- INSERT INTO PILOTA (codice_fiscale, id_equipaggio) VALUES ('TSDDCN86A69I530I', 'E01');
-- INSERT INTO EQUIPAGGIO (id_equipaggio) VALUES ('E01');
-- COMMIT;






--  VINCOLO tra EQUIPAGGIO e VOLO
--      - equipaggio non puo' essere inserito senza un volo associato
--  NB.: la chiave esterna in volo (verso equipaggio) garantisce:
--      - non puo' esistere volo senza equipaggio
--      - equipaggio non puo' essere eliminato se ha un qualche volo associato

CREATE OR REPLACE FUNCTION trigger_function_exists_volo()
    RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM VOLO
        WHERE id_equipaggio = NEW.id_equipaggio
    ) THEN
        RAISE EXCEPTION 'INSERT/UPDATE FAILED: Nessun volo associato all''equipaggio';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_exists_volo
    BEFORE INSERT OR UPDATE ON EQUIPAGGIO
    FOR EACH ROW
EXECUTE FUNCTION trigger_function_exists_volo();

-- FUNZIONI per L'INSERIMENTO DI VOLO/EQUIPAGGIO
--  Inserimento:
--      La tabella volo ha "DEFERRABLE" sulla chiave esterne di moda da poterle ritardare al termine della transazione
--      Per inserire un equipaggio va associato un volo, con questa procedura lo si puo' fare comodamente
--      L'utente deve usare una transazione impostando il vincolo di chiave esterna a "DEFERRED"
--      L'aereo deve essere gia' presente nel database per non violare il vincolo di chiave esterna su "id_aereo"

--  esempio di utilizzo:
-- START TRANSACTION;
-- SET CONSTRAINTS fk_volo_equipaggio DEFERRED;
-- INSERT INTO VOLO (gate, ora, destinazione, id_equipaggio, id_aereo)
--      VALUES (1,	'07:00:00',	'Porto','E01','A01');
-- INSERT INTO EQUIPAGGIO (id_equipaggio) VALUES ('E01');
-- COMMIT;










-- INSERTION PROCEDURE
-- - Per un inserimento piu' facile usiamo la seguente procedura
-- - Bisogna assicurarsi che la procedura sia interna ad una transazione che temporaneamente ritarda dei vincoli di chiave esterna specifici

-- esempio di utilizzo:
-- START TRANSACTION;
-- SET CONSTRAINTS fk_hos_equipaggio, fk_stw_equipaggio, fk_plt_equipaggio, fk_volo_equipaggio DEFERRED;
-- CALL insert_volo_con_personale(
--     'E01',
--     'STLFSC87E62L491I',
--     'SRLSDT95E62F631I',
--     'ZLCSSC93A69I530I',
--     'TSDDCN86A69I530I',
--     1, '07:30:00', 'Milano',
--     'A1'
-- );
-- COMMIT;

CREATE OR REPLACE PROCEDURE insert_volo_con_personale(
    id_equipaggio           VARCHAR(255),
    codice_fiscale_hostess  CHAR(16),
    codice_fiscale_steward  CHAR(16),
    codice_fiscale_pilota1  CHAR(16),
    codice_fiscale_pilota2  CHAR(16),
    gate                    INT,
    ora                     TIME,
    destinazione            VARCHAR,
    id_aereo                VARCHAR
)
AS $$
BEGIN
    -- hostess e/o steward possono essere NULL (necessario uno dei due)
    IF codice_fiscale_hostess IS NOT NULL THEN
        INSERT INTO HOSTESS VALUES (codice_fiscale_hostess, id_equipaggio);
    END IF;
    IF codice_fiscale_steward IS NOT NULL THEN
        INSERT INTO STEWARD VALUES (codice_fiscale_steward, id_equipaggio);
    END IF;

    INSERT INTO PILOTA (codice_fiscale, id_equipaggio)
        VALUES (codice_fiscale_pilota1, id_equipaggio);
    INSERT INTO PILOTA (codice_fiscale, id_equipaggio)
        VALUES (codice_fiscale_pilota2, id_equipaggio);

    INSERT INTO VOLO (gate, ora, destinazione, id_equipaggio, id_aereo)
        VALUES (gate, ora, destinazione, id_equipaggio, id_aereo);

    INSERT INTO EQUIPAGGIO VALUES (id_equipaggio);
END;
$$ LANGUAGE plpgsql;

