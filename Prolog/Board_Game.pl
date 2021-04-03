:-use_module(library(lists)).
:-set_prolog_flag(answer_write_options,[max_depth(0)]).


%:-initialGrid/1
%Définit la grille initiale
grilleinitiale(G):-
	grilleinitiale(1,P1G),
	grilleinitiale(2,P2G),
	G = [P1G,P2G].

%:-gridCase/1
%Renvoie une case de la grille
casegrille([A,B]):-
	member(A,[1,2,3,4,5]),
	member(B,[1,2,3,4,5,6,7,8]).

joueurCouleur(1,b).
joueurCouleur(2,r).

couleurOppose(r,b).
couleurOppose(b,r).

nombrePionGrille(G,N):-length(G,N).
nombrePionPoche(G,N):- length(G,N1), N is 20 - N1.

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

grilleinitiale(2,PG):-
	PG = [
        [[2,8],r],[[4,8],r],
        [[1,7],r],[[3,7],r],[[5,7],r]
	].

anterieurRempli(G,Case):-
	G = [G1,_],
	Case = [A,B],
	N is B +1,
	member([[A,N],_],G1),
	!.


anterieurRempli(G,Case):-
	G = [_,G2],
	Case = [A,B],
	N is B +1,
	member([[A,N],_],G2),
	!.

caseVide(Case,G):-
	G = [G1,G2],
	\+ member(Case,G1),
	\+ member(Case,G2).

caseCorrecte(G,D):-
	casegrille(D),
	caseVide([D,_],G),
	anterieurRempli(G,D),
	!.

deplacable(Case,G):-
	Case = [[A,B],_],
	B = 8,
	caseVide([[A,1],_],G).
	


getCaseLigneH(PGrille,Case) :-
	PGrille = [[_,Couleur]|_],
	Case = [[1, 8],Couleur],
	member(Case,PGrille).

getCaseLigneH(PGrille,Case) :-
	PGrille = [[_,Couleur]|_],
	Case = [[2, 8],Couleur],
	member(Case,PGrille).

getCaseLigneH(PGrille,Case) :-
	PGrille = [[_,Couleur]|_],
	Case = [[3, 8],Couleur],
	member(Case,PGrille).

getCaseLigneH(PGrille,Case) :-
	PGrille = [[_,Couleur]|_],
	Case = [[4, 8],Couleur],
	member(Case,PGrille).

getCaseLigneH(PGrille,Case) :-
	PGrille = [[_,Couleur]|_],
	Case = [[5, 8],Couleur],
	member(Case,PGrille).



%%%%%%%%%%%%%%%%% moveDown pour deplacer toutes les lignes dune colonne vers le bas %%%%%%%%%%%%%%%%%%%%%%
moveDown(_,[],[]).

moveDown(Colonne, Grille, NvGrille) :-
	Grille = [[[Colonne,B], Couleur] | Reste],
	N is B + 1,
	%% N =< 8,  pas besoin de cette condition elle est satisfaite de base
	moveDown(Colonne, Reste, NvGrille1),
	!,
	NvGrille = [[[Colonne,N], Couleur] | NvGrille1].

moveDown(Colonne,Grille, NvGrille) :-
	Grille = [[[A,B], Couleur] | Reste],
	moveDown(Colonne, Reste, NvGrille1),
	NvGrille = [[[A,B], Couleur] | NvGrille1].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%% retirerCase pour Retirer une Case Case qui appartient a une Grille Grille %%%%%%%%%%%%%%%%

retirerCase(_, [], []):-!.

retirerCase(Case , [Case|Reste], NvGrille) :-
    retirerCase(Case,Reste,Grille),
    !,
    NvGrille = Grille.

retirerCase(Case , [X|Reste], NvGrille) :-
    retirerCase(Case, Reste, Grille),
    NvGrille = [X|Grille].




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%% nextLigneVide predicat pour trouver le prochaine Ligne vide d'une Colonne
			%%%%% Colonne N° de colonne Min la valeur minimale des ligne %%%%%%%%%%%


nextLigneVide(Case, Grille , NvCase) :-
	Case = [[A,B],_],
	N is B - 1,
	N >= 1,
	NvCase = [[A,N],_],
	caseVide(NvCase, Grille),
	!.

nextLigneVide(Case, Grille, NvCase) :-
	Case = [[A,B],_],
	N is B - 1,
	N >= 1,
	nextLigneVide([[A,N],_] ,Grille , NvCase).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% movepiece pour deplacer Un pion d'une case Case
				%% Vers un Case NVcase %%%%%%%%%%%%%%%%%%%%%%

movepiece(Case, NvCase, Player,Couleur, Grille, NvGrille):-
	Grille = [G1, G2],
	grilleinitiale(Player, PGrille),
	PGrille = G1,
	retirerCase(Case, G1, NVG1),
	NVG = [NVG1, G2],
	nextLigneVide(Case, NVG, NvCase),
	NvCase = [[A,_],Couleur],
	moveDown(A, [NvCase|NVG1], NVG3),
	moveDown(A, G2, NVG4),
	NvGrille = [NVG3,NVG4].


movepiece(Case, NvCase, Player,Couleur, Grille, NvGrille):-
	Grille = [G1, G2],
	grilleinitiale(Player, PGrille),
	PGrille = G2,
	retirerCase(Case, G2, NVG2),
	NVG = [G1, NVG2],
	nextLigneVide(Case, NVG, NvCase),
	NvCase = [[A,_],Couleur],
	moveDown(A, G1, NVG3),
	moveDown(A, [NvCase|NVG2], NVG4),
	NvGrille = [NVG3,NVG4].


%Deplacement depuis la ligne H
deplacement(Grille, Player, NVGrille) :-
	joueurCouleur(Player, Couleur),
	grilleinitiale(Player, PGrille),
	getCaseLigneH(PGrille, Case),
	deplacable(Case, Grille), % a enlever proablement 
	movepiece(Case, NvCase,Player ,Couleur,Grille , NVGrille).
	

	%%%% deplacement([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],1,NVG).


memeColonne(G,N):-
	G = [[A,B]|Reste]. %% a finir.

contrainteVerticale(G,M):-
	
	nombrePionGrille(G,N),
	N >=5,
	G = [[A,B]|Reste],
	M1 is M + 1,
	contrainteVerticale(Reste,M1).

etatGagnant(Grille,Player):-

	Grille = [G1,G2],
	contrainte(G1),
	Player is 1.

etatGagnant(Grille,Player):-

	Grille = [G1,G2],
	contrainte(G2),
	Player is 2.
	

