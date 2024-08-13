
mago(harry, mestiza, [coraje, amistad, orgullo, inteligencia]).
mago(ron, pura, [amistad, diversion, coraje]).
mago(hermione, impura, [inteligencia, coraje, responsabilidad, amistad, orgullo]).
mago(hannahAbbott, mestiza, [amistad, diversion]).
mago(draco, pura, [inteligencia, orgullo]).
mago(lunaLovegood, mestiza, [inteligencia, responsabilidad, amistad, coraje]).
odia(harry,slytherin).
odia(draco,hufflepuff).
casa(gryffindor).
casa(hufflepuff).
casa(ravenclaw).
casa(slytherin).
caracteriza(gryffindor,amistad).
caracteriza(gryffindor,coraje).
caracteriza(slytherin,orgullo).
caracteriza(slytherin,inteligencia).
caracteriza(ravenclaw,inteligencia).
caracteriza(ravenclaw,responsabilidad).
caracteriza(hufflepuff,amistad).
caracteriza(hufflepuff,diversion).

/* Sombrero Seleccionador */

/* Punto 1 */

/* permiteEntrar/2 que relaciona a una casa con un mago. Este predicado se cumple para
cualquier mago y cualquier casa excepto en el caso de Slytherin, que no permite entrar a
magos de sangre impura. */

permiteEntrar(slytherin, Mago):-
    mago(Mago, _, _),
    not(mago(Mago, impura, _)).

permiteEntrar(Casa, _):-
    casa(Casa),
    Casa \= slytherin.

/* Punto 2 */

/* tieneCaracter/2 que relaciona a un mago y una casa si su carácter (lista de características)
incluye todo lo que caracteriza a esa casa. */

tieneCaracter(Mago, Casa):-
    mago(Mago, _, Caracteristicas),
    casa(Casa),
    forall(caracteriza(Casa, Caracteristica), member(Caracteristica, Caracteristicas)).


/* Punto 3 */

/* casaPosible/2 que relaciona a un mago con una casa en la cual podría quedar seleccionado.
Esto se cumple si el mago tiene el carácter adecuado para la casa, la casa permite su
entrada y además el mago no odia esa casa */

casaPosible(Mago, Casa):-
    tieneCaracter(Mago, Casa),
    permiteEntrar(Casa, Mago), 
    not(odia(Mago,Casa)).


/* Punto 4 */

/* cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos tienen la
característica amistad y cada uno podría estar en la misma casa que el siguiente. No hace
falta que sea inversible, se consultará de forma individual. */

/* ?- cadenaDeAmistades([hannahAbbott, ron, harry, hermione, lunaLovegood]).
Yes ?- cadenaDeAmistades([draco, harry, ron, hermione, lunaLovegood]).
No. */

cadenaDeAmistades(Magos):-
    amistosos(Magos),
    cadenaDeCasas(Magos).

amistosos(Magos):-
    forall(member(Mago, Magos), amistoso(Mago)).

amistoso(Mago):-
    mago(_, _, Caracteristicas),
    member(amistad, Caracteristicas).

cadenaDeCasas([_]).
cadenaDeCasas([Mago1, Mago2 | Magos]):-
    casaPosible(Mago1, Casa),
    casaPosible(Mago2, Casa),
    cadenaDeCasas([Mago2 | Magos]).

/* La copa de las casas */

lugarProhibido(bosque,50).
lugarProhibido(seccionRestringida,10).
lugarProhibido(tercerPiso,75).

alumnoFavorito(flitwick, hermione).
alumnoFavorito(snape, draco).
alumnoOdiado(snape, harry).

hizo(ron, buenaAccion(jugarAlAjedrez, 50)).
hizo(harry, fueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione, responder("Donde se encuentra un Bezoar", 15, snape)).
hizo(hermione, responder("Wingardium Leviosa", 25, flitwick)).
hizo(draco, responder("Wingardium Leviosa", 25, snape)).
hizo(ron, irA(bosque)).
hizo(draco, irA(mazmorras)).

/* esDe(Mago, Casa). */
esDe(hermione, gryffindor).
esDe(harry, gryffindor).
esDe(ron, gryffindor).
esDe(draco, slytherin).




/* Punto 5 */
/*  esBuenAlumno/1 que se verifica para un mago que hizo al menos una acción y ninguna de
las cosas que hizo provocó un puntaje negativo. */

esBuenAlumno(Mago):-
    hizo(Mago, buenaAccion(_,_)),
    not(hizo(Mago, irA(tercerPiso))),
    not(hizo(Mago, irA(bosque))),
    not(hizo(Mago, fueraDeCama)).

/* Punto 6 */

/* puntosDeCasa/2 que relaciona a una casa con el puntaje total que es la sumatoria de los
puntos obtenidos por los alumnos de esa cas  */

/* Los puntos que se tienen en cuenta para la copa de las casas son:
● respuestas correctas en clase: importa la dificultad de la pregunta y qué profesor la hizo. Los
puntos otorgados se corresponden con la dificultad de la pregunta, pero como algunos
profesores tienen alumnos favoritos y odiados, a los favoritos los premia el doble, a los
odiados no los premia.
● malas acciones: son andar de noche fuera de la cama (que resta 50 puntos) o ir a lugares
prohibidos como el bosque, la sección restringida de la biblioteca y el tercer piso. La cantidad
de puntos que se resta ir a un lugar prohibido se indica para el lugar. Ir a un lugar que no
está prohibido no afecta al puntaje.
● buenas acciones: son reconocidas por los profesores y prefectos individualmente (como
ganar un juego de ajedrez) y el puntaje se indica para la acción premiada. */

puntosDeCasa(Casa, PuntajeTotal):-
    findall(Puntaje, (esDe(Mago, Casa), hizo(Mago, Accion), puntaje(Accion, Puntaje)), Puntajes),
    sum_list(Puntajes, PuntajeTotal).


puntaje(responder(_, PuntajeBase, Profesor), Puntaje):-
    alumnoFavorito(Profesor, Mago),
    Puntaje is PuntajeBase * 2.

puntaje(responder(_, _, Profesor), 0):-
    alumnoOdiado(Profesor, Mago).

puntaje(responder(_, PuntajeBase, Profesor), PuntajeBase):-
    not(alumnoFavorito(Profesor, Mago)),
    not(alumnoOdiado(Profesor, Mago)).


puntaje(buenaAccion(_, Puntaje), Puntaje).

puntaje(irA(Lugar), Puntaje):-
    lugarProhibido(Lugar, PuntajeNegativo),
    Puntaje is (-PuntajeNegativo).

puntaje(fueraDeCama, -50).






/* 7. casaGanadora/1 que se verifica para aquella casa que haya obtenido una cantidad mayor de
puntos que todas las otras.
Suponiendo que los puntajes totales al terminar el año son:
1. Gryffindor: 482 puntos.
2. Slytherin: 472 puntos.
3. Ravenclaw: 426 puntos.
4. Hufflepuff: 352 puntos. */

puntosDeCasa(gryffindor, 482).
puntosDeCasa(slytherin, 472).
puntosDeCasa(ravenclaw, 426).
puntosDeCasa(hufflepuff, 352).


casaGanadora(Casa):-
    puntosDeCasa(Casa, Puntaje),
    forall((puntosDeCasa(OtraCasa, OtroPuntaje), Casa \= OtraCasa), Puntaje > OtroPuntaje).





/* Inicio de Tests */

:- begin_tests(tests_sombrero_seleccionador).

test(permiteEntrar_slytherin_hermione, fail):-
    permiteEntrar(slytherin, hermione).

test(tiene_caracter_harry_casa, nondet ):-
    tieneCaracter(harry, Casa),
    Casa = gryffindor.

test(tiene_caracter_harry_casa, nondet ):-
    tieneCaracter(harry, Casa),
    Casa = slytherin.

test(casa_posible_harry, nondet):-
    casaPosible(harry, Casa),
    Casa = gryffindor.

test(casa_posible_hermione, nondet):-
    casaPosible(hermione, Casa),
    Casa = gryffindor.

test(casa_posible_hermione, nondet):-
    casaPosible(hermione, Casa),
    Casa = ravenclaw.

test(cadena_de_amistades, nondet):-
    cadenaDeAmistades([hannahAbbott, ron, harry, hermione, lunaLovegood]).

test(cadena_de_amistades, fail):-
    cadenaDeAmistades([draco, harry, ron, hermione, lunaLovegood]).

:- end_tests(tests_sombrero_seleccionador).
