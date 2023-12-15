### Notazione: *chiavi* in corsivo, attributi in font normale
### Notazione: ENTITA' in maiuscolo, Relazioni in minuscol.
HOSTESS (*CF*)
###
r1 (*HOSTESS*, *EQUIPAGGIO*)
###
STEWARD (*CF*)
###
r2 (*STEWARD*, *EQUIPAGGIO*)
###
EQUIPAGGIO (*id_equipaggio*)
###
Comanda (*EQUIPAGGIO*, *PILOTA*)
###
PILOTA (*CF*, età)
###
Imbarca (*EQUIPAGGIO*, *VOLO*)
###
VOLO (*gate*, *ora*, destinazione, capacità_passeggeri)
###
Tratta (*VOLO*, *AEROMOBILE*)
###
AEROMOBILE (*id_aereo*)
###
Di (*AEROMOBILE*, *MODELLO*)
###
MODELLO (*nome_modello*, *azienda_costruttrice*, carico_max, persone_max)
###
Con (*MODELLO*, *SPECIFICHE TECNICHE*)
###
SPECIFICHE TECNICHE (*peso*, *apertura_alare*, *lunghezza*)
###



