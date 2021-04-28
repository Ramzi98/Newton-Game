-set_prolog_flag(toplevel_print_options, [max_depth(0)]).
-set_prolog_flag(gc, off).
 
:- use_module(library(lists)).
:- set_prolog_flag(toplevel_print_options,[max_depth(0)]).
:- use_module(library(random)).
:- ['./Board_Game.pl'].


%% getLigneElements(1,3,8,[[[1,8],b],[[2,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],E).

%%% Calcule de gauche a droite en peut ajouter une autre de droite a gauche
getLigneElements(Fin,Fin,L,PG,1) :-
        member([[Fin,L],_],PG),
        !.

getLigneElements(Fin,Fin,L,PG,0) :-
        \+member([[Fin,L],_],PG),
        !.

getLigneElements(Debut,_,L,PG,0) :-
        \+member([[Debut,L],_],PG),
        !.


getLigneElements(Debut,Fin,L,PG,E) :-
        member([[Debut,L],_],PG),
        NvDebut is Debut+1,
        getLigneElements(NvDebut,Fin,L,PG,E),
        !.

%% getColElements(6,4,1,[[[1,6],b],[[1,1],b],[[1,5],b],[[1,4],b],[[1,4],b],[[4,7],b]],E).

getColElements(Fin,Fin,C,PG,1) :-
        member([[C,Fin],_],PG),
        !.

getColElements(Fin,Fin,C,PG,0) :-
        \+member([[C,Fin],_],PG),
        !.

getColElements(Debut,_,C,PG,0) :-
        \+member([[C,Debut],_],PG),
        !.

getColElements(Debut,Fin,C,PG,E) :-
        member([[C,Debut],_],PG),
        NvDebut is Debut-1,
        getColElements(NvDebut,Fin,C,PG,E),
        !.


%% getDiagElements(1,6,2,[[[1,6],b],[[1,1],b],[[1,5],b],[[1,4],b],[[2,5],b],[[4,7],b]],E).

getDiagElements1(_,_,0,_,1):-!.

getDiagElements1(C,L,_,PG,0) :-
        \+member([[C,L],_],PG),
        !.

getDiagElements1(C,L,N,PG,E) :-
        N1 is N - 1,
        member([[C,L],_],PG),
        C1 is C + 1,
        L1 is L - 1,
        getDiagElements1(C1,L1,N1,PG,E),
        !.

getDiagElements2(_,_,0,_,1):-!.

getDiagElements2(C,L,_,PG,0) :-
        \+member([[C,L],_],PG),
        !.

getDiagElements2(C,L,N,PG,E) :-
        N1 is N - 1,
        member([[C,L],_],PG),
        C1 is C - 1,
        L1 is L - 1,
        getDiagElements2(C1,L1,N1,PG,E),
        !.

getDiagElements(C,L,N,PG,E) :-
        getDiagElements1(C,L,N,PG,E),
        !.

getDiagElements(C,L,N,PG,E) :-
        getDiagElements2(C,L,N,PG,E),
        !.


nbNSigne(PG, N, R) :-
        getLigneElements(1,N,6,PG,R1), %% R1 = 1 si on a N Element dans la ligne 6 
        getLigneElements(1,N,5,PG,R2), %% R2 = 1 si on a N Element dans la ligne 5
        getLigneElements(1,N,4,PG,R3), %% R3 = 1 si on a N Element dans la ligne 4 
        getLigneElements(1,N,3,PG,R4), %% R4 = 1 si on a N Element dans la ligne 3 
        getLigneElements(1,N,2,PG,R5), %% R5 = 1 si on a N Element dans la ligne 2 
        getLigneElements(1,N,1,PG,R6), %% R6 = 1 si on a N Element dans la ligne 1

        %%% Vérification des Colonnes
        M1 is 6 - N + 1,
        M2 is 5 - N + 1,
        getColElements(6,M1,1,PG,R7), %% R7 = 1 si on a N Element dans la Colonne 1 en commancant depuis ligne 6
        getColElements(5,M2,1,PG,R8), %% R8 = 1 si on a N Element dans la Colonne 1 en commancant depuis ligne 5
        getColElements(6,M1,2,PG,R9),
        getColElements(5,M2,2,PG,R10),
        getColElements(6,M1,3,PG,R11),
        getColElements(5,M2,3,PG,R12),
        getColElements(6,M1,4,PG,R13),
        getColElements(5,M2,4,PG,R14),
        getColElements(6,M1,5,PG,R15),
        getColElements(5,M2,5,PG,R16),

        %%% Vérification des Diagonales
        getDiagElements(1,6,N,PG,R17), %% R17 = 1 si on a N Element dans la Diagonale qui commence de (1,6)
        getDiagElements(1,5,N,PG,R18), %% R18 = 1 si on a N Element dans la Diagonale qui commence de (1,5)
        getDiagElements(5,6,N,PG,R19), %% R19 = 1 si on a N Element dans la Diagonale qui commence de (5,6)
        getDiagElements(5,5,N,PG,R20), %% R20 = 1 si on a N Element dans la Diagonale qui commence de (5,5)

        R is R1 + R2 + R3 + R4 + R5 + R6 + R7 + R8 + R9 + R10 + R11 + R12 + R13 + R14 + R15 + R16 + R17 + R18 + R19 + R20.

% Vrai si la Grille contient R lignes ou colonnes ou diagonales comportant 1 Pion
nb1Signe(PG, R) :-
        nbNSigne(PG, 1, R).

%nb2Signe([[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b],[[2,6],b],[[2,5],b]],E).

% Vrai si la Grille contient R lignes ou colonnes ou diagonales comportant 2 Pion
nb2Signe(PG, R) :-
        nbNSigne(PG, 2, R).

% Vrai si la Grille contient R lignes ou colonnes ou diagonales comportant 3 Pion
nb3Signe(PG, R) :-
        nbNSigne(PG, 3, R).

% Vrai si la Grille contient R lignes ou colonnes ou diagonales comportant 4 Pion
nb4Signe(PG, R) :-
        nbNSigne(PG, 4, R).

% Vrai si la Grille contient R lignes ou colonnes ou diagonales comportant 5 Pion
nb5Signe(PG, R) :-
        nbNSigne(PG, 5, R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fonction d'évaluation d'une Grille
% 1000 si plateau gagnant, -1000 si perdant, 0 si match nul
% Sinon : f(Grille) = 4 * (NB4 - NB4Adv) + 3 * (NB3 - NB3Adv) + 2 * (NB2 - NB2Adv) + 1 * (NB1 - NB1Adv)
% Avec NB4 : nb de lignes/col/diag comportant 4 fois notre Pion
% NB4Adv : nb de lignes/col/diag comportant 4 fois le Pion de l'advarsaire
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

evalue(_GrillePlayer, GrilleAdversaire, Prof, Eval) :-
        nb5Signe(GrilleAdversaire, NB5Adv), 
        NB5Adv >= 1,
        Eval is -1000 + Prof,
        !.
evalue(GrillePlayer, _GrilleAdversaire, Prof, Eval) :-
        nb5Signe(GrillePlayer, NB5), 
        NB5 >= 1,
        Eval is 1000 - Prof,
        !.

evalue(GrillePlayer, GrilleAdversaire, _Prof, Eval) :-
        %nb1Signe(GrillePlayer, NB1),
        %nb1Signe(GrilleAdversaire, NB1Adv),
        nb2Signe(GrillePlayer, NB2),
        nb2Signe(GrilleAdversaire, NB2Adv),
        nb3Signe(GrillePlayer, NB3),
        nb3Signe(GrilleAdversaire, NB3Adv),
        nb4Signe(GrillePlayer, NB4),
        nb4Signe(GrilleAdversaire, NB4Adv),
        %Eval is  4 * (NB4 - NB4Adv) + 3 * (NB3 - NB3Adv) + 2 * (NB2 - NB2Adv) + 1 * (NB1 - NB1Adv),
        Eval is  4 * (NB4 - NB4Adv) + 3 * (NB3 - NB3Adv) + 2 * (NB2 - NB2Adv),
        !.
        
evalue(_GrillePlayer, _GrilleAdversaire, _Prof, 0) :- !. %% A enlver probablement

%evalue([[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]], [[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]], Prof, Eval).
%evalue([[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b],[[2,6],b],[[2,5],b]], [[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r],[[1,6],r],[[1,5],r]], 
%2, Eval).
%Eval = 0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MIN MAX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%minCoups([[[[[1,6],b],6]],[[[[2,4],b],7]],[[[[3,6],b],2]],[[[[4,6],b],2]],[[[[5,6],b],2]]],[10,10],S).
minCoups([], Meilleur, Meilleur).
minCoups([[[Coup,Eval]]|L], [_MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]) :-
        Eval =< MeillEvalActuel,
        minCoups(L, [Coup,Eval], [MeillCoup,MeillEval]),
        !.

minCoups([[[_,_]]|L], [MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]) :-
        minCoups(L, [MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]).

%maxCoups([[[[[1,6],b],6]],[[[[2,4],b],7]],[[[[3,6],b],2]],[[[[4,6],b],2]],[[[[5,6],b],2]]],[0,0],S).
maxCoups([], Meilleur, Meilleur).
maxCoups([[[Coup,_]]|L], [_MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]) :-
        Eval >= MeillEvalActuel,
        maxCoups(L, [Coup,Eval], [MeillCoup,MeillEval]),
        !.

maxCoups([[[_,Eval]]|L], [MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]) :-
        maxCoups(L, [MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]).


%getCoupPossible([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1, Coup).



getCoupPossible(Grille,1,NvGrille,Coup):-

	deplacementN(Grille,1,NvGrille),
	NvGrille = [G1,_],
	G1 = [Coup|_].


getCoupPossible(Grille,2,Coup):-

	deplacementN(Grille,2,NvGrille),
	NvGrille = [_,G2],
	G2 = [Coup|_].


getCoupEval(Grille,1,CoupEval):-
	getCoupPossible(Grille, 1, NvGrille,Coup),
	NvGrille = [G1|G2],
	findall([Coup,Eval],evalue(G1, G2,1, Eval), CoupEval).


getCoupEval(Grille,2,CoupEval):-
	getCoupPossible(Grille, 2, NvGrille,Coup),
	NvGrille = [G1|G2],
	findall([Coup,Eval],evalue(G1, G2,1, Eval), CoupEval).

getCoupList(Grille,Player,CoupListe):-

        findall(CoupL,getCoupEval(Grille,Player,CoupL),CoupListe).

minEvalPlateaux([], _SigneJoueur, _SigneAdv, _Tour, _TourMax, _Prof, _ProfParcourue, _Alpha, _Beta, Acc, Acc).
minEvalPlateaux([[_Plateau,_Case,_Type]|_L], _SigneJoueur, _SigneAdv, _Tour, _TourMax, _Prof, _ProfParcourue, Alpha, Beta, Acc, Acc) :-
        Alpha >= Beta,
        !.
    
minEvalPlateaux([[Plateau,Case,Type]|L], SigneJoueur, SigneAdv, Tour, TourMax, 0, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        evalue([Plateau,Case,Type], SigneJoueur, SigneAdv, ProfParcourue, Eval),
        max_member(Alpha2, [Alpha,Eval]),
        minEvalPlateaux(L, SigneJoueur, SigneAdv, Tour, TourMax, 0, ProfParcourue, Alpha2, Beta, [[[Plateau,Case,Type],Eval]|Acc], CoupsEvalues),
        !.

minEvalPlateaux([[Plateau,Case,g]|L], SigneJoueur, SigneAdv, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        evalue([Plateau,Case,g], SigneJoueur, SigneAdv, ProfParcourue, Eval),
        max_member(Alpha2, [Alpha,Eval]),
        minEvalPlateaux(L, SigneJoueur, SigneAdv, Tour, TourMax, Prof, ProfParcourue, Alpha2, Beta, [[[Plateau,Case,g],Eval]|Acc], CoupsEvalues),
        !.

minEvalPlateaux([[Plateau,Case,p]|L], SigneJoueur, SigneAdv, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        evalue([Plateau,Case,p], SigneJoueur, SigneAdv, ProfParcourue, Eval),
        max_member(Alpha2, [Alpha,Eval]),
        minEvalPlateaux(L, SigneJoueur, SigneAdv, Tour, TourMax, Prof, ProfParcourue, Alpha2, Beta, [[[Plateau,Case,p],Eval]|Acc], CoupsEvalues),
        !.

minEvalPlateaux([[Plateau,Case,Type]|L], SigneJoueur, SigneAdv, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        plateauxSuivants(Plateau, SigneAdv, SigneJoueur, SigneAdv, Tour, TourMax, R),
        Prof2 is Prof - 1,
        ProfParcourue2 is ProfParcourue + 1,
        maxEvalPlateaux(R, SigneJoueur, SigneAdv, Tour, TourMax, Prof2, ProfParcourue2, Alpha, Beta, [], CoupsMaxEvalues),
        minCoups(CoupsMaxEvalues, [_,1000], [_MeillCoup,MeillEval]),
        max_member(Alpha2, [Alpha,MeillEval]),
        minEvalPlateaux(L, SigneJoueur, SigneAdv, Tour, TourMax, Prof, ProfParcourue, Alpha2, Beta, [[[Plateau,Case,Type],MeillEval]|Acc], CoupsEvalues).