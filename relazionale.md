### Notazione: *chiavi* in corsivo, attributi in font normale
### Notazione: ENTITA' in maiuscolo, Relazioni in minuscolo.
HOSTESS (*CF*)
###
r1 (*HOSTESS.CF*, *EQUIPAGGIO.id_equipaggio*)
###
STEWARD (*CF*)
###
r2 (*STEWARD.CF*, *EQUIPAGGIO.id_equipaggio*)
###
EQUIPAGGIO (*id_equipaggio*)
###
Comanda (*EQUIPAGGIO.id_equipaggio*, *PILOTA.CF*)
###
PILOTA (*CF*, età)
###
Imbarca (*EQUIPAGGIO.id_equipaggio*, *VOLO.gate*, *VOLO.ora*) 
###
VOLO (*gate*, *ora*, destinazione, capacità_passeggeri)
###
Tratta (*VOLO.gate*, *VOLO.ora*, *AEROMOBILE.id_aereo*)
###
AEROMOBILE (*id_aereo*)
###
Di (*AEROMOBILE.id_aereo*, *MODELLO*)
###
MODELLO (*nome_modello*, *azienda_costruttrice*, carico_max, persone_max)
###
Con (*MODELLO.nome_modello*, *MODELLO.azienda_costruttrice*, *SPECIFICHE TECNICHE*)
###
SPECIFICHE TECNICHE (*peso*, *apertura_alare*, *lunghezza*)
###



