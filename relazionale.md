<!-- 
Notazione: chiavi primarie sottolineate, attributi in font normale
Notazione: Chiavi esterne in corsivo
Notazione: entità in maiuscolo, Relazioni in minuscolo. 
-->

HOSTESS (<U>CF</U>)

STEWARD (<U>CF</U>)

R1 (<U>*CF*</U>, <U>*id_equipaggio*</U>)
- CF: FK $\rightarrow$ HOSTESS.CF

R2 (<U>*CF*</U>, <U>*id_equipaggio*</U>)
- CF: FK $\rightarrow$ STEWARD.CF

EQUIPAGGIO (<U>id_equipaggio</U>)

PILOTA (<U>CF</U>, età)

COMANDA (id_equipaggio, CF)
- id_equipaggio: FK $\rightarrow$ EQUIPAGGIO.id_equipaggio
- CF: FK $\rightarrow$ PILOTA.CF)

VOLO (<U>gate</U>, <U>ora</U>, destinazione, capacità_passeggeri)

IMBARCA (<U>*id_equipaggio*</U>, <U>*gate*</U>, <U>*ora*</U>)
- id_equipaggio: FK $\rightarrow$ EQUIPAGGIO.id_equipaggio
- gate: FK $\rightarrow$ VOLO.gate
- ora: FK $\rightarrow$ VOLO.ora

AEROMOBILE (<U>id_aereo</U>)

TRATTA (<U>*gate*</U>, <U>*ora*</U>, <U>*id_aereo*</U>)
- gate: FK $\rightarrow$ VOLO.gate
- ora: FK $\rightarrow$ VOLO.ora
- id_aereo: FK $\rightarrow$ AEROMOBILE.id_aereo

MODELLO (<U>nome_modello</U>, <U>azienda_costruttrice</U>, carico_max, persone_max)

DI (<U>*id_aereo*</U>, <U>*nome_modello*</U>, <U>*azienda_costruttrice*</U>)
- id_aereo: FK $\rightarrow$ AEROMOBILE.id_aereo
- nome_modello: FK $\rightarrow$ MODELLO.nome_modello
- azienda_costruttrice: FK $\rightarrow$ MODELLO.azienda_costruttrice

SPECIFICHE_TECNICHE (<U>peso</U>, <U>apertura_alare</U>, <U>lunghezza</U>)

CON (<U>*nome_modello*</U>, <U>*azienda_costruttrice*</U>, <U>*peso*</U>, <U>*apertura_alare*</U>, <U>*lunghezza*</U>)
- nome_modello: FK $\rightarrow$ MODELLO.nome_modello
- azienda_costruttrice: FK $\rightarrow$ MODELLO.azienda_costruttrice
- peso: FK $\rightarrow$ SPECIFICHE_TECNICHE.peso
- apertura_alare: FK $\rightarrow$ SPECIFICHE_TECNICHE.apertura_alare
- lunghezza: FK $\rightarrow$ SPECIFICHE_TECNICHE.lunghezza
