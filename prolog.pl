% siguiente(Anterior, Siguiente)
siguiente(N, S):- 
    numero(N),
    S is N+1.  % No es inversible, solo se puede usar para obtener el siguiente de un número

%El IS es inversible para lo que tiene a la izquierda.


hostil(Animal, Bioma):- forall(habitat(OtroAnimal, Bioma), come (OtroAnimal, Animal)).

terrible(Animal, Bioma):- forall(come(OtroAnimal, Animal), habitat(OtroAnimal, Bioma)).