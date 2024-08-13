% Aquí va el código.


%Civilizaciones y tecnologías
    %1. Modelar lo necesario para representar los jugadores, las civilizaciones y las tecnologías, de la forma más conveniente para resolver los siguientes puntos. Incluir los siguientes ejemplos.

%jugador(Jugador).
%civilizacion(Civilizacion).
%tecnologia(Tecnologia).
%desarrollo(Jugador, Tecnologia).
%juegaCon(Jugador, Civilizacion).


jugador(ana).
jugador(beto).
jugador(carola).
jugador(dimitri).

civilizacion(romanos).
civilizacion(incas).

tecnologia(herreria).
tecnologia(forja).
tecnologia(emplumado).
tecnologia(laminas).
tecnologia(fundicion).

%a. Ana, que juega con los romanos y ya desarrolló las tecnología de herrería, forja, emplumado y láminas.

juegaCon(ana, romanos).
desarrollo(ana, herreria).
desarrollo(ana, forja).
desarrollo(ana, emplumado).
desarrollo(ana, laminas).

%b. Beto, que juega con los incas y ya desarrolló herrería, forja y fundición

juegaCon(beto, incas).
desarrollo(beto, herreria).
desarrollo(beto, forja).
desarrollo(beto, fundicion).

%c. Carola, que juega con los romanos y sólo desarrolló la herrería.

juegaCon(carola, romanos).
desarrollo(carola, herreria).

%d. Dimitri, que juega con los romanos y ya desarrolló herrería y fundición.

juegaCon(dimitri, romanos).
desarrollo(dimitri, herreria).
desarrollo(dimitri, fundicion).

%e. Elsa no juega esta partida.

%2. Saber si un jugador es experto en metales, que sucede cuando desarrolló las tecnologías de herrería, forja y o bien desarrolló fundición o bien juega con los romanos. En los ejemplos, Ana y Beto son expertos en metales, pero Carola y Dimitri no.

expertoEnMetales(Jugador):-
    desarrollo(Jugador, herreria),
    desarrollo(Jugador, forja),
    desarrollo(Jugador, fundicion).


expertoEnMetales(Jugador):-
        desarrollo(Jugador, herreria),
        desarrollo(Jugador, forja),
        juegaCon(Jugador, romanos).

%3. Saber si una civilización es popular, que se cumple cuando la eligen varios jugadores (más de uno). En los ejemplos, los romanos son una civilización popular, pero los incas no.

popular(Civilizacion):-
    juegaCon(Jugador, Civilizacion),
    juegaCon(Otro, Civilizacion),
    Jugador \= Otro.

%4. Saber si una tecnología tiene alcance global, que sucede cuando a nadie le falta desarrollarla.
%En los ejemplos, la herrería tiene alcance global, pues Ana, Beto, Carola y Dimitri la desarrollaron.

alcanceGlobal(Tecnologia):-
    tecnologia(Tecnologia),
    forall(jugador(Jugador), desarrollo(Jugador, Tecnologia)).


%5. Saber cuándo una civilización es líder. Se cumple cuando esa civilización alcanzó todas las
%tecnologías que alcanzaron las demás. Una civilización alcanzó una tecnología cuando algún jugador
%de esa civilización la desarrolló.
%En los ejemplos, los romanos son una civilización líder pues entre Ana y Dimitri, que juegan con romanos, ya tienen todas las tecnologías que se alcanzaron.

civilizacionLider(Civilizacion) :-
        civilizacion(Civilizacion),
        forall(tecnologia(Tecnologia), (juegaCon(Jugador, Civilizacion), desarrollo(Jugador, Tecnologia))).


%Unidades
% No se puede ganar la guerra sin soldados. Las unidades que existen son los campeones (con vida de 1 a 100), los jinetes (que los puede haber a caballo o a camello) y los piqueros, que tienen un nivel de 1 a 3, y pueden o no tener escudo.

%6. Modelar lo necesario para representar las distintas unidades de cada jugador de la forma más conveniente para resolver los siguientes puntos. Incluir los siguientes ejemplos:
        % Ana tiene un jinete a caballo, un piquero con escudo de nivel 1, y un piquero sin escudo de nivel 2.

unidad(ana, jinete(caballo)).
unidad(ana, piquero(con, 1)).
unidad(ana, piquero(sin, 2)).


        % Beto tiene un campeón de 100 de vida, otro de 80 de vida, un piquero con escudo nivel 1 y un jinete a camello.

unidad(beto, campeon(100)).
unidad(beto, campeon(80)).
unidad(beto, piquero(con, 1)).
unidad(beto, jinete(camello)).

        % Carola tiene un piquero sin escudo de nivel 3 y uno con escudo de nivel 2.

unidad(carola, piquero(sin, 3)).
unidad(carola, piquero(con, 2)).

        % Dimitri no tiene unidades.

           
%7. Conocer la unidad con más vida que tiene un jugador, teniendo en cuenta que:
        % Los jinetes a camello tienen 80 de vida y los jinetes a caballo tienen 90.
        % Cada campeón tiene una vida distinta.
        % Los piqueros sin escudo de nivel 1 tienen vida 50, los de nivel 2 tienen vida 65 y los de nivel 3 tienen 70 de vida.
        %Los piqueros con escudo tienen 10% más de vida que los piqueros sin escudo.

vida(jinete(camello), 80).
vida(jinete(caballo), 90).
vida(campeon(Vida), Vida).
vida(piquero(sin, 1), 50).
vida(piquero(sin, 2), 65).
vida(piquero(sin, 3), 70).
vida(piquero(con, 1), 55).
vida(piquero(con, 2), 71).
vida(piquero(con, 3), 77).

unidadConMasVidaDe(Jugador, Unidad) :-
        findall(vida(Vida, Unidad), (unidad(Jugador, Unidad), vida(Unidad, Vida)), VidasUnidades),
        max_member(vida(VidaMaxima, Unidad), VidasUnidades).
         
/* Punto 8 */

ganaUnidad(jinete(_), campeon(_)).
ganaUnidad(campeon(_), piquero(_, _)).
ganaUnidad(piquero(_, _), jinete(_)).
ganaUnidad(jinete(camello), jinete(caballo)).

ganaUnidad(Unidad, Otra):-
    vida(Unidad, Vida),
    vida(Otra, OtraVida),
    Vida > OtraVida.

/* Punto 9 */

sobreviveAsedio(Jugador):-
        unidad(Jugador, _),
        findall(Con, (unidad(Jugador, piquero(Con, _)), Con \= sin), ConEscudos),
        findall(Sin, (unidad(Jugador, piquero(Sin, _)), Sin \= con), SinEscudos),
        length(ConEscudos, CantidadCon),
        length(SinEscudos, CantidadSin),
        CantidadCon > CantidadSin.

/* Punto 10 */

/* 10. Árbol de tecnologías
a. Se sabe que existe un árbol de tecnologías, que indica dependencias entre ellas. Hasta no
desarrollar una, no se puede desarrollar la siguiente. Modelar el siguiente árbol de ejemplo:
 */

dependencias(herreria, forja).
dependencias(forja, fundicion).
dependencias(fundicion, altoHorno).

dependencias(herreria, laminas).
dependencias(laminas, cotaDeMalla).
dependencias(cotaDeMalla, placasMalla).

dependencias(herreria, emplumado).
dependencias(emplumado, flechaPunzon).

dependencia(molino, collera).
dependencia(collera, aradoPesado).


/* 
b. Saber si un jugador puede desarrollar una tecnología, que se cumple cuando ya desarrolló
todas sus dependencias (las directas y las indirectas). Considerar que pueden existir árboles
de cualquier tamaño.
En el ejemplo, beto puede desarrollar el molino (pues no tiene dependencias) pero no la
herrería (porque ya la tiene), y ana puede desarrollar fundición (pues tiene forja y herrería).
  */

puedeDesarrollar(Jugador, Tecnologia):-
    desarrollo(Jugador, _),
    dependencias(_, Tecnologia),
    forall((dependencias(Otra, Tecnologia), Otra \= Tecnologia), desarrollo(Jugador, Otra)),
    not(desarrollo(Jugador, Tecnologia)).

/* puede desarrollar tecnologia que no tenga dependencia */

puedeDesarrollar(Jugador, Tecnologia):-
    desarrollo(Jugador, _),
    dependencia(Tecnologia, _),
    not(dependencias(_, Tecnologia)),
    not(desarrollo(Jugador, Tecnologia)).



/* 11.
a. Encontrar un orden válido en el que puedan haberse desarrollado las tecnologías para que un
jugador llegue a desarrollar todo lo que tiene. Se espera una relación de jugador con lista de
tecnologías.
Ejemplo: Un orden válido para Ana es: herreria, emplumado, forja, láminas. Otro orden válido
sería herreria, forja, láminas, emplumado. Pero seguro que Ana no desarrolló primero la forja,
porque antes necesitaría la herrería.
Recordar que debe funcionar para cualquier árbol y no sólo para el de el ejemplo. Y recordar
que debe ser completamente inversible. */

/* NO USAR PERMUTATION */
ordenValido(Jugador, Orden):-
    jugador(Jugador),
    findall(Tecnologia, desarrollo(Jugador, Tecnologia), Tecnologias),
    findall(Tecnologia, dependencias(_, Tecnologia), Dependencias),
    findall(Tecnologia, dependencia(Tecnologia, _), Dependencias2),
    append(Dependencias2, Dependencias, Orden).




/* b. ¿Qué sucede cuando se consulta si existe un orden válido para Dimitri? ¿Por qué?
 */

% Test
:- begin_tests(civilizacionesytecnologias).
        test(ana_es_experta_en_metales, nondet):-
            expertoEnMetales(ana).
        test(beto_es_experto_en_metales, nondet):-
                expertoEnMetales(beto).
        test(carola_no_es_experta_en_metales, fail):-
                expertoEnMetales(carola).
        test(dimitri_no_es_experto_en_metales, fail):-
                expertoEnMetales(dimitri).

        test(romanos_es_popular, nondet):-
                popular(romanos).
        test(incas_no_es_popular, fail):-
                popular(incas).

        test(herreria_tiene_alcance_global, nondet):-
                alcanceGlobal(herreria).
        test(forja_no_tiene_alcance_global, fail):-
                alcanceGlobal(forja).
        test(emplumado_no_tiene_alcance_global, fail):-
                alcanceGlobal(emplumado).
        test(laminas_no_tiene_alcance_global, fail):-
                alcanceGlobal(laminas).
        test(fundicion_no_tiene_alcance_global, fail):-
                alcanceGlobal(fundicion). 
        test(romanos_es_lider, nondet):-
                civilizacionLider(romanos).
        test(incas_no_es_lider, fail):-
                civilizacionLider(incas).

:- end_test(civilizacionesytecnologias).   

:- begin_tests(unidades).

test(ana_tiene_unidad_con_mas_vida, nondet):-
    unidadConMasVidaDe(ana, Unidad),
    Unidad = jinete(caballo).
test(beto_tiene_unidad_con_mas_vida, nondet):-
    unidadConMasVidaDe(beto, Unidad),
    Unidad = campeon(100).
test(carola_tiene_unidad_con_mas_vida, nondet):-
    unidadConMasVidaDe(carola, Unidad),
    Unidad = piquero(con, 2).
test(dimitri_no_tiene_unidad_con_mas_vida, fail):-
    unidadConMasVidaDe(dimitri, _).

        test(campeon_gana_a_piquero, nondet):-
            ganaUnidad(campeon(100), piquero(sin, 1)).

        test(piquero_gana_a_jinete, nondet):-
            ganaUnidad(piquero(sin, 1), jinete(caballo)).

        test(jinete_gana_a_campeon, nondet):-
            ganaUnidad(jinete(caballo), campeon(100)).

        test(beto_sobrevive_al_asedio, nondet):-
            sobreviveAsedio(beto).

        test(ana_no_sobrevive_al_asedio, fail):-
            sobreviveAsedio(ana).

        test(puede_desarrollar_molino, nondet):-
            puedeDesarrollar(beto, molino).

        test(no_puede_desarrollar_herreria, fail):-
            puedeDesarrollar(beto, herreria).

        test(puede_desarrollar_fundicion, nondet):-
            puedeDesarrollar(ana, fundicion).
        
:- end_tests(unidades).
