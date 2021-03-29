:-use_module(library(lists)).
:-set_prolog_flag(answer_write_options,[max_depth(0)]).


%:-initialGrid/1
%Définit la grille initiale
grilleinitiale(G):-
	grilleinitiale(1,P1G),
	grilleinitiale(-1,P2G),
	G = [P1G,P2G].

%:-gridCase/1
%Renvoie une case de la grille
casegrille([A,B]):-
	member(A,[1,2,3,4,5]),
	member(B,[1,2,3,4,5,6,7,8]).

joueurCouleur(1,b).
joueurCouleur(-1,r).

couleurOppose(r,b).
couleurOppose(b,r).

%:-initialGrid/2
%Définit la grille initiale pour le joueur donné.
%initialGrid(J,G) : 
				%J = Id joueur
				%G = Grille initiale pour ce joueur
grilleinitiale(1,PG):-
	PG = [
        [[1,8],b],[[3,8],b],[[5,8],b],
        [[2,7],b],[[4,7],b]
	].

grilleinitiale(-1,PG):-
	PG = [
        [[2,8],r],[[4,8],r],
        [[1,7],r],[[3,7],r],[[5,7],r]
	].

anterieurRempli(G,C):-
	G = [G1,_],
	C = [A,B],
	N is B +1,
	member([[A,N],_],G1),
	!.


anterieurRempli(G,C):-
	G = [_,G2],
	C = [A,B],
	N is B +1,
	member([[A,N],_],G2),
	!.

caseVide(C,G):-
	G = [G1,G2],
	\+member(C,G1),
	\+member(C,G2).

caseCorrecte(G,D):-
	casegrille(D),
	caseVide([D,_],G),
	anterieurRempli(G,D),
	!.

deplacable(D,G):-
	D= [A,B],
	B = 8,
	caseVide([[A,1],_],G).


	


%les possibilités de deplacement : normalement deux prédicats
deplacementPossible(G,P,D).



% Add criteria that compares if there is an element in that board that can move -- 
	

% first deplace


