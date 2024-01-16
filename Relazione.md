# Gruppo 29

## 1 Analisi dei requisiti

### 1.1 Sintesi del testo
Si vuole realizzare una basi di dati per un piccolo aeroporto, del quale vogliamo rappresentare i dati relativi ai voli, all’equipaggio e agli aeromobili che effettuano i voli. 
Di ogni volo specifichiamo la destinazione e l’orario di partenza. Assumiamo inoltre, che ogni volo venga svolto ogni giorno della settimana, sempre nello stesso orario, ma che da un giorno all’altro possano cambiare il cancello d’uscita (gate) e l’aeromobile utilizzato. Ogni volo ha orario di partenza e gate unici (cioè, che nessun altro volo può partire allo stesso orario sullo stesso gate e viceversa) e viene effettuato da un equipaggio specifico. 
Ogni equipaggio è formato da due piloti, zero, una o più hostess, zero, uno o più steward. I due piloti e almeno una hostess o uno steward devono essere sempre presenti. Identifichiamo gli equipaggi mediante idonei codici identificativi. Per hostess e steward rappresentiamo il codice fiscale, e per i piloti, l’età e il codice fiscale. 
Di ogni aeromobile utilizzato, identificato da un opportuno codice, memorizziamo l’azienda costruttrice e il modello, con le sue caratteristiche tecniche: la capacità (numero massimo di passeggeri e quantità massima di materiale trasportabile) e le caratteristiche tecniche (peso, lunghezza e apertura alare). Ogni aeromobile effettua un unico volo al giorno.

### 1.2 Glossario
| Termine              | Descrizione                                             | Sinonimi |          Collegamenti           |
|:---------------------|:--------------------------------------------------------|:--------:|:-------------------------------:|
| Volo                 | Volo in partenza dall'aeroporto                         |    ~     |     Aeromobile, Equipaggio      |
| Aeromobile           | Aereo che effettua un volo                              |  Aereo   |          Volo, Modello          |
| Modello              | Modello di un aeromobile                                |    ~     | Aeromobile, Specifiche tecniche |
| Specifiche tecniche  | Peso, apertura alare e lunghezza relative ad un modello |    ~     |             Modello             |
| Equipaggio           | Insieme di persone che gestiscono un volo               |    ~     |    Volo, Pilota, Assistente     |
| Pilota               | Persona che pilota un aereo e fa parte di un equipaggio |    ~     |           Equipaggio            |
| Assistente           | Persona che assiste i passeggeri di un volo             |    ~     |  Equipaggio, Hostess, Steward   |
| Hostess              | Assistente di sesso femminile                           |    ~     |           Assistente            |
| Steward              | Assistente di sesso maschile                            |    ~     |           Assistente            |
| Gate                 | Cancello d'imbarco                                      |    ~     |              Volo               |
| Azienda_costruttrice | Azienda che costruisce modelli di aeromobili            |    ~     |             Modello             |


### 1.3 Specifiche sui dati
|                                                                            Frasi di carattere generale                                                                            |
|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Si vuole realizzare una basi di dati per un piccolo aeroporto, del quale vogliamo rappresentare i dati relativi ai voli, all’equipaggio e agli aeromobili che effettuano i voli.  |

|                                                                                                                                                                                                                        Frasi relative ai voli                                                                                                                                                                                                                         |
|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Di ogni volo specifichiamo la destinazione e l’orario di partenza. Assumiamo inoltre, che ogni volo venga svolto ogni giorno della settimana, sempre nello stesso orario, ma che da un giorno all’altro possano cambiare il cancello d’uscita (gate) e l’aeromobile utilizzato. Ogni volo ha orario di partenza e gate unici(cioè, che nessun altro volo può partire allo stesso orario sullo stesso gate e viceversa) e viene effettuato da un equipaggio specifico. |

|                                                                                                                                                          Frasi relative agli equipaggi                                                                                                                                                           |
|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Ogni equipaggio è formato da due piloti, zero, una o più hostess, zero, uno o più steward. I due piloti e almeno una hostess o uno steward devono essere sempre presenti. Identifichiamo gli equipaggi mediante idonei codici identificativi. Per hostess e steward rappresentiamo il codice fiscale, e per i piloti, l’età e il codice fiscale. |

|                                                                                                                                                                     Frasi relative agli aeromobili                                                                                                                                                                      |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Di ogni aeromobile utilizzato, identificato da un opportuno codice, memorizziamo l’azienda costruttrice e il modello, con le sue caratteristiche tecniche: la capacità (numero massimo di passeggeri e quantità massima di materiale trasportabile) e le caratteristiche tecniche (peso, lunghezza e apertura alare). Ogni aeromobile effettua un unico volo al giorno. |


### 1.4 Specifiche sulle operazioni

<br>

_**Operazioni base**_

1. **cambio_gate**
    - Dato un volo sostituisce il numero del gate corrente con uno aggiornato (operazione da effettuare in media 2 volte al giorno)

2. **cambio_aeromobile**
    - Dato un volo sostituisce l'aeromobile assegnata alla tratta con un nuovo aeromobile (2 volte al giorno)

3. **ricerca_voli_gate**
    - Dato un gate restituisce l'elenco dei voli programmati in giornata (circe 1000 volte al giorno)

4. **ricerca_voli_destinazione**
    - Data una destinazione restituisce l'elenco dei voli che partono in giornata e la raggiungono (circa 5000 volte al giorno)

5. **ricerca_voli_odierni**
    - Restituisce l'elenco dei voli in partenza in giornata (5000 volte al giorno) 

6. **elimina_volo**
    - Dato un volo, lo elimina per sempre (2 volte al giorno)

7. **Inserisci_volo**
    - Inserisce un volo nel database (2 volte al giorno)

<br>

_**Operazioni complesse**_

8. **Steward_Aerei_Pesanti**
    - Il numero di steward che lavorano su voli che fanno tratte con aerei con peso almeno X e al massimo Y (operazione svolta 10 volte al giorno)

9. **Aerei_Di_Linea**
    - Gli aerei con "_persone_max_" minimo comandati da piloti con età compresa fra 30 e 60 inclusi (10 volte al giorno)

10. **Piloti_Cargo**
    - I piloti che comandano aerei con "carico_max" superiore a X e con un numero di assistenti inferiore a Y (10 volte al giorno)


## 2 Progettazione concettuale

[//]: # (TODO: Forse sarebbe il caso di spendere due parole sulla strategia adoperata [top down, bottom up, inside out, mista])

### 2.1 Schema Entità-Relazioni

#### Prima proposta
![Schema ER prototipo](schemi/SchemaER_proposta_aereo.png)

La proposta iniziale del nostro schema Entità Relazione (ER) prevedeva la suddivisione delle caratteristiche dell'aeromobile in tre entità separate, con l'obiettivo di conferire al modello una maggiore modularità. Tuttavia, abbiamo rapidamente constatato che questa approccio comportava un'eccessiva complessità dello schema, spingendoci a riconsiderare la progettazione.

Di conseguenza, abbiamo deciso di semplificare lo schema, eliminando la suddivisione delle caratteristiche dell'aeromobile in entità distinte. Invece, abbiamo scelto di collegare direttamente le entità "Azienda Costruttrice" e "Carico" all'entità "Aeromobile" come attributi. Questa decisione è stata presa al fine di razionalizzare la struttura complessiva dello schema, riducendo la complessità e facilitando la comprensione del modello dati.

#### Schema concettuale finale
![Schema ER finale](schemi/SchemaER_schema_finale.png)


[//]: # (TODO: prima di passare oltre bisogna svolgere l'analisi di qualita' [correttezza, completezza, leggibilita', minimalita'] [libro pag.214])

[//]: # (TODO: Bisogna descrivere le regole aziendali ed eventuali vincoli non espressi direttamente dallo schema)



## 3 Progettazione logica

[//]: # (TODO: Da rivedere questa prima parte)

#### Vincoli d'integrità

##### RV1 **Equipaggio non eccede persone_max**
In ogni il numero di persone che compone l'equipaggio deve essere minore o uguale al numero massimo di persone trasportabili dall'aeromobile.

##### RV2 **Cardinalità hostess-steward**
L'entità "EQUIPAGGIO" deve avere almeno uno fra hostess e steward.

[//]: # (TODO: bisogna verificare se ci sono altri vincoli di integrita')

#### Dizionario dei dati
|   Entità   | Descrizione                                            |                                        Attributi                                        |       Identificatore       |
|:----------:|:-------------------------------------------------------|:---------------------------------------------------------------------------------------:|:--------------------------:|
|    Volo    | Volo che parte ogni giorno alla stessa ora             |                     ora, destinazione, gate, _capacità\_passeggeri_                     |         gate, ora          |
| Aeromobile | Aeromobile coinvolto nel volo                          |                                      id_assistente                                      |       id_assistente        |
|  Modello   | Modello specifico dell'aeromobile                      | name, azienda, carico_max, persone_max, spec_tecniche (peso, lunghezza, apertura_alare) | nome, azienda_costruttrice |
| Equipaggio | Equipaggio che imbarca l'aeromobile                    |                                      id_equipaggio                                      |       id_equipaggio        |
|   Pilota   | Piloti che pilotano l'aeromobile                       |                                        id_pilota                                        |         id_pilota          |
| Assistente | Assistente (steward e/o hostess) che assistono il volo |                                      id_assistente                                      |       id_assistente        |
|  Steward   | Assistente maschile                                    |                                            ~                                            |             ~              |
|  Hostess   | Assistente femminile                                   |                                            ~                                            |             ~              |

#### Tabella di cardinalità delle relazioni
|     E1     | Cardinalità |  Relazione  | Cardinalità |     E2     |
|:----------:|:-----------:|:-----------:|:-----------:|:----------:|
|    Volo    |    (1,1)    | **Imbarca** |    (1,1)    | Equipaggio |
| Aeromobile |    (1,1)    | **Tratta**  |    (1,1)    |    Volo    |
| Aeromobile |    (1,1)    |   **Di**    |    (1,n)    |  Modello   |
|   Pilota   |    (1,1)    | **Comanda** |    (2,2)    | Equipaggio |
| Assistente |    (1,1)    | **Compone** |    (1,n)    | Equipaggio |

#### Regole di derivazione

##### RD1 **capacità passeggeri**
L'attributo descrive la capacità massima di passeggeri imbarcabili da un aeromobile.
Di un volo, si ricerca il modello dell'aeromobile, e _capacità passeggeri_ viene derivato in base all'attributo _persone_max_ di MODELLO meno numero di persone nell'equipaggio.
**capacità_passeggeri** = **MODELLO**(_persone_max_)- |nr. assistenti|


### 2.3 Tabella dei volumi
|  Concetto  |   Tipo    | Volume |
|:----------:|:---------:|:------:|
| Aeromobile |  Entità   |   20   |
| Assistente |  Entità   |   80   |
| Equipaggio |  Entità   |   20   |
|  Modello   |  Entità   |   10   |
|   Pilota   |  Entità   |   40   |
|    Volo    |  Entità   |   20   |
|  Comanda   | Relazione |   40   |
|  Compone   | Relazione |   80   |
|     Di     | Relazione |   20   |
|  Imbarca   | Relazione |   20   |
|   Tratta   | Relazione |   20   |


### 2.4 Tabella delle frequenze
| Operazione                 | Tipo        | Frequenza (giornaliera) |
|:---------------------------|-------------|:-----------------------:|
| Cambio Gate                | Interattiva |            2            |
| Cambio Aereo               | Interattiva |            2            |
| Ricerca Voli(gate)         | Interattiva |          1000           |
| Ricerca Voli(Destinazione) | Interattiva |          5000           |
| Ricerca Voli Odierni       | Interattiva |          5000           |
| Elimina Volo               | Interattiva |            2            |
| Inserisci Volo             | Interattiva |            2            |
| N° Steward Aerei Pesanti   | Interattiva |           10            |
| Aerei di Linea             | Interattiva |           10            |
| Piloti Cargo               | Interattiva |           10            |

[//]: # (TODO: Sarebbe il caso di trovare una funzione che non sia interattiva ma che sia batch [libro pag.233] )





### 3.1 Analisi di ridondanza

[//]: # (TODO: discutere sul modo migliore per rappresentare le formule e altro dell'analisi di ridondanza)
[Analisi di ridondanza docs](https://docs.google.com/document/d/1nhvOKPnkAEypN998Kzv5q8iw8WVj2o3czqGw2cCtgTw/edit?usp=sharing)

Osservando lo schema della base di dati si nota come l'attributo "capacità_passeggeri" associato all'entità "VOLO", possa essere derivabile. Per valutare se convenga mantenere la ridondanza del dato, è stata condotta un'analisi di ridondanza.

#### Scenari

**Attributo derivato mantenuto**: il calcolo della capacità passeggeri avviene ogni volta che viene inserito un nuovo volo nella base di dati. Tuttavia, ogni successiva richiesta di capacità passeggeri verrà’ eseguita in tempo costante con una singola lettura.

**Senza attributo derivato**: l'inserimento dei voli è rapido e avviene in tempo costante. Tuttavia, la richiesta di capacità passeggeri comporta il suo ricalcolo ogni volta, incidendo sulla velocità di risposta.

#### Operazioni
Le due operazioni prese in esame:

**Operazione 1 (OP1)**: Inserimento di un nuovo volo nella base di dati.
**Operazione 2 (OP2)**: Richiesta del numero di passeggeri che possono imbarcarsi su un dato volo.

#### Volumi
Durante il calcolo, è essenziale considerare anche il numero medio di assistenti per ogni volo. Consultando la tabella dei volumi, si nota che vengono svolti 20 voli in una giornata e gli assistenti che vengono imbarcati sono 80, ciò implica una media di 4 assistenti per volo.

$n= \frac{assistenti}{voli}= \frac{80}{20}=4$

Ulteriori dati relativi ai volumi utilizzati nei calcoli sono registrati nella tabella apposita.

#### Frequenze
Il numero delle frequenze giornaliere con le quali vengono svolte le operazioni deve essere anch'esso ragionevole. In questo caso si è ipotizzato l'inserimento di 5 voli al giorno e la richiesta dell'attributo 50 volte al giorno.

- $freq(OP1)=5$ (vengono inseriti 5 voli al giorno)
- $freq(OP2)=50$  (vengono fatte 50 richieste al giorno)

#### Costi di lettura e scrittura
Supponendo che la lettura del nostro database implichi una spesa pari alla metà di quella necessaria per una scrittura, i costi relativi sono:

- $(read) 1R=1\mu$ 
- $(write) 1W =2\mu$ 


#### Analisi dei costi

##### Costo operazioni con ridondanza



Nel contesto dello scenario che prevede l'utilizzo dell'attributo derivato, il costo per le due operazioni è così definito:

$
\begin{cases} 
cost(OP1CR)&=1W+2R+1R+2R+nR \\
cost(OP2CR)&=1R
\end{cases}
$

L'operazione $OP1_{CR}$ ha un costo iniziale di 1W, derivante dalla scrittura di un nuovo volo nella tabella "volo". 
Successivamente, l'operazione effettua due letture per ottenere la capacità massima di persone del modello di aeromobile associato a quel volo. Queste letture coinvolgono la tabella "aeromobile" e successivamente la tabella "modello". 
Infine, l'operazione conta il numero del personale che compone l'equipaggio, leggendo la tabella “equipaggio”, dove conta 2 piloti e $n$ assistenti.

L'operazione $OP2_{CR}$ ha un costo molto basso poiché legge direttamente l'attributo derivato presente nella tabella "voli".

Il costo totale nel caso in cui è mantenuta la ridondanza risulta quindi: 

$
\begin{equation}
\begin{aligned}
TOT_1 &=freq(OP1)cost(OP1_{CR})+freq(OP2)cost(OP2_{CR}) \\
&=5(1W+5R+nR)+50(1R) \\
&=5(2+5+4)+50(1) \\
&=10+25+20 +50 \\
&=105\mu \\
\end{aligned}
\end{equation}
$

##### Costo operazioni senza ridondanza

Nel contesto dello scenario in cui non si fa uso dell'attributo derivato, il costo per le due operazioni è il seguente:

$
\begin{cases}
cost(OP1SR)=1W \\
cost(OP2SR)=2R+1R+2R+nR
\end{cases}
$


In questo caso, si nota che $OP1_{SR}$  ha un costo di 1W, dovuto alla scrittura del volo nella tabella "volo".

L'operazione $OP2_{SR}$, al contrario, deve contare il numero del personale che compone l'equipaggio, seguendo lo stesso processo descritto nel caso con ridondanza.

Il costo totale nel caso in cui viene eliminata la ridondanza risulta quindi:
$
\begin{equation}
\begin{aligned}
TOT_2&=freq(OP1)cost(OP1SR)+freq(OP2)cost(OP2SR)\\ 
&=5(1W)+50(2R+1R+2R+nR) \\
&=5(2)+50(5+4)=10+250+200\\
&=460\mu\\
\end{aligned}
\end{equation}
$

#### Conclusione analisi ridondanza
Dai calcoli effettuati, possiamo dedurre che in una giornata in cui vengono rispettate le frequenze assegnate, ovvero $freq(OP1)=5$ e $freq(OP2)=50$, risulta vantaggioso utilizzare l'approccio con ridondanza, in quanto abbatte il costo a circa un quarto del tempo utilizzato altrimenti.
Mantenere il dato comporta un costo finale di $105 \mu$ (vedi $EQ.1$),mentre ricavarlo ogni volta costa $460 \mu$ (vedi $EQ.2$).

#### Predizioni
[//]: # (NOTE: aggiungi i grafici)

[//]: # (NOTE: https://users.dimi.uniud.it/~luca.geatti/data/courses/2023/bdd-lab2023/atzeni_6e_slide_cap7.pptx)


### 3.2 Ristrutturazione dello schema E-R
In questa fase della relazione discuteremo di come abbiamo modificato lo schema concettuale proposto, reiterando le parti di schema che non possono essere tradotte direttamente nello schema relazionale.

[//]: # (TODO: L'analisi di ridondanza potrebbe essere inseirta qui)


#### Assistente dell'equipaggio
![Schema ER finale](schemi/SchemaER_reificazione_assistente.png)

Nel contesto dello schema Entity-Relationship (ER), è emersa la necessità di trattare una specializzazione di "assistente" attraverso le entità HOSTESS e STEWARD. Tuttavia, la trasposizione diretta di questa specializzazione in uno schema relazionale non è praticabile. Pertanto, si è optato per una connessione diretta delle entità HOSTESS e STEWARD all'entità EQUIPAGGIO.

Tuttavia, questa scelta di modellazione comporta la perdita del vincolo precedentemente espresso dalla generalizzazione, il quale garantiva che ogni istanza di EQUIPAGGIO dovesse includere almeno un'istanza tra HOSTESS e STEWARD. Al fine di preservare tale vincolo nell'ambito dello schema relazionale, si è reso necessario introdurre un vincolo d'integrità esterno.

**Vincolo d'integrità esterno**: ogni istanza di EQUIPAGGIO dovesse includere almeno un'istanza tra HOSTESS e STEWARD


#### Modello di aeromobile
![Schema ER finale](schemi/SchemaER_reificazione_modello.png)

Per risolvere l'attributo composto denominato "specifiche tecniche", il quale raggruppava gli attributi "peso", "lunghezza" ed "apertura alare", si è deciso d'introdurre un'entità dedicata denominata "SPECIFICHE TECNICHE".

La creazione di tale entità permette di gestire in modo più flessibile e strutturato le informazioni relative alle specifiche tecniche.

Le due entità MODELLO e SPEC. TEC. sono in relazione one-to-many. Questa relazione è stata implementata per riflettere il fatto che un insieme di specifiche tecniche può essere associato a più modelli, mentre ciascun modello è collegato a un unico insieme di specifiche tecniche.

#### Lo schema dopo la revisione
![Schema ER finale reificato](schemi/SchemaER_reificazione_finale.png)

### 3.3 Schema relazionale   

HOSTESS($\underline{CF}$, id_equipaggio)

|                  | key |  type  | unique |   null   |
|:----------------:|:---:|:------:|:------:|:--------:|
| $\underline{CF}$ | PK  | sTRING | UNIQUE | NOT NULL |
|  id_equipaggio   | FK  | STRING |        | NOT NULL |

STEWARD($\underline{CF}$, id_equipaggio)

|                  | key |  type  | unique |   null   |
|:----------------:|:---:|:------:|:------:|:--------:|
| $\underline{CF}$ | PK  | STRING | UNIQUE | NOT NULL |
|  id_equipaggio   | FK  | STRING |        | NOT NULL |

EQUIPAGGIO($\underline{id \_ equipaggio}$, pilota1, pilota2 )

|                                | key |  type  | unique |   null   |
|:------------------------------:|:---:|:------:|:------:|:--------:|
| $\underline{id \_ equipaggio}$ | PK  | STRING | UNIQUE | NOT NULL |
|            pilota1             | FK  | STRING | UNIQUE | NOT NULL |
|            pilota2             | FK  | STRING | UNIQUE | NOT NULL |

Vincolo: pilota1 e pilota2 sono diversi 

PILOTA($\underline{CF}$, età)

|                  | key |  type  | unique |   null   |
|:----------------:|:---:|:------:|:------:|:--------:|
| $\underline{CF}$ | PK  | STRING | UNIQUE | NOT NULL |
|       età        | ATT |  INT   |        |          |


VOLO($\underline{gate}$, $\underline{ora}$, destinazione, capacità, id_aereo, id_equipaggio)

|                    | key |  type  | unique |   null   |
|:------------------:|:---:|:------:|:------:|:--------:|
| $\underline{gate}$ | PK  |  INT   |        | NOT NULL |
| $\underline{ora}$  | PK  | STRING |        | NOT NULL |
|    destinazione    | ATT | STRING |        | NOT NULL |
|      capacità      | ATT |  INT   |        | NOT NULL |
|      id_aereo      | FK  | STRING | UNIQUE | NOT NULL |
|   id_equipaggio    | FK  | STRING | UNIQUE | NOT NULL |

AEROMOBILE($\underline{id \_ aereo}$, nome_modello, azienda)

|                           | key |  type  | unique |   null   |
|:-------------------------:|:---:|:------:|:------:|:--------:|
| $\underline{id \_ aereo}$ | PK  | STRING | UNIQUE | NOT NULL |
|       nome_modello        | FK  | STRING |        | NOT NULL |
|          azienda          | FK  | STRING |        | NOT NULL |

MODELLO($\underline{nome\_ modello}$, $\underline{azienda}$, peso, apertura_alare, lunghezza, carico_max, persone_max)

|                              | key |  type  | unique |   null   |
|:----------------------------:|:---:|:------:|:------:|:--------:|
| $\underline{nome\_ modello}$ | PK  | STRING |        | NOT NULL |
|    $\underline{azienda}$     | PK  | STRING |        | NOT NULL |
|             peso             | FK  |  INT   |        | NOT NULL |
|        apertura_alare        | FK  |  INT   |        | NOT NULL |
|          lunghezza           | FK  |  INT   |        | NOT NULL |
|          carico_max          | ATT |  INT   |        | NOT NULL |
|         persone_max          | ATT |  INT   |        | NOT NULL |

SPECIFICHE_TECNICHE($\underline{peso}$, $\underline{apertura \_ alare}$, $\underline{lunghezza}$)

|                                 | key | type | unique |   null   |
|:-------------------------------:|:---:|:----:|:------:|:--------:|
|        \underline{peso}$        | PK  | INT  |        | NOT NULL |
| $\underline{apertura \_ alare}$ | PK  | INT  |        | NOT NULL |
|     $\underline{lunghezza}$     | PK  | INT  |        | NOT NULL |

### 3.4 Vincoli di dominio 

1. **VOLO**

|        Ora         |      Gate      | Destinazione |
|:------------------:|:--------------:|:------------:|
| [0, 60 $\cdot$ 24] | [1, max_gates] |      ~       |

2. **MODELLO**

| Nome_modello | Azienda_costruttrice | Persone_max | Carico_max | Peso  | Lunghezza | Apertura_alare |
|:------------:|:--------------------:|:-----------:|:----------:|:-----:|:---------:|:--------------:|
|      ~       |          ~           |   x >= 3    |   x > 0    | x > 0 |   x > 0   |     x > 0      |


# Domande
- Come fare lo schema relazionale? (tabelle?)
- Sinonimi nel glossario possono essere tolti?
- Come decidiamo di scrivere la relazione? Word? md?



 
