-set_prolog_flag(toplevel_print_options, [max_depth(0)]).
-set_prolog_flag(gc, off).
 
:- use_module(library(lists)).
:- set_prolog_flag(toplevel_print_options,[max_depth(0)]).
:- use_module(library(random)).
:- ['./Board_Game.pl'].


%% getLigneElements(1,3,8,[[[1,8],b],[[2,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],E).

getLigneElements(Fin,Fin,L,PG,1) :-
        member([[Fin,L],_],PG),
        !.

getLigneElements(Fin,Fin,L,PG,0) :-
        \+member([[Fin,L],_],PG),
        fail,
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
        fail,
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


nbNSigne(PG, N, R).
        %getLigneElements(1,2,)










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
