-- 3 operazioni

-- Data una destinazione restituisce l'elenco dei voli che partono in giornata e la raggiungono
CREATE OR REPLACE FUNCTION Ricerca_Voli_Destinazione(destinazione_desiderata VARCHAR)
    RETURNS TABLE (
        gate INT,
        ora TIME,
        destinazione VARCHAR,
        id_equipaggio VARCHAR,
        id_aereo VARCHAR
        ) AS $$
BEGIN
    RETURN QUERY
        SELECT v.gate, v.ora, v.destinazione, v.id_equipaggio, v.id_aereo
        FROM VOLO v
        WHERE v.destinazione = destinazione_desiderata
        ORDER BY v.ora ASC;
END;
$$ LANGUAGE plpgsql;

-- Il numero di steward che lavorano su voli che fanno tratte con aerei con peso almeno X e al massimo Y
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
    WHERE m.peso BETWEEN x and y;

    RETURN num_steward;
END;
$$ LANGUAGE plpgsql;

-- Gli aerei con "persone_max" minimo comandati da piloti con età compresa fra 30 e 60 inclusi
CREATE OR REPLACE FUNCTION Aerei_Di_Linea()
RETURNS TABLE (
    id_aereo VARCHAR(255),
    nome_modello VARCHAR(255),
    peso_aereo INT,
    codice_fiscale CHAR(16),
    eta INT
    ) AS $$
BEGIN
    RETURN QUERY
        SELECT a.id_aereo, a.nome_modello, m.peso, p.codice_fiscale, p.eta
        FROM PILOTA p
             JOIN EQUIPAGGIO e USING (id_equipaggio)
             JOIN VOLO v USING (id_equipaggio)
             JOIN AEROMOBILE a USING (id_aereo)
             JOIN MODELLO m USING (nome_modello, azienda_costruttrice)
        WHERE (p.eta BETWEEN 30 AND 60)
            AND (m.peso = (SELECT MIN(peso) FROM MODELLO));
END;
$$ LANGUAGE plpgsql;

