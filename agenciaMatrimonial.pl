%melancolico(jose). % predicado de aridad 1 y es un hecho
varon(jose).
varon(pedro).
varon(juan).
mujer(ursula).
mujer(juana).
mujer(maria).
melancolico(jose).
melancolico(maria).
melancolico(ursula).
reflexivo(pedro).
soniadora(juana).
decidida(ursula).
decidida(juan).
sereno(juan).

pareja(Mujer,Varon):- mujer(Mujer),varon(Varon), melancolico(Mujer), sereno(Varon). %REGLAS

pareja(Mujer,Varon):- mujer(Mujer), varon(Varon),decidida(Mujer), reflexivo(Varon).

pareja(Mujer,Varon):- mujer(Mujer), varon(Varon),decidida(Varon), soniadora(Mujer).

pareja(Mujer,Varon):-  mujer(Mujer), varon(Varon),decidida(Mujer), melancolico(Varon).

pareja(Mujer,Varon):-  mujer(Mujer), varon(Varon),decidida(Varon), melancolico(Mujer).

pareja1(Mujer,Varon):- mujer(Mujer), varon(Varon), (decidida(Mujer);decidida(Varon)), (melancolico(Mujer);melancolico(Varon)).

esCompatible(Quien):- varon(Quien), pareja(Mujer,Quien), pareja(OtraMujer, Quien), Mujer \= OtraMujer .

esCompatible(Quien):- mujer(Quien), pareja(Quien, Varon), pareja(Quien,OtroVaron), Varon \= OtroVaron.

