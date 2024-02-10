-- Clean up delle funzioni
DROP FUNCTION IF EXISTS Ricerca_Voli_Destinazione;
DROP FUNCTION IF EXISTS Steward_Aerei_Pesanti;
DROP FUNCTION IF EXISTS Aerei_Di_Linea;


-- Creazione delle funzioni
CREATE FUNCTION Ricerca_Voli_Destinazione(destinazione_desiderata VARCHAR)
    RETURNS TABLE (
        gate int,
        ora varchar,
        destinazione varchar,
        id_equipaggio varchar,
        id_aereo varchar
        ) AS $$
BEGIN
    RETURN QUERY
        SELECT v.gate, v.ora, v.destinazione, v.id_equipaggio, v.id_aereo
        FROM VOLO as v
        WHERE v.destinazione = destinazione_desiderata;
--         ORDER BY v.ora ASC; TODO: mettere il giusto tipo al tipo di ora
END;
$$ language plpgsql;


CREATE FUNCTION Steward_Aerei_Pesanti(X INT, Y INT)
RETURNS INT AS $$
DECLARE
    num_steward INT;
BEGIN
    SELECT COUNT(DISTINCT s.id) INTO num_steward
    FROM STEWARD s
        JOIN EQUIPAGGIO e ON s.id_equipaggio = e.id_equipaggio
        JOIN VOLO v ON e.id_equipaggio = v.id_equipaggio
        JOIN AEREO a ON v.id_ereo = a.id_aereo
    WHERE a.peso BETWEEN X and Y;
    GROUP BY s.id;

    RETURN num_steward;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION Aerei_Di_Linea()
RETURNS TABLE (
    id_aereo INT,
    nome_modello VARCHAR(255),
    azienda_costruttrice VARCHAR(255),
    persone_max INT,
    peso INT,
    lunghezza INT,
    apertura_alare INT
    ) AS $$
BEGIN
    RETURN QUERY
-- TODO: come seleziono il minimo?
    SELECT a.id, a.nome_modello, a.azienda_costruttrice, MIN(a.persone_max), a.peso, a.lunghezza, a.apertura_alare
    FROM AEROMOBILE a
        JOIN VOLO v ON v.id_aereo = a.id_aereo
        JOIN EQUIPAGGIO e ON e.id_equipaggio = v.id_equipaggio
        JOIN PILOTA p ON e.id_equipaggio = p.id_equipaggio
    WHERE p.età BETWEEN 30 AND 60
END;
$$ LANGUAGE plpgsql;


