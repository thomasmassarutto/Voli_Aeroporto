-- INDICI

CREATE INDEX idx_steward_equipaggio ON STEWARD (id_equipaggio);

CREATE INDEX idx_pilota_equipaggio ON PILOTA (id_equipaggio);
CREATE INDEX idx_pilota_eta ON PILOTA (eta);

CREATE INDEX idx_volo_equipaggio ON VOLO (id_equipaggio);
CREATE INDEX idx_volo_aereo ON VOLO (id_aereo);
CREATE INDEX idx_volo_destinazione ON VOLO (destinazione);

CREATE INDEX idx_aeromobile_modello_azienda ON AEROMOBILE (nome_modello, azienda_costruttrice);

CREATE INDEX idx_modello_peso ON MODELLO (peso);





