-set_prolog_flag(toplevel_print_options, [max_depth(0)]).
-set_prolog_flag(gc, off).
 
:- use_module(library(lists)).
:- set_prolog_flag(toplevel_print_options,[max_depth(0)]).
:- use_module(library(random)).
:- ['./Board_Game.pl'].


%% getLigneElementsD(1,3,8,[[[1,8],b],[[2,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],E).

%%% Calcule de gauche a droite en peut ajouter une autre de droite a gauche
getLigneElementsD(Fin,Fin,L,PG,1) :-
        member([[Fin,L],_],PG),
        !.

getLigneElementsD(Fin,Fin,L,PG,0) :-
        \+member([[Fin,L],_],PG),
        !.

getLigneElementsD(Debut,_,L,PG,0) :-
        \+member([[Debut,L],_],PG),
        !.


getLigneElementsD(Debut,Fin,L,PG,E) :-
        member([[Debut,L],_],PG),
        NvDebut is Debut+1,
        getLigneElementsD(NvDebut,Fin,L,PG,E),
        !.

%getLigneElementsG(1,3,8,[[[1,8],b],[[2,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],E).
getLigneElementsG(Fin,Fin,L,PG,1) :-
        member([[Fin,L],_],PG),
        !.

getLigneElementsG(Fin,Fin,L,PG,0) :-
        \+member([[Fin,L],_],PG),
        !.

getLigneElementsG(Debut,_,L,PG,0) :-
        \+member([[Debut,L],_],PG),
        !.


getLigneElementsG(Debut,Fin,L,PG,E) :-
        member([[Debut,L],_],PG),
        NvDebut is Debut-1,
        getLigneElementsG(NvDebut,Fin,L,PG,E),
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
        getLigneElementsD(1,N,6,PG,R1), %% R1 = 1 si on a N Element dans la ligne 6 de droite a gauche 
        getLigneElementsD(1,N,5,PG,R2), %% R2 = 1 si on a N Element dans la ligne 5 de droite a gauche 
        getLigneElementsD(1,N,4,PG,R3), %% R3 = 1 si on a N Element dans la ligne 4 de droite a gauche 
        getLigneElementsD(1,N,3,PG,R4), %% R4 = 1 si on a N Element dans la ligne 3 de droite a gauche 
        getLigneElementsD(1,N,2,PG,R5), %% R5 = 1 si on a N Element dans la ligne 2 de droite a gauche 
        getLigneElementsD(1,N,1,PG,R6), %% R6 = 1 si on a N Element dans la ligne 1 de droite a gauche 

        getLigneElementsD(5,N,6,PG,R21), %% R1 = 1 si on a N Element dans la ligne 6 de gauche a droite 
        getLigneElementsD(5,N,5,PG,R22), %% R2 = 1 si on a N Element dans la ligne 5 de gauche a droite  
        getLigneElementsD(5,N,4,PG,R23), %% R3 = 1 si on a N Element dans la ligne 4 de gauche a droite 
        getLigneElementsD(5,N,3,PG,R24), %% R4 = 1 si on a N Element dans la ligne 3 de gauche a droite  
        getLigneElementsD(5,N,2,PG,R25), %% R5 = 1 si on a N Element dans la ligne 2 de gauche a droite  
        getLigneElementsD(5,N,1,PG,R26), %% R6 = 1 si on a N Element dans la ligne 1 de gauche a droite 

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

        R is R1 + R2 + R3 + R4 + R5 + R6 + R7 + R8 + R9 + R10 + R11 + R12 + R13 + R14 + R15 + R16 + R17 + R18 + R19 + R20 + R21 + R22 + R23 + R24 + R25 + R26.
        %R is R1 + R2 + R3 + R4 + R5 + R6 + R7 + R8 + R9 + R10 + R11 + R12 + R13 + R14 + R15 + R16 + R17 + R18 + R19 + R20.

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
minCoups([[Coup,Eval]|L], [_MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]) :-
        Eval =< MeillEvalActuel,
        minCoups(L, [Coup,Eval], [MeillCoup,MeillEval]),
        !.

minCoups([_|L], [MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]) :-
        minCoups(L, [MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]).

%maxCoups([[[[[1,6],b],6]],[[[[2,4],b],7]],[[[[3,6],b],2]],[[[[4,6],b],2]],[[[[5,6],b],2]]],[0,0],S).
maxCoups([], Meilleur, Meilleur).
maxCoups([[Coup,Eval]|L], [_MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]) :-
        Eval >= MeillEvalActuel,
        maxCoups(L, [Coup,Eval], [MeillCoup,MeillEval]),
        !.

maxCoups([_|L], [MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]) :-
        maxCoups(L, [MeillCoupActuel,MeillEvalActuel], [MeillCoup,MeillEval]).


%getCoupPossible([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1, NVG, Coup, TypeDepl).



getCoupPossible(Grille,1,NvGrille,Coup, TypeDeplacement):-
	deplacementN(Grille,1,NvGrille, TypeDeplacement),
	NvGrille = [G1,_],
	G1 = [Coup|_].


getCoupPossible(Grille,2,NvGrille,Coup, TypeDeplacement):-
	deplacementN(Grille,2,NvGrille, TypeDeplacement),
	NvGrille = [_,G2],
	G2 = [Coup|_].


getCoupEval(Grille,1,CoupEval):-
	getCoupPossible(Grille, 1, NvGrille,Coup, TypeDeplacement),
	NvGrille = [G1|G2],
	findall([NvGrille,Coup,Eval,TypeDeplacement],evalue(G1, G2,1, Eval), CoupEval).


getCoupEval(Grille,2,CoupEval):-
	getCoupPossible(Grille, 2, NvGrille,Coup, TypeDeplacement),
	NvGrille = [G1|G2],
	findall([NvGrille,Coup,Eval,TypeDeplacement],evalue(G1, G2,1, Eval), CoupEval).


arretJoueur(Grille,Player,_Tour,_TourMax,g):-
        etatGagnant(Grille,Player),
        !.

arretJoueur(Grille,Player,_Tour,_TourMax,p):-
        Player = 1,
        etatGagnant(Grille,2),
        !.

arretJoueur(Grille,Player,_Tour,_TourMax,p):-
        Player = 2,
        etatGagnant(Grille,1),
        !.
arretJoueur(_Grille,_Player,TourMax,TourMax,n):- !.
arretJoueur(_Grille,_Player,_Tour,_TourMax,c):- !.


%genererCoup([[[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1,79,80,Coup ,NvGrille, TyCoup, Typdepl).
genererCoup(Grille,Player,Tour,TourMax,Coup,NvGrille,TypeCoup,TypeDeplacement):-

        getCoupPossible(Grille,Player,NvGrille,Coup, TypeDeplacement),
        TourN is Tour+1,
        arretJoueur(NvGrille,Player,TourN,TourMax,TypeCoup).

%parcoursSuivant([[[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1,79,80,NvGrilleList).
parcoursSuivant(Grille,Player,Tour,TourMax,NvGrilleList):-

        findall([NvGrille, Coup, TypeCoup, TypeDeplacement],genererCoup(Grille,Player,Tour,TourMax,Coup,NvGrille,TypeCoup ,TypeDeplacement),NvGrilleList).


%getCoupEval([[[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1, Coup).

%getCoupList([[[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1, Coup).
getCoupList(Grille,Player,CoupListe):-

        findall(CoupL,getCoupEval(Grille,Player,CoupL),CoupListe).

%a revoir
minEvalPlateaux([], _Player, _Tour, _TourMax, _Prof, _ProfParcourue, _Alpha, _Beta, Acc, Acc).
minEvalPlateaux([[[_Grille,_Coup,_TypeCoup,_TypeDeplacement]|_LGrille]|_L], _Player, _Tour, _TourMax, _Prof, _ProfParcourue, Alpha, Beta, Acc, Acc) :-
        Alpha >= Beta,
        !.
    
minEvalPlateaux([[Grille,Coup,TypeCoup,TypeDeplacement]|LGrille], Player, Tour, TourMax, 0, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        Grille = [G1,G2],
        evalue(G1, G2, ProfParcourue, Eval),
        max_member(Alpha2, [Alpha,Eval]),
        minEvalPlateaux(LGrille,Player, Tour, TourMax, 0, ProfParcourue, Alpha2, Beta, [[[[Grille,Coup,TypeCoup,TypeDeplacement]|LGrille],Eval]|Acc], CoupsEvalues),
        !.

minEvalPlateaux([[Grille,Coup,g,TypeDeplacement]|LGrille], Player, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        Grille = [G1,G2],
        evalue(G1, G2, ProfParcourue, Eval),
        max_member(Alpha2, [Alpha,Eval]),
        minEvalPlateaux(LGrille, Player, Tour, TourMax, Prof, ProfParcourue, Alpha2, Beta, [[[[Grille,Coup,g,TypeDeplacement]|LGrille],Eval]|Acc], CoupsEvalues),
        !.


minEvalPlateaux([[Grille,Coup,p,TypeDeplacement]|LGrille], Player, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        Grille = [G1,G2],
        evalue(G1, G2, ProfParcourue, Eval),
        max_member(Alpha2, [Alpha,Eval]),
        minEvalPlateaux(LGrille, Player, Tour, TourMax, Prof, ProfParcourue, Alpha2, Beta, [[[[Grille,Coup,p,TypeDeplacement]|LGrille],Eval]|Acc], CoupsEvalues),
        !.

minEvalPlateaux([[Grille,Coup,TypeCoup,TypeDeplacement]|LGrille], Player, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        parcoursSuivant(Grille, Player, Tour, TourMax, PS),
        Prof2 is Prof - 1,
        ProfParcourue2 is ProfParcourue + 1,
        maxEvalPlateaux(PS, Player, Tour, TourMax, Prof2, ProfParcourue2, Alpha, Beta, [], CoupsMaxEvalues),
        minCoups(CoupsMaxEvalues, [_,1000], [_MeillCoup,MeillEval]),
        max_member(Alpha2, [Alpha,MeillEval]),
        minEvalPlateaux(LGrille, Player, Tour, TourMax, Prof, ProfParcourue, Alpha2, Beta, [[[Grille,Coup,TypeCoup,TypeDeplacement],MeillEval]|Acc], CoupsEvalues).


maxEvalPlateaux([], _Player, _Tour, _TourMax, _Prof, _ProfParcourue, _Alpha, _Beta, Acc, Acc).
maxEvalPlateaux([[_Grille,_Coup,_TypeCoup,_TypeDeplacement]|_L], _Player, _Tour, _TourMax, _Prof, _ProfParcourue, Alpha, Beta, Acc, Acc) :-
        Alpha >= Beta,
        !.
maxEvalPlateaux([[Grille,Coup,TypeCoup,TypeDeplacement]|LGrille], Player, Tour, TourMax, 0, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        Grille = [G1,G2],
        evalue(G1, G2, ProfParcourue, Eval),
        min_member(Beta2, [Beta,Eval]),
        maxEvalPlateaux(LGrille, Player, Tour, TourMax, 0, ProfParcourue, Alpha, Beta2, [[[Grille,Coup,TypeCoup,TypeDeplacement],Eval]|Acc], CoupsEvalues),
        !.

maxEvalPlateaux([[Grille,Coup,g,TypeDeplacement]|LGrille], Player, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        Grille = [G1,G2],
        evalue(G1, G2, ProfParcourue, Eval),
        min_member(Beta2, [Beta,Eval]),
        maxEvalPlateaux(LGrille, Player, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta2, [[[Grille,Coup,g,TypeDeplacement],Eval]|Acc], CoupsEvalues),
        !.

maxEvalPlateaux([[Grille,Coup,p,TypeDeplacement]|LGrille], Player, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        Grille = [G1,G2],
        evalue(G1, G2, ProfParcourue, Eval),
        min_member(Beta2, [Beta,Eval]),
        maxEvalPlateaux(LGrille, Player, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta2, [[[Grille,Coup,p,TypeDeplacement],Eval]|Acc], CoupsEvalues),
        !.

maxEvalPlateaux([[Grille,Coup,TypeCoup,TypeDeplacement]|LGrille], Player, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta, Acc, CoupsEvalues) :-
        parcoursSuivant(Grille, Player, Tour, TourMax, PS),
        Prof2 is Prof - 1,
        ProfParcourue2 is ProfParcourue + 1,
        minEvalPlateaux(PS, Player, Tour, TourMax, Prof2, ProfParcourue2, Alpha, Beta, [], CoupsMinEvalues),
        maxCoups(CoupsMinEvalues, [_,-1000], [_MeillCoup,MeillEval]),
        min_member(Beta2, [Beta,MeillEval]),
        maxEvalPlateaux(LGrille,Player, Tour, TourMax, Prof, ProfParcourue, Alpha, Beta2, [[[Grille,Coup,TypeCoup,TypeDeplacement],MeillEval]|Acc], CoupsEvalues).

%alphaBeta([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],1, 0, 80, 8, MeilleurCoup).
%parcoursSuivant([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],1, 0, 80, 10, PS).
%minEvalPlateaux([[[[[[1,7],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,8],r],[[3,7],r],[[5,7],r]]],[[1,7],b],c],[[[[[3,7],b],[[1,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,8],r],[[5,7],r]]],[[3,7],b],c],[[[[[5,7],b],[[1,8],b],[[3,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,8],r]]],[[5,7],b],c],[[[[[1,6],b],[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[1,6],b],c],[[[[[2,6],b],[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[2,6],b],c],[[[[[3,6],b],[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[3,6],b],c],[[[[[4,6],b],[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[4,6],b],c],[[[[[5,6],b],[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[5,6],b],c]], 1, 1, 80, 9, 1, -10000, 10000, [], CoupsEvalues).,

%alphaBeta([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r],[[1,6],r],[[2,6],r],[[3,6],r],[[4,6],r],[[1,6],r]]],1, 0, 80, 4, MeilleurCoup).

alphaBeta(Grille,Player, Tour, TourMax, Prof, MeilleurCoup) :-
        parcoursSuivant(Grille, Player, Tour, TourMax, PS),
        Prof2 is Prof - 1,
        minEvalPlateaux(PS, Player, Tour, TourMax, Prof2, 1, -10000, 10000, [], CoupsEvalues),
        maxCoups(CoupsEvalues, [_,-1000], [MeilleurCoup,_]).
