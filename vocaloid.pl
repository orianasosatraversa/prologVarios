/* Vocaloid */

/* Es un software de síntesis de voz en el que se animan a personajes, llamados vocaloids. Muy pronto habrán varios conciertos de esta temática a lo largo de varias ciudades del mundo, y para determinar información crítica de los cantantes nos pidieron una solución en Prolog para ayudar a los organizadores a elegir los vocaloids que participarán en cada concierto.
De cada vocaloid (o cantante) se conoce el nombre y además la canción que sabe cantar. De cada canción se conoce el nombre y la cantidad de minutos de duración.
 */

cantante(megurineLuka, nightFever, 4).
cantante(megurineLuka, foreverYoung, 5).

cantante(hatsuneMiku, tellYourWorld, 4).

cantante(gumi, foreverYoung, 4).
cantante(gumi, tellYourWorld, 5).

cantante(seeU, novemberRain, 6).
cantante(seeU, nightFever, 5).

cantante(ori, novemberRain, 3).
cantante(ori, nightFever, 1).

cantante(kaito, null, 0).


/* Punto 1 */
/* 
esNovedoso(Cantante):-
    cantante(Cantante, Cancion, _),
    cantante(Cantante, Otra, _),
    Cancion \= Otra,
    findall(Tiempo, cantante(Cantante, _, Tiempo), Tiempos),
    sum_list(Tiempos, TiempoTotal),
    TiempoTotal < 15.
     */
    
esNovedoso(Cantante):-
   cantante(Cantante, _, _),
   findall(Tiempo, cantante(Cantante, _, Tiempo), Tiempos),
   length(Tiempos, Largo),
   sum_list(Tiempos, TiempoTotal),
   Largo >= 2,
   TiempoTotal < 15.


/* Punto 2 */

/* esAcelerado(Cantante):- 
    cantante(Cantante, _, _),
    forall(cantante(Cantante, _, Tiempo), Tiempo < 4).
 */

esAcelerado(Cantante):-
    cantante(Cantante, _, _),
    not((cantante(Cantante, _, Tiempo), not(Tiempo < 4 ))).

/* concierto(Nombre, Pais, Fama, Tipo: gigante, mediano y pequeño).  */

/* Punto 1 */

concierto(mikuExpo, estadosUnidos , 2000 ,gigante(2, 6)).
concierto(magicalMirai, japon, 3000,gigante(3, 10)).
concierto(vocalekt, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

/* Punto 2 */

puedeParticipar(hatsuneMiku, Concierto):-
    concierto(Concierto, _, _, _).

puedeParticipar(Cantante, Concierto):-
    cantante(Cantante, _, _),
    concierto(Concierto, _, _, Requisito),
    cumpleRequisito(Cantante, Requisito).

cumpleRequisito(Cantante, gigante(CantCanciones, TiempoMinimo)):-
    findall(Tiempo, cantante(Cantante, _, Tiempo), Tiempos),
    length(Tiempos, TotalCanciones),
    sum_list(Tiempos, TotalTiempo),
    TotalCanciones >= CantCanciones,
    TotalTiempo >= TiempoMinimo.

cumpleRequisito(Cantante, mediano(DuracionTotalMaxima)):-
    findall(Tiempo, cantante(Cantante, _, Tiempo), Tiempos),
    sum_list(Tiempos, TotalTiempo),
    TotalTiempo < DuracionTotalMaxima.

cumpleRequisito(Cantante, pequenio(TiempoMinimo)):-
    cantante(Cantante, _, Tiempo), 
    Tiempo > TiempoMinimo.


/* Punto 3 */


/* nivelDeFama(Cantante, NivelDeFama):-
    cantante(Cantante, _, _),
    findall(Puntos, (puedeParticipar(Cantante, Concierto), concierto(Concierto, _, Puntos, _)), SumaPuntos),
    sum_list(SumaPuntos, PuntosPorConcerto),
    findall(Cancion, cantante(Cantante, Cancion, _), Canciones),
    length(Canciones, Largo),
    NivelDeFama is Largo * PuntosPorConcerto.


vocaloidMasFamoso(Cantante):-
    cantante(Cantante,_,_),
    nivelDeFama(Cantante, NivelDeFama),
    forall(nivelDeFama(_, Nivel), NivelDeFama > Nivel). */

masFamoso(Cantante) :-
    nivelFamoso(Cantante, NivelMasFamoso),
    forall(nivelFamoso(_, Nivel), NivelMasFamoso >= Nivel).

nivelFamoso(Cantante, Nivel):- 
    famaTotal(Cantante, FamaTotal), 	
    cantidadCanciones(Cantante, Cantidad), 
    Nivel is FamaTotal * Cantidad.

famaTotal(Cantante, FamaTotal):- 
    cantante(Cantante,_,_),
    findall(Fama, famaConcierto(Cantante, Fama), CantidadesFama), 	
    sumlist(CantidadesFama, FamaTotal).

famaConcierto(Cantante, Fama):-
    puedeParticipar(Cantante,Concierto),
    fama(Concierto, Fama).

fama(Concierto,Fama):- 
    concierto(Concierto,_,Fama,_).

cantidadCanciones(Cantante, Cantidad) :- 
    findall(Cancion, cantante(Cantante, Cancion, _), Canciones),
    length(Canciones, Cantidad).
    
    
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoParticipanteEntreConocidos(Cantante,Concierto):- 
    puedeParticipar(Cantante, Concierto),
	not((conocido(Cantante, OtroCantante), 
    puedeParticipar(OtroCantante, Concierto))).


%Conocido directo
conocido(Cantante, OtroCantante) :- 
    conoce(Cantante, OtroCantante).
    
    %Conocido indirecto
    conocido(Cantante, OtroCantante) :- 
    conoce(Cantante, UnCantante), 
    conocido(UnCantante, OtroCantante).
    

/* En la solución planteada habría que agregar una claúsula en el predicado cumpleRequisitos/2  que tenga en cuenta el nuevo functor con sus respectivos requisitos 

El concepto que facilita los cambios para el nuevo requerimiento es el polimorfismo, que nos permite dar un tratamiento en particular a cada uno de los conciertos en la cabeza de la cláusula. */