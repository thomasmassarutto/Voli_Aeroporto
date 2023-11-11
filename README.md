# README

## Consegna esercizio

Esercizio 3:

Vogliamo modellare le seguenti informazioni riguardanti i voli in partenza in un piccolo aeroporto.

- Di ogni volo vogliamo specificare la destinazione e l’orario previsto di partenza. Si assuma che ogni volo venga svolto ogni giorno della settimana, sempre nello stesso orario, ma che da un giorno all’altro possano cambiare il cancello d’uscita (gate) e l’aeromobile. Di ogni volo vogliamo specificare l’equipaggio articolato nelle diverse componenti: due piloti, zero, una o più hostess, zero, uno o più steward. I due piloti e almeno una hostess o uno steward devono essere sempre presenti.

- Si assuma che ogni aeroplano effettui ogni giorno un unico volo. Ogni giorno vogliamo sapere l’orario di partenza e la destinazione di ogni aeromobile. Si assuma che, fissati il giorno, l’ora e il cancello d’uscita (gate), venga identificato univocamente il volo, con relativi aeromobile e destinazione.

- Di ogni aeromobile utilizzato, identificato da un opportuno codice, vogliamo memorizzare l’azienda costruttrice e il modello, con le sue caratteristiche: la capacità (numero massimo di passeggeri e quantità massima di materiale trasportabile) e le caratteristiche tecniche (peso, lunghezza, apertura alare). 

Si definisca uno schema Entità-Relazioni che descriva il contenuto informativo del sistema, illustrando con chiarezza le eventuali assunzioni fatte. Lo schema dovrà essere completato con attributi ragionevoli per ciascuna entità (identificando le possibili chiavi) e relazione. Vanno specificati accuratamente i vincoli di cardinalità e partecipazione di ciascuna relazione. Si definiscano anche eventuali regole aziendali (regole di derivazione e vincoli di integrità) necessarie per codificare alcuni dei requisiti attesi del sistema.