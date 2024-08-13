hombre(juan).
hombre(pedro).
hombre(jose).
mujer(maria).
mujer(ursula).
mujer(juana).

sereno(juan).
decidido(juan).
decidido(ursula).
melancolico(maria).
soniador(juana).
reflexivo(pedro).
melancolico(jose).


/* Punto a */

pareja(Mujer, Hombre):-
    mujer(Mujer),
    hombre(Hombre),
    melancolico(Mujer),
    sereno(Hombre).

pareja(Mujer, Hombre):-
    mujer(Mujer),
    hombre(Hombre),
    decidido(Mujer),
    reflexivo(Hombre).

pareja(Mujer, Hombre):-
    mujer(Mujer),
    hombre(Hombre),
    soniador(Mujer),
    decidido(Hombre).

/* Punto b */

pareja(Mujer, Hombre):-
    mujer(Mujer),
    hombre(Hombre),
    melancolico(Mujer),
    decidido(Hombre).

pareja(Mujer, Hombre):-
    mujer(Mujer),
    hombre(Hombre),
    melancolico(Hombre),
    decidido(Mujer).

esDeseable(Persona):-
    hombre(Persona),
    pareja(Mujer, Persona),
    pareja(Otra, Persona),
    Mujer \= Otra.

esDeseable(Persona):-
    mujer(Persona),
    pareja(Persona, Hombre),
    pareja(Persona, Otro),
    Hombre \= Otro.

:- begin_tests(agencia).
    test(mariayjuan_forman_pareja, nondet):-
        pareja(maria,juan).

    test(ursulayjuan_forman_pareja, fail):-
        pareja(ursula,juan).
:- end_tests(agencia).


