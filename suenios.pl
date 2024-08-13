/* Punto 1 */

/* Base de Conocimiento */

creencia(gabriel, [campanita, elMagoDeOz, cavenaghi]).
creencia(juan, [conejoDePascua]).
creencia(macarena, [reyesMagos, magoCapria, campanita]).
creencia(diego, []).

/* Suenio(Persona, cantante(Cantidad)).
Suenio(Persona, futbolista(Equipo)).
Suenio(Persona, ganarLoteria(Serie)).
 */

suenio(gabriel, ganarLoteria([5,9])).
suenio(gabriel, futbolista(arsenal)).
suenio(juan, cantante(100000)).


/* Macarena no quiere ganar la lotería, sí ser cantante estilo “Eruca Sativa” y vender 10.000 discos */
suenio(macarena, cantante(10000)).

/* Indicar qué conceptos entraron en juego para cada punto.
 */

/* Para realizar las creencias, se utilizo el concepto de listas para agrupar todas las creencias. Para realizar la base de conocimiento de los Suenios, utilice functores. Ademas, al realizar el Suenio de Macarena, se utilizo el principio de Univeerso Cerrado, ya que la base de conocimientos compone el universo conocido, todo lo que esta por afuera no se puede probar que existe y se asume como falso */


/* Punto 2 */

/* Queremos saber si una persona es ambiciosa, esto ocurre cuando la suma de dificultades de los sueños es mayor a 20. La dificultad de cada sueño se calcula como
6 para ser un cantante que vende más de 500.000 ó 4 en caso contrario
ganar la lotería implica una dificultad de 10 * la cantidad de los números apostados
lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y Aldosivi son equipos chicos.

 */
esAmbicioso(Persona):-
    suenio(Persona, _),
    findall(Dificultad, (suenio(Persona, Suenio),dificultadSuenio(Suenio, Dificultad)), Dificultades),
    sum_list(Dificultades, TotalDificultades),
    TotalDificultades > 20.
    
dificultadSuenio(cantante(Cantidad), 6):-
    Cantidad > 500000.
dificultadSuenio(cantante(_), 4).
dificultadSuenio(ganarLoteria(Serie), Dificultad):-
    length(Serie, Largo),
    Dificultad is Largo * 10.

dificultadSuenio(futbolista(Club), 3):-
    esEquipoChico(Club).
dificultadSuenio(futbolista(_), 16).

esEquipoChico(arsenal).
esEquipoChico(aldosivi).


/* Punto 3 */


tieneQuimica(Persona, campanita):-
    creeEn(Persona, campanita),
    suenio(Persona, Suenio), 
    dificultadSuenio(Suenio, Dificultad),
    Dificultad < 5.

tieneQuimica(Persona, Personaje):-
    creeEn(Persona, Personaje),
    forall(suenio(Persona, Suenio), suenioPuro(Suenio)),
    not(esAmbicioso(Persona)),
    Personaje \= campanita.

creeEn(Persona, Personaje):-
    creencia(Persona, Creencia),
    member(Personaje, Creencia).


suenioPuro(cantante(Cantidad)):-
    Cantidad < 200000.

suenioPuro(futbolista(_)).


/* Punto 4 */

/* Sabemos que
Campanita es amiga de los Reyes Magos y del Conejo de Pascua
el Conejo de Pascua es amigo de Cavenaghi, entre otras amistades

Necesitamos definir si un personaje puede alegrar a una persona, esto ocurre
si una persona tiene algún sueño
el personaje tiene química con la persona y...
el personaje no está enfermo
o algún personaje de backup no está enfermo. Un personaje de backup es un amigo directo o indirecto del personaje principal

Debe evitar repetición de lógica.
El predicado debe ser totalmente inversible.
Debe considerar cualquier nivel de amistad posible (la solución debe ser general).
Suponiendo que Campanita, los Reyes Magos y el Conejo de Pascua están enfermos, 
el Mago Capria alegra a Macarena, ya que tiene química con ella y no está enfermo
Campanita alegra a Macarena; aunque está enferma es amiga del Conejo de Pascua, que aunque está enfermo es amigo de Cavenaghi que no está enfermo.
 */

amistades(campanita, [reyesMagos, conejoDePascua]).
amistades(conejoDePascua, [cavenaghi]).

puedeAlegrar(Personaje, Persona):-
    suenio(Persona, _).

puedeAlegrar(Personaje, Persona):-
    tieneQuimica(Persona, Personaje),
    not(estaEnfermo(Personaje)).

puedeAlegrar(Personaje, Persona):-
    amistades(Personaje, Amistades),
    tieneQuimica(Persona, Personaje),
    not(estaEnfermo(AmigoPersonaje)),
    member(AmigoPersonaje, Amistades).

puedeAlegrar(Personaje, Persona):-
    amistades(Personaje, Amistades),
    tieneQuimica(Persona, Personaje),
    not(estaEnfermo(AmigoPersonaje)),
    member(AmigoPersonaje, Amistades),
    puedeAlegrar(AmigoPersonaje, Persona).

estaEnfermo(campanita).

    


