%:-initialGrid/1
%Définit la grille initiale
grilleinitiale(G):-
	grilleinitiale(1,P1G),
	grilleinitiale(-1,P2G),
	G = [P1G,P2G,[],[]].

%:-gridCase/1
%Renvoie une case de la grille
casegrille([A,B]):-
	member(A,[1,2,3,4,5]),
	member(B,[1,2,3,4,5,6,7,8]).

%:-initialGrid/2
%Définit la grille initiale pour le joueur donné.
%initialGrid(J,G) : 
				%J = Id joueur
				%G = Grille initiale pour ce joueur
grilleinitiale(1,PG):-
	PG = [
        [[1,8],blue],[[3,8],blue],[[5,8],blue],
        [[2,7],blue],[[4,7],blue]
	].

grilleinitiale(-1,PG):-
	PG = [
        [[2,8],rouge],[[4,8],rouge],
        [[1,7],rouge],[[3,7],rouge],[[5,7],rouge]
	].



