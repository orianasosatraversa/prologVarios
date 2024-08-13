padreDe(abe, abbie).
padreDe(abe, homero).
padreDe(abe, herbert).
padreDe(clancy, marge).
padreDe(clancy, patty).
padreDe(clancy, selma).
padreDe(homero, bart).
padreDe(homero, hugo).
padreDe(homero, lisa).
padreDe(homero, maggie).

madreDe(edwina, abbie).
madreDe(mona, homero).
madreDe(gaby, herbert).
madreDe(jacqueline, marge).
madreDe(jacqueline, patty).
madreDe(jacqueline, selma).
madreDe(marge, bart).
madreDe(marge, hugo).
madreDe(marge, lisa).
madreDe(marge,maggie).
madreDe(selma, ling).

tieneHijo(Persona):-
    (madreDe(Persona, Hijo);padreDe(Persona,Hijo)).

hermanos(Personaje, Otro):-
    madreDe(Madre, Personaje),
    madreDe(Madre, Otro),
    padreDe(Madre, Personaje),
    padreDe(Madre, Otro),
    Personaje \= Otro.

medioHermano(Persona,Otro):-
    padreDe(Padre,Persona),
    padreDe(OtroPadre,Otro),
    Padre \= OtroPadre,
    madreDe(Madre,Persona),
    madreDe(Madre,Otro),
    Persona \= Otro.

medioHermano(Persona,Otro):-
    padreDe(Padre,Persona),
    padreDe(Padre,Otro),
    madreDe(Madre,Persona),
    madreDe(OtraMadre,Otro),
    Madre \= OtraMadre,
    Persona \= Otro.
    
tioDe(Tio, Sobrino):-
    hermanos(Tio, Otro),
    madreDe(Otro, Sobrino),
    Tio \= Otro.

tioDe(Tio, Sobrino):-
    hermanos(Tio, Otro),
    padreDe(Otro, Sobrino),
    Tio \= Otro.

tioDe(Tio, Sobrino):-
    medioHermano(Tio, Otro),
    madreDe(Otro, Sobrino),
    Tio \= Otro.

tioDe(Tio, Sobrino):-
    medioHermano(Tio, Otro),
    padreDe(Otro, Sobrino),
    Tio \= Otro.

casadoCon(_, _). % Define casadoCon/2 predicate

tioDe(Tio,Sobrino):-
    casadoCon(Tio,Persona),
    (hermanos(Persona,Padre);medioHermano(Persona,Padre)),
    (padreDe(Padre,Sobrino);madreDe(Padre,Sobrino)).


abueloDe(Abuelo, Nieto):-
    (padreDe(Abuelo, Madre); madreDe(Abuelo, Madre)),
    (madreDe(Madre, Nieto); padreDe(Madre, Nieto)).

abuelosMultiples(Abuelo):-
    abueloDe(Abuelo, Nieto),
    abueloDe(Abuelo, Otro),
    Nieto \= Otro.



descendienteDe(Persona,OtraPersona):-(
    padreDe(Persona,OtraPersona);madreDe(Persona,OtraPersona)).

descendienteDe(Persona,OtraPersona):- 
    (padreDe(Persona,P1);madreDe(Persona,P1)),
    descendienteDe(P1,OtraPersona). 