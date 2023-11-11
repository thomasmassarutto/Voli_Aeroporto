# Progetto basi di dati

## Analisi requisiti

Ci assicuriamo di gestire i voli di un aereoporto dal punto di vista dei gates, delegando al controllore di volo tutti gli aspetti relativi alla concorrenza di eventuali decolli contemporanei.

### Entità
- Volo
(**Ora**, **gate**, destinazione) (capacità passeggeri)

- Equipaggio (**ID**)

- Assistente
(**ID**)
    - Hostess 
    - Steward
- Pilota
(**ID**)
- Aereo
(**ID**)
- Modello
(**Nome_modello**, **Azienda_costruttrice**, carico_max, persone_max)

specifiche_tecniche: (peso, lunghezza, apertura_alare)

### Relazioni
- Volo (1,1) imbarca (1,1) Equipaggio
- Aeromobile (1,1) Tratta (1,1) Volo
- Aeromobile (1,1) Di (1,n) Modello
- Equipaggio (2,2) Comanda (1,1) Pilota
- Equipaggio (1,n) Compone (1,1) Assistente

### Operazioni

1. **cambio_gate**
2. **cambio_aeromobile**
3. **ricerca_voli_gate**
4. **ricerca_voli_destinazione**
5. **ricerca_voli_odierni**
6. **elimina_volo**
7. **Inserisci_volo**

## Schema Entità-Relazioni

img schema 1
perche non ha funzionato

img schema 2

## Regole di derivazione

### RD1 **capacità passeggeri**
Dato un volo, ricercare l'aeromobile, ottenere modello, derivare numero massimo di persone come 

Dato un volo, ritorna il numero massimo di passeggeri imbarcabili.

Capacità passeggeri si ottiene con persone_max meno numero di persone nell'equipaggio.

## Vincoli di integrità

### RV1 **Equipaggio non eccede persone_max**
In ogni il numero di persone che compone l'equipaggio deve essere minore o uguale al numero massimo di persone trasportabili dall'aereomobile.

## RELAZIONALE


## Vincoli di dominio

1. **VOLO**

| **Ora**            | **Gate**       | Destinazione |
|--------------------|----------------|--------------|
| [0, 60 $\cdot$ 24] | [1, max_gates] |              |

2. **MODELLO**

| **Nome_modello** | **azienda_costruttrice** | Destinazione |
|------------------|--------------------------|--------------|
|                  |                          |              |




