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