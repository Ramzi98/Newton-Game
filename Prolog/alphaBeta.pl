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
        M1 is 6 - N,
        M2 is 5 - N,
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
        nb4Signe(GrillePlayer, NB4),
        nb4Signe(GrilleAdversaire, NB4Adv),
        nb3Signe(GrillePlayer, NB3),
        nb3Signe(GrilleAdversaire, NB3Adv),
        nb2Signe(GrillePlayer, NB2),
        nb2Signe(GrilleAdversaire, NB2Adv),
        nb1Signe(GrillePlayer, NB1),
        nb1Signe(GrilleAdversaire, NB1Adv),
        Eval is  4 * (NB4 - NB4Adv) + 3 * (NB3 - NB3Adv) + 2 * (NB2 - NB2Adv) + 1 * (NB1 - NB1Adv).
        
evalue(_GrillePlayer, _GrilleAdversaire, _Prof, 0) :- !. %% A enlver probablement


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 









% R = 1 si la ligne du Plateau débutant (de gauche à droite) par Dep contient N fois ce Signe
nbSigneLigne(SousPlateau, Dep, Signe, N, 1) :-
        Dep2 is Dep + 1,
        Dep3 is Dep + 2,
        Dep4 is Dep + 3,
        Dep5 is Dep + 4,
        nth1(Dep, SousPlateau, C1),
        nth1(Dep2, SousPlateau, C2),
        nth1(Dep3, SousPlateau, C3),
        nth1(Dep4, SousPlateau, C4),
        nth1(Dep5, SousPlateau, C5),
        creerListeSigne(N, Signe, L),
        permutation(L, [C1,C2,C3,C4,C5]),
        !.

nbSigneLigne(_, _, _, _, 0).

% R = 1 si la colonne du Plateau débutant (de haut en bas) par Dep contient N fois ce Signe
nbSigneCol(Plateau, Dep, Signe, N, 1) :-
        Dep2 is Dep + 3,
        Dep3 is Dep + 6,
        nth1(Dep, Plateau, C1),
        nth1(Dep2, Plateau, C2),
        nth1(Dep3, Plateau, C3),
        creerListeSigne(N, Signe, L),
        permutation(L, [C1,C2,C3]),
        !.
nbSigneCol(_, _, _, _, 0).

% R = 1 si la diagonale du Plateau débutant à la case 1 contient N fois ce Signe
nbSigneDiag1(Plateau, Signe, N, 1) :-
        Dep is 1,
        Dep2 is Dep + 4,
        Dep3 is Dep + 8,
        nth1(Dep, Plateau, C1),
        nth1(Dep2, Plateau, C2),
        nth1(Dep3, Plateau, C3),
        creerListeSigne(N, Signe, L),
        permutation(L, [C1,C2,C3]),
        !.
nbSigneDiag1(_, _, _, 0).

% R = 1 si la diagonale du Plateau débutant à la case 5 contient N fois ce Signe
nbSigneDiag2(Plateau, Signe, N, 1) :-
        Dep is 3,
        Dep2 is Dep + 2,
        Dep3 is Dep + 4,
        nth1(Dep, Plateau, C1),
        nth1(Dep2, Plateau, C2),
        nth1(Dep3, Plateau, C3),
        creerListeSigne(N, Signe, L),
        permutation(L, [C1,C2,C3]),
        !.
nbSigneDiag2(_, _, _, 0).

nbNSigne(Plateau, Signe, N, R):-
        nbSigneLigne(Plateau, 1, Signe, N, R1),
        nbSigneLigne(Plateau, 4, Signe, N, R2),
        nbSigneLigne(Plateau, 7, Signe, N, R3),
        nbSigneCol(Plateau, 1, Signe, N, R4),
        nbSigneCol(Plateau, 2, Signe, N, R5),
        nbSigneCol(Plateau, 3, Signe, N, R6),
        nbSigneDiag1(Plateau, Signe, N, R7),
        nbSigneDiag2(Plateau, Signe, N, R8),
        R is R1 + R2 + R3  + R4 + R5 + R6 + R7 + R8.

% Vrai si le Plateau contient R lignes/colonnes/diagonales comportant 1 fois ce Signe
nb1Signe(Plateau, Signe, R) :-
        nbNSigne(Plateau, Signe, 1, R).

% Vrai si le Plateau contient R lignes/colonnes/diagonales comportant 2 fois ce Signe
nb2Signe(Plateau, Signe, R) :-
        nbNSigne(Plateau, Signe, 2, R).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fonction d'évaluation d'un plateau
% 1000 si plateau gagnant, -1000 si perdant, 0 si match nul
% Sinon : f(Plateau) = 2 * (NB2 - NB2Adv) + 1 * (NB1 - NB1Adv)
% Avec NB2 : nb de lignes/col/diag comportant 2 fois notre Signe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evalue([_,_,p], _SigneJoueur, _SigneAdv, Prof, Eval) :- 
        Eval is -1000 + Prof,
        !.
evalue([_,_,g], _SigneJoueur, _SigneAdv, Prof, Eval) :-
        Eval is 1000 - Prof,
        !.
evalue([_,_,n], _SigneJoueur, _SigneAdv, _Prof, 0) :- !.
evalue([Plateau,_,_], SigneJoueur, SigneAdv, _Prof, Eval) :-
        nb2Signe(Plateau, SigneJoueur, NB2),
        nb2Signe(Plateau,SigneAdv, NB2Adv),
        nb1Signe(Plateau, SigneJoueur, NB1),
        nb1Signe(Plateau,SigneAdv, NB1Adv),
        Eval is  2 * (NB2 - NB2Adv) + 1 * (NB1 - NB1Adv).
