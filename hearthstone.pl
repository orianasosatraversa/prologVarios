% jugadores
jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo).

% cartas
criatura(Nombre, PuntosDanio, PuntosVida, CostoMana).
hechizo(Nombre, FunctorEfecto, CostoMana).

% efectos
danio(CantidadDanio).
cura(CantidadCura).


nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

danio(criatura(_,Danio,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).

mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).


/* Punto 1 */

/* Relacionar un jugador con una carta que tiene. La carta podría estar en su mano, en el campo o en el mazo. */

tieneCarta(Jugador, Carta) :-
    cartasMazo(Jugador, Cartas),
    member(Carta, Cartas).

tieneCarta(Jugador, Carta) :-
    cartasMano(Jugador, Cartas),
    member(Carta, Cartas).

tieneCarta(Jugador, Carta) :-
    cartasCampo(Jugador, Cartas),
    member(Carta, Cartas).

/* Punto 2 */

/* Saber si un jugador es un guerrero. Es guerrero cuando todas las cartas que tiene, ya sea en el mazo, la mano o el campo, son criaturas. */

esGuerrero(Jugador):-
    tieneCarta(Jugador, _),
    forall(tieneCarta(Jugador, Carta), esCriatura(Carta)).

esCriatura(criatura(_,_,_,_)).


/* Punto 3 */

/* Relacionar un jugador consigo mismo después de empezar el turno. Al empezar el turno, la primera carta del mazo pasa a estar en la mano y el jugador gana un punto de maná. */

jugadorComienzo(Jugador, JugadorPost):-
    jugador(Jugador, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo),
    nth0(0, CartasMazo, Carta),
    delete(CartasMazo, Carta, CartasMazoPost),
    append([Carta], CartasMano, CartasManoPost),
    PuntosManaPost is PuntosMana + 1,
    jugador(JugadorPost, PuntosVida, PuntosManaPost, CartasMazoPost, CartasManoPost, CartasCampo).


/* Punto 4 */

/* a. Cada jugador, en su turno, puede jugar cartas.
Saber si un jugador tiene la capacidad de jugar una carta, esto es verdadero cuando el jugador tiene igual o más maná que el costo de maná de la carta. 
Este predicado no necesita ser inversible! */

turno(Jugador):-
    jugador(Jugador, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo),
    tieneCarta(Jugador, Carta),
    mana(Carta, CostoMana),
    PuntosMana >= CostoMana.

/* b. Relacionar un jugador y las cartas que va a poder jugar en el próximo turno, una carta se puede jugar en el próximo turno si tras empezar ese turno está en la mano y además se cumplen las condiciones del punto 4.a. */

cartasAJugar(Jugador, Cartas):-
    jugadorComienzo(Jugador, JugadorPost),
    cartasMano(JugadorPost, Cartas),
    findall(Carta, (member(Carta, Cartas), turno(JugadorPost)), Cartas).



/* Punto 5 */

/* Conocer, de un jugador, todas las posibles jugadas que puede hacer en el próximo turno, esto es, el conjunto de cartas que podrá jugar al mismo tiempo sin que su maná quede negativo.
Nota: Se puede asumir que existe el predicado jugar/3 como se indica en el punto 7.b. No hace falta implementarlo para resolver este punto. Importante: También hay formas de resolver este punto sin usar jugar/3. 
Tip: Pensar en explosión combinatoria.
 */

jugadasPosibles(Jugador, Jugadas):-
    cartasAJugar(Jugador, Cartas),
    subset(Cartas, Jugadas),
    forall(member(Jugada, Jugadas), turno(Jugador, Jugada)).

turno(Jugador, Carta):-
    jugador(Jugador, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo),
    mana(Carta, CostoMana),
    PuntosMana >= CostoMana.


/*     Relacionar a un jugador con el nombre de su carta más dañina.
 */
