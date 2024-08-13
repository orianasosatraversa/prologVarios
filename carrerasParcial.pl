/* El Kioskito */


/* Punto 1 */

atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).

atiende(lucas, martes, 10, 20).

atiende(juanC, sabados, 18, 22).
atiende(juanC, domingos, 18, 22).

atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).

atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).

atiende(martu, miercoles, 23, 24).

atiende(vale, Dia, HorarioInicio, HorarioFinal):-
    atiende(dodain, Dia, HorarioInicio, HorarioFinal).
atiende(vale, Dia, HorarioInicio, HorarioFinal):-
    atiende(juanC, Dia, HorarioInicio, HorarioFinal).

/* Punto 2 */

quienAtiende(Persona, Dia, Horario):-
    atiende(Persona, Dia, Inicio, Fin),
    Horario >= Inicio,
    Horario < Fin.


/* Forever Alone */

foreverAlone(Persona, Dia, Horario):-
    quienAtiende(Persona, Dia, Horario),
    not((quienAtiende(Otra, Dia, Horario), Persona \= Otra)).


/* Punto 4: posibilidades de atención (3 puntos / 1 punto) */

/* Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día. Por ejemplo, si preguntamos por el miércoles, tiene que darnos esta combinatoria: */

/* darnos esta combinatoria:
nadie
dodain solo
dodain y leoC
dodain, vale, martu y leoC
vale y martu
etc.
 */

% Regla principal para obtener todas las combinaciones posibles de personas atendiendo
posibilidadesDeAtencion(Dia, Combinacion):-
    findall(Persona, (atiende(Persona, Dia, _, _)), Personas),
    combinaciones(Personas, Combinacion).

% Regla para generar combinaciones
combinaciones([], []).
combinaciones([Persona|Personas], [Persona|Combinacion]):-
    combinaciones(Personas, Combinacion).
combinaciones([_|Personas], Combinacion):-
    combinaciones(Personas, Combinacion).

% Qué conceptos en conjunto resuelven este requerimiento
% - findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
% - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles


/* Punto 5 */

/* golosina(Valor).
cigarrillos(Marcas).
bebidas(TieneAlcohol, Cantidad).

ventas(Persona, Dia, Numero, Mes, Ventas). */

venta(dodain, fecha(10, 8), [golosinas(1200), cigarrillos(jockey), golosinas(50)]).
% dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 
% 1 bebida no-alcohólica, golosinas por $ 10
venta(dodain, fecha(12, 8), [bebidas(true, 8), bebidas(false, 1), golosinas(10)]).
% martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.
venta(martu, fecha(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
% lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
venta(lucas, fecha(11, 8), [golosinas(600)]).
% lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.
venta(lucas, fecha(18, 8), [bebidas(false, 2), cigarrillos([derby])]).

personaSuertuda(Persona):-
    vendedora(Persona),
    forall(venta(Persona, _, [Venta|_]), ventaImportante(Venta)).
  
  vendedora(Persona):-
    venta(Persona, _, _).
  
  ventaImportante(golosinas(Precio)):-
    Precio > 100.

  ventaImportante(cigarrillos(Marcas)):-
    length(Marcas, Cantidad), Cantidad > 2.

  ventaImportante(bebidas(true, _)).

  ventaImportante(bebidas(_, Cantidad)):-
    Cantidad > 5.

:- begin_tests(elKiosco).

test(quien_atiende_lunes_14, nondet):-
    quienAtiende(Persona, lunes, 14),
    Persona = dodain.
test(quien_atiende_lunes_14, nondet):-
    quienAtiende(Persona, lunes, 14),
    Persona = leoC.
test(quien_atiende_lunes_14, nondet):-
    quienAtiende(Persona, lunes, 14),
    Persona = vale.

/* test(quien_atiende_sabado_18, nondet):-
    quienAtiende(Persona, sabado, 18),
    Persona = juanC.
test(quien_atiende_sabado_18, nondet):-
    quienAtiende(Persona, sabado, 18),
    Persona = vale. */

test(juanFds_atiende_jueves_11, nondet):-
    quienAtiende(juanFdS, jueves, 11).

test(vale_atiende_dias_10,nondet):-
    quienAtiende(vale, Dia, 10),
    Dia = lunes.
test(vale_atiende_dias_10,nondet):-
    quienAtiende(vale, Dia, 10),
    Dia = miercoles.

test(lucas_forever_alone_martes_19, nondet):-
    foreverAlone(lucas, martes, 19).

test(juanFdS_forever_alone_jueves_10, nondet):-
    foreverAlone(juanFdS, jueves, 10).

test(martu_forever_alone_miercoles_22, fail):-
    foreverAlone(martu, miercoles, 22).

test(martu_forever_alone_miercoles_23, nondet):-
    foreverAlone(martu, miercoles, 23).

test(dodain_no_forever_alone_lunes_10, fail):-
    foreverAlone(dodain, lunes, 10).

:- end_tests(elKiosco).

