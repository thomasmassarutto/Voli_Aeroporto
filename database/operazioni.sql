-- Creazione delle funzioni
CREATE OR REPLACE FUNCTION Ricerca_Voli_Destinazione(destinazione_desiderata VARCHAR)
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


CREATE OR REPLACE FUNCTION Steward_Aerei_Pesanti(X INT, Y INT)
    RETURNS INT AS $$
DECLARE
    num_steward INT;
BEGIN
    SELECT COUNT(DISTINCT(s.codice_fiscale)) INTO num_steward
    FROM STEWARD s
        -- quando gli attributi con cui fare join hanno lo stesso nome si puo' usare USING
        JOIN EQUIPAGGIO e USING (id_equipaggio)
        JOIN VOLO v USING (id_equipaggio)
        JOIN AEROMOBILE a USING (id_aereo)
        JOIN MODELLO m USING (nome_modello, azienda_costruttrice)
    WHERE m.peso BETWEEN 100000 and 150000;

    RETURN num_steward;
END;
$$ LANGUAGE plpgsql;


-- TODO: Verificare se funziona e correggeri evenntuali errori
CREATE OR REPLACE FUNCTION Aerei_Di_Linea()
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
        SELECT *
        FROM (
            SELECT
                a.id_aereo,
                a.nome_modello,
                a.azienda_costruttrice,
    --             a.persone_max,
    --             a.peso,
    --             a.lunghezza,
    --             a.apertura_alare,
                RANK() OVER (ORDER BY a.persone_max ASC) AS ranking
            FROM AEROMOBILE a
                JOIN VOLO v USING (id_equipaggio)
                JOIN EQUIPAGGIO e USING (id_equipaggio)
                JOIN PILOTA p USING (id_equipaggio)
            WHERE p.eta BETWEEN 30 AND 60)
    --             WHERE p.età BETWEEN 30 AND 60 AND ranking = 1) TODO: opzione 2
        WHERE ranking = 1;
END;
$$ LANGUAGE plpgsql;


