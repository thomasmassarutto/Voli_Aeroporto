-- Svuota tutte le tabelle
DO $$
    BEGIN
        ALTER TABLE VOLO DISABLE TRIGGER ALL;
        ALTER TABLE EQUIPAGGIO DISABLE TRIGGER ALL;
        ALTER TABLE PILOTA DISABLE TRIGGER ALL;
        ALTER TABLE HOSTESS DISABLE TRIGGER ALL;
        ALTER TABLE STEWARD DISABLE TRIGGER ALL;

        DELETE FROM VOLO WHERE TRUE;
        DELETE FROM HOSTESS WHERE TRUE;
        DELETE FROM STEWARD WHERE TRUE;
        DELETE FROM PILOTA WHERE TRUE;
        DELETE FROM EQUIPAGGIO WHERE TRUE;
        DELETE FROM AEROMOBILE WHERE TRUE;
        DELETE FROM MODELLO WHERE TRUE;
        DELETE FROM SPECIFICHE_TECNICHE WHERE TRUE;

        ALTER TABLE VOLO ENABLE TRIGGER ALL;
        ALTER TABLE EQUIPAGGIO ENABLE TRIGGER ALL;
        ALTER TABLE PILOTA ENABLE TRIGGER ALL;
        ALTER TABLE HOSTESS ENABLE TRIGGER ALL;
        ALTER TABLE STEWARD ENABLE TRIGGER ALL;
    END
$$;


-- Clean up dei trigger
DROP TRIGGER IF EXISTS trigger_calcola_capacita_passeggeri ON VOLO;
DROP FUNCTION IF EXISTS trigger_function_calcola_capacita_passeggeri;

DROP TRIGGER IF EXISTS trigger_atleast_one ON EQUIPAGGIO;
DROP FUNCTION IF EXISTS trigger_function_atleast_one;

DROP TRIGGER IF EXISTS trigger_delete_hostess ON HOSTESS;
DROP TRIGGER IF EXISTS trigger_delete_steward ON STEWARD;
DROP FUNCTION IF EXISTS trigger_function_delete_hostess_steward;

DROP TRIGGER IF EXISTS trigger_exact_two ON EQUIPAGGIO;
DROP FUNCTION IF EXISTS trigger_function_exact_two;

DROP TRIGGER IF EXISTS trigger_nomore_two_piloti ON PILOTA;
DROP FUNCTION IF EXISTS trigger_function_nomore_two_piloti;

DROP TRIGGER IF EXISTS trigger_exists_volo ON EQUIPAGGIO;
DROP FUNCTION IF EXISTS trigger_function_exists_volo;


-- Clean up della procedura
DROP FUNCTION IF EXISTS insert_volo_con_personale();


-- Clean up delle tabelle
DROP TABLE IF EXISTS VOLO;
DROP TABLE IF EXISTS HOSTESS;
DROP TABLE IF EXISTS STEWARD;
DROP TABLE IF EXISTS PILOTA;
DROP TABLE IF EXISTS EQUIPAGGIO;
DROP TABLE IF EXISTS AEROMOBILE;
DROP TABLE IF EXISTS MODELLO;
DROP TABLE IF EXISTS SPECIFICHE_TECNICHE;

