herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(ordenarCuarto, [escoba, trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).


/* Punto 1 */

tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

/* Punto 2 */

tieneHerramienta(Persona, Herramienta):-
    tiene(Persona, Herramienta).

tieneHerramienta(Persona, aspiradora(Potencia)):-
    tiene(Persona, aspiradora(Real)),
    Real >= Potencia.

    
/* Punto 3 */

puedeRealizarTarea(Persona, Tarea):-
    herramientasRequeridas(Tarea, _),
    tiene(Persona, varitaDeNeutrones).

puedeRealizarTarea(Persona, Tarea):-
    herramientasRequeridas(Tarea, Requisitos),
    tiene(Persona, _),
    forall(member(Requisito, Requisitos), tieneHerramienta(Persona, Requisito)).

/* Punto 4 */

/* tareaPedida(Cliente, Tarea, Metros).
precio(Tarea, PrecioXm2). */

tareaPedida(pepito, ordenarCuarto, 10).
tareaPedida(pepito, limpiarTecho, 100).
tareaPedida(pepito, encerarPisos, 200).
precio(ordenarCuarto, 50).
precio(limpiarTecho,10).
precio(cortarPasto,20).
precio(limpiarBanio,30).
precio(encerarPisos,5).


aCobrar(Cliente, Tarea, Metros, Total):-
    tareaPedida(Cliente, Tarea, Metros),
    precio(Tarea, Precio),
    Total is Precio * Metros.

totalAcobrar(Cliente, PrecioFinal):-
    tareaPedida(Cliente, _, _),
    findall(Total, aCobrar(Cliente, _, _, Total), ListaTotales),
    sum_list(ListaTotales, PrecioFinal).

/* Punto 5 */

aceptariaPedido(Persona, Cliente):-
    tiene(Persona, _),
    tareaPedida(Cliente, _, _),
    forall(tareaPedida(Cliente, Tarea, _), puedeRealizarTarea(Persona, Tarea)),
    estaDispuesto(Persona, Cliente).

estaDispuesto(ray, Cliente):-
    forall(tareaPedida(Cliente, Tarea, _), Tarea \= limpiarTecho).

estaDispuesto(winston, Cliente):-
    totalAcobrar(Cliente, PrecioFinal),
    PrecioFinal > 500.
    /* pedidos que paguen mas de 500 */

estaDispuesto(egon, Cliente):-
    /* Egon está dispuesto a aceptar pedidos que no tengan tareas complejas */
    not(tareaCompleja(Cliente)).

estaDispuesto(peter, _).

tareaCompleja(Cliente):-
    forall(tareaPedida(Cliente, Tarea, _),not(Tarea \= limpiarTecho)).

tareaCompleja(Cliente):-
    tareaPedida(Cliente, Tarea, _),
    herramientasRequeridas(Tarea, Requisitos).
    findall(Requisito, member(Requisito, Requisitos), TotalRequisitos),
    TotalRequisitos > 2.
    /*   si requiere más de dos herramientas.  */        


/* Punto 6 */

/* Necesitamos agregar la posibilidad de tener herramientas reemplazables, que incluyan 2 herramientas de las que pueden tener los integrantes como alternativas, para que puedan usarse como un requerimiento para poder llevar a cabo una tarea.
Mostrar cómo modelarías este nuevo tipo de información modificando el hecho de herramientasRequeridas/2 para que ordenar un cuarto pueda realizarse tanto con una aspiradora de 100 de potencia como con una escoba, además del trapeador y el plumero que ya eran necesarios.
Realizar los cambios/agregados necesarios a los predicados definidos en los puntos anteriores para que se soporten estos nuevos requerimientos de herramientas para poder llevar a cabo una tarea, teniendo en cuenta que para las herramientas reemplazables alcanza con que el integrante satisfaga la necesidad de alguna de las herramientas indicadas para cumplir dicho requerimiento.
Explicar a qué se debe que esto sea difícil o fácil de incorporar.
 */



/* Tests */

:- begin_tests(tests_tp1).
test(egon_tiene_aspiradora_200, nondet):-
    tieneHerramienta(egon, aspiradora(200)).
test(egon_tiene_aspiradora_100, nondet):-
    tieneHerramienta(egon, aspiradora(100)).
test(egon_tiene_trapeador, nondet):-
    tieneHerramienta(egon, trapeador).
test(peter_tiene_trapeador, nondet):-
        tieneHerramienta(peter, trapeador).
test(winston_tiene_varita_de_neutrones, nondet):-
    tieneHerramienta(winston, varitaDeNeutrones).
test(winston_puede_realizar_tarea_ordenar_cuarto, nondet):-
    puedeRealizarTarea(winston, ordenarCuarto).
test(winston_puede_realizar_tarea_limpiar_techo, nondet):-
    puedeRealizarTarea(winston, limpiarTecho).
test(winston_puede_realizar_tarea_cortar_pasto, nondet):-
    puedeRealizarTarea(winston, cortarPasto).
test(winston_puede_realizar_tarea_limpiar_banio, nondet):-
    puedeRealizarTarea(winston, limpiarBanio).
test(winston_puede_realizar_tarea_encerar_pisos, nondet):-
    puedeRealizarTarea(winston, encerarPisos).
test(egon_puede_realizar_tarea_ordenar_cuarto, fail):-
    puedeRealizarTarea(egon, ordenarCuarto).
test(egon_puede_realizar_tarea_limpiar_techo, fail):-
    puedeRealizarTarea(egon, limpiarTecho).
test(egon_puede_realizar_tarea_cortar_pasto, fail):-
    puedeRealizarTarea(egon, cortarPasto).
test(egon_puede_realizar_tarea_limpiar_banio, fail):-
    puedeRealizarTarea(egon, limpiarBanio).
test(egon_puede_realizar_tarea_encerar_pisos, fail):-
    puedeRealizarTarea(egon, encerarPisos).
test(peter_puede_realizar_tarea_ordenar_cuarto, fail):-
    puedeRealizarTarea(peter, ordenarCuarto).
test(peter_puede_realizar_tarea_limpiar_techo, fail):-
    puedeRealizarTarea(peter, limpiarTecho).
test(peter_puede_realizar_tarea_cortar_pasto, fail):-
    puedeRealizarTarea(peter, cortarPasto).
test(peter_puede_realizar_tarea_limpiar_banio, fail):-
    puedeRealizarTarea(peter, limpiarBanio).
test(peter_puede_realizar_tarea_encerar_pisos, fail):-
    puedeRealizarTarea(peter, encerarPisos).
:- end_tests(tests_tp1).
