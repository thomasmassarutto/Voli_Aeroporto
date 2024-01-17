HOSTESS(<u>codice_fiscale</u>, id_equipaggio)

|                       | key |  type  | unique |   null   |
|:---------------------:|:---:|:------:|:------:|:--------:|
| <u>codice_fiscale</u> | PK  | STRING | UNIQUE | NOT NULL |
|     id_equipaggio     | FK  | STRING |        | NOT NULL |

STEWARD(<u>codice_fiscale</u>, id_equipaggio)

|                       | key |  type  | unique |   null   |
|:---------------------:|:---:|:------:|:------:|:--------:|
| <u>codice_fiscale</u> | PK  | STRING | UNIQUE | NOT NULL |
|     id_equipaggio     | FK  | STRING |        | NOT NULL |

EQUIPAGGIO(<u>id_equipaggio</u>, pilota1, pilota2 )

|                      | key |  type  | unique |   null   |
|:--------------------:|:---:|:------:|:------:|:--------:|
| <u>id_equipaggio</u> | PK  | STRING | UNIQUE | NOT NULL |
|       pilota1        | FK  | STRING | UNIQUE | NOT NULL |
|       pilota2        | FK  | STRING | UNIQUE | NOT NULL |

Vincolo: pilota1 e pilota2 sono diversi

[//]: # (TODO: Questo vincolo va rivisto)


PILOTA(<u>codice_fiscale</u>, età)

|                       | key |  type  | unique |   null   |
|:---------------------:|:---:|:------:|:------:|:--------:|
| <u>codice_fiscale</u> | PK  | STRING | UNIQUE | NOT NULL |
|          età          | ATT |  INT   |        |          |


VOLO(<u>gate</u>, <u>ora</u>, destinazione, capacità_passeggeri, id_aereo, id_equipaggio)

|                     | key |  type  | unique |   null   |
|:-------------------:|:---:|:------:|:------:|:--------:|
|     <u>gate</u>     | PK  |  INT   | UNIQUE | NOT NULL |
|     <u>ora</u>      | PK  | STRING | UNIQUE | NOT NULL |
|    destinazione     | ATT | STRING |        | NOT NULL |
| capacità_passeggeri | ATT |  INT   |        | NOT NULL |
|      id_aereo       | FK  | STRING | UNIQUE | NOT NULL |
|    id_equipaggio    | FK  | STRING | UNIQUE | NOT NULL |

AEROMOBILE(<u>id_aereo</u>, nome_modello, azienda_costruttrice)

|                 | key |  type  | unique |   null   |
|:---------------:|:---:|:------:|:------:|:--------:|
| <u>id_aereo</u> | PK  | STRING | UNIQUE | NOT NULL |
|  nome_modello   | FK  | STRING |        | NOT NULL |
|     azienda     | FK  | STRING |        | NOT NULL |

MODELLO(<u>nome_modello</u>, <u>azienda_costruttrice</u>, carico_max, persone_max, peso, apertura_alare, lunghezza)

|                             | key |  type  | unique |   null   |
|:---------------------------:|:---:|:------:|:------:|:--------:|
|     <u>nome_modello</u>     | PK  | STRING | UNIQUE | NOT NULL |
| <u>azienda_costruttrice</u> | PK  | STRING | UNIQUE | NOT NULL |
|         carico_max          | ATT |  INT   |        | NOT NULL |
|         persone_max         | ATT |  INT   |        | NOT NULL |
|            peso             | FK  |  INT   |        | NOT NULL |
|       apertura_alare        | FK  |  INT   |        | NOT NULL |
|          lunghezza          | FK  |  INT   |        | NOT NULL |


SPECIFICHE_TECNICHE(<u>peso</u>, <u>apertura_alare</u>, <u>lunghezza</u>)

|                       | key | type | unique |   null   |
|:---------------------:|:---:|:----:|:------:|:--------:|
|      <u>peso</u>      | PK  | INT  | UNIQUE | NOT NULL |
| <u>apertura_alare</u> | PK  | INT  | UNIQUE | NOT NULL |
|   <u>lunghezza</u>    | PK  | INT  | UNIQUE | NOT NULL |
