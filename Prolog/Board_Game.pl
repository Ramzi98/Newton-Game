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


%%%%%%%%%%%%%%%%% nextLigneVide predicat pour trouver la prochaine Ligne vide d'une Colonne
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
	Player = 1,
	%grilleinitiale(Player, PGrille),
	%PGrille = G1,
	retirerCase(Case, G1, NVG1),
	NVG = [NVG1, G2],
	nextLigneVide(Case, NVG, NvCase),
	NvCase = [[A,_],Couleur],
	moveDown(A, [NvCase|NVG1], NVG3),
	moveDown(A, G2, NVG4),
	NvGrille = [NVG3,NVG4].


movepiece(Case, NvCase, Player,Couleur, Grille, NvGrille):-
	Grille = [G1, G2],
	Player = 2,
	%grilleinitiale(Player, PGrille),
	%PGrille = G2,
	retirerCase(Case, G2, NVG2),
	NVG = [G1, NVG2],
	nextLigneVide(Case, NVG, NvCase),
	NvCase = [[A,_],Couleur],
	moveDown(A, G1, NVG3),
	moveDown(A, [NvCase|NVG2], NVG4),
	NvGrille = [NVG3,NVG4].


%deplacement([[[[1,8],b],[[3,8],b],[[1,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1, NvGrille).
%Deplacement depuis la ligne H
deplacement(Grille, Player, NVGrille) :-
	joueurCouleur(Player, Couleur),
	%grilleinitiale(Player, PGrille),
    Player = 1,
	Grille = [G1,_],
	getCaseLigneH(G1, Case),
	deplacable(Case, Grille), % a enlever proablement 
	movepiece(Case, _NvCase,Player ,Couleur,Grille , NVGrille).

%Deplacement depuis la ligne H
deplacement(Grille, Player, NVGrille) :-
	joueurCouleur(Player, Couleur),
	%grilleinitiale(Player, PGrille),
	Player = 2,
	Grille = [_,G2],
	getCaseLigneH(G2, Case),
	deplacable(Case, Grille), % a enlever proablement 
	movepiece(Case, _NvCase,Player ,Couleur,Grille , NVGrille).


%%%%% allCase([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],r,1,Case).


%%%%%%%%%%%%%%%%% allCase Récupère  les cases vides pour toutes les Colonne %%%%%%%%%%%%%%%%%%%%%%

allCase(PGrille, Couleur, Case) :-
	getCasePossible(PGrille, Couleur, 1, 6, Case).

allCase(PGrille, Couleur, Case) :-
	getCasePossible(PGrille, Couleur, 2, 6, Case).

allCase(PGrille, Couleur, Case) :-
	getCasePossible(PGrille, Couleur, 3, 6, Case).

allCase(PGrille, Couleur, Case) :-
	getCasePossible(PGrille, Couleur, 4, 6, Case).

allCase(PGrille, Couleur, Case) :-
	getCasePossible(PGrille, Couleur, 5, 6, Case).


%%%%%%%%%%%%%%%%% getCasePossible Récupère la premier Case vide (de bas en haut) Dans une colonne fournie
		%%%%%%%%	Grille : la grile de jeux actuelle %%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%	Couleur : la couleur du joueur qui va jouer le coup %%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%	Colonne : la colonne fournie Pour trouver une case vide %%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%	Ligne : la Ligne fournie Pour V"rifier si la case [Ligne, Colonne] est vide sinon Ligne = Ligne -1 %%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%	Case : la premier case vide (de bas en haut) %%%%%%%%%%%%%%%%%%%%%%

getCasePossible(_, _, 0, _) :-
	!.

getCasePossible(Grille, Couleur, Colonne, Ligne, Case) :-
	Grille = [G1,G2],
	Ligne >= 1,
	\+ member([[Colonne,Ligne],_], G1),
	\+ member([[Colonne,Ligne],_], G2),
	Case = [[Colonne,Ligne],Couleur],
	!.

getCasePossible(Grille, Couleur, Colonne, Ligne, Case) :-
	Ligne >= 1,
	N is Ligne - 1,
	getCasePossible(Grille, Couleur, Colonne, N, Case).

	
addCaseGrille(Grille, Couleur, Case, NVGrille) :-
	Grille = [G1,G2],
	G1 = [[_,Couleur]|_],
	NVG1 = [Case|G1],
	NVGrille = [NVG1,G2].

addCaseGrille(Grille, Couleur, Case, NVGrille) :-
	Grille = [G1,G2],
	G2 = [[_,Couleur]|_],
	NVG2 = [Case|G2],
	NVGrille = [G1,NVG2].

%% deplacementPoche([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1, NVGrille).
%% deplacementPoche([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b],[[1,6],b],[[1,5],b],[[1,4],b],[[1,3],b],[[1,2],b],[[1,1],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1, NVGrille).


%Deplacement depuis la Poche
deplacementPoche(Grille, Player, NVGrille) :-
	joueurCouleur(Player, Couleur),
	Player = 1,
	Grille=[G1,_],
	nombrePionPoche(G1, N),
	N > 0,
	allCase(Grille, Couleur, Case),
	addCaseGrille(Grille, Couleur, Case, NVGrille).
	
%Deplacement depuis la Poche
deplacementPoche(Grille, Player, NVGrille) :-
	joueurCouleur(Player, Couleur),
	Player = 2,
	Grille=[_,G2],
	nombrePionPoche(G2, N),
	N > 0,
	allCase(Grille, Couleur, Case),
	addCaseGrille(Grille, Couleur, Case, NVGrille).

	%%%% deplacement([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],1,NVG).
	%%%% contrainteVerticale([[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b],[[4,6],b],[[4,5],b],[[4,4],b],[[4,3],b],[[4,2],b]],[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b],[[4,6],b],[[4,5],b],[[4,4],b],[[4,3],b],[[4,2],b]]).
	%%%% etatGagnant([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b],[[4,6],b],[[4,5],b],[[4,4],b],[[4,3],b],[[4,2],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],Player).

%% contrainteVerticale(Grille,GrilleInit)
	%%% Grille : Grille courante pendant le parcour  
	%%% GrilleInit : la grille au debut de parcour avec toutes les elements  


deplacementN(Grille, Player, NVGrille):-deplacement(Grille, Player, NVGrille).

deplacementN(Grille, Player, NVGrille):-deplacementPoche(Grille, Player, NVGrille).


%insereC(Grille,Player,NvGrille):-


contrainteVerticale([],_) :- 
	fail,
	!.

contrainteVerticale(G,G1):-
	%% nombrePionGrille(G,N), %% Pour optimiser
	%% N >=5, %% Pour optimiser
	G = [[[A,B],_]|_],
	B = 5,
	member([[A,4],Couleur],G1),
	member([[A,3],Couleur],G1),
	member([[A,2],Couleur],G1),
	member([[A,1],Couleur],G1),
	!.

contrainteVerticale(G,G1):-
	%% nombrePionGrille(G,N), %% Pour optimiser
	%% N >=5, %% Pour optimiser
	G = [[[A,B],Couleur]|_],
	B = 6,
	member([[A,5],Couleur],G1),
	member([[A,4],Couleur],G1),
	member([[A,3],Couleur],G1),
	member([[A,2],Couleur],G1),
	!.

contrainteVerticale(G,G1):-
	G = [_|Reste],
	contrainteVerticale(Reste,G1).


%% contrainteHorizontale(Grille,GrilleInit)
	%%% Grille : Grille courante pendant le parcour  
	%%% GrilleInit : la grille au debut de parcour avec toutes les elements  

contrainteHorizontale([],_) :- 
	fail,
	!.

contrainteHorizontale(G,G1):-
	%% nombrePionGrille(G,N), %% Pour optimiser
	%% N >=5, %% Pour optimiser
	G = [[[A,B],_]|_],
	B >= 1,
	B =< 6,
	A = 1,
	member([[2,B],Couleur],G1),
	member([[3,B],Couleur],G1),
	member([[4,B],Couleur],G1),
	member([[5,B],Couleur],G1),
	!.

contrainteHorizontale(G,G1):-
	G = [_|Reste],
	contrainteHorizontale(Reste,G1).



%% contrainteDiagonale(Grille,GrilleInit)
	%%% Grille : Grille courante pendant le parcour  
	%%% GrilleInit : la grille au debut de parcour avec toutes les elements  

contrainteDiagonale([],_) :- 
	fail,
	!.

contrainteDiagonale(G,G1):-
	%% nombrePionGrille(G,N), %% Pour optimiser
	%% N >=5, %% Pour optimiser
	G = [[[A,B],_]|_],
	B = 6,
	A = 1,
	member([[2,5],Couleur],G1),
	member([[3,4],Couleur],G1),
	member([[4,3],Couleur],G1),
	member([[5,2],Couleur],G1),
	!.

contrainteDiagonale(G,G1):-
	%% nombrePionGrille(G,N), %% Pour optimiser
	%% N >=5, %% Pour optimiser
	G = [[[A,B],_]|_],
	B = 5,
	A = 1,
	member([[2,4],Couleur],G1),
	member([[3,3],Couleur],G1),
	member([[4,2],Couleur],G1),
	member([[5,1],Couleur],G1),
	!.

contrainteDiagonale(G,G1):-
	%% nombrePionGrille(G,N), %% Pour optimiser
	%% N >=5, %% Pour optimiser
	G = [[[A,B],_]|_],
	B = 6,
	A = 5,
	member([[4,5],Couleur],G1),
	member([[3,4],Couleur],G1),
	member([[2,3],Couleur],G1),
	member([[1,2],Couleur],G1),
	!.

contrainteDiagonale(G,G1):-
	%% nombrePionGrille(G,N), %% Pour optimiser
	%% N >=5, %% Pour optimiser
	G = [[[A,B],_]|_],
	B = 5,
	A = 5,
	member([[4,4],Couleur],G1),
	member([[3,3],Couleur],G1),
	member([[2,2],Couleur],G1),
	member([[1,1],Couleur],G1),
	!.
contrainteDiagonale(G,G1):-
	G = [_|Reste],
	contrainteDiagonale(Reste,G1).

contrainte(G,G1):-
	contrainteVerticale(G,G1),
	!.

contrainte(G,G1):-
	contrainteHorizontale(G,G1),
	!.

contrainte(G,G1):-
	contrainteDiagonale(G,G1),
	!.

%%%% etatGagnant(Grille,Player) : Grille (la grille principale Grille = [G1,G2] )
	%%%%%%%%% Player : numero de joueur gagnant 
	%%%%%%%%% return false si pas de gagnant 

%%%%%%%%%% Pour vérifier les deux joueur il faut enlver le  !.

etatGagnant(Grille,Player):-
	Grille = [G1,_],
	contrainte(G1,G1),
	Player is 1,
	!.

etatGagnant(Grille,Player):-
	Grille = [_,G2],
	contrainte(G2,G2),
	Player is 2,
	!.
