:- use_module(library(lists)).
:- include('Board_Game.pl').



%%%%%%%%%%%%%%%%%%%%%%%%% Les tests unitaires :%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:-begin_tests(newtontests).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test('etatGagnant(Grille,Player)',[Joueur == 1]) :-
    etatGagnant([
        [[[1,6],b],[[1,3],b],[[1,5],b],[[1,4],b],[[1,1],b],[[1,2],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],
        [[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]
            ], Joueur).

test('etatGagnant(Grille,Player)',[Joueur == 2]) :-
    etatGagnant([
        [[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],
        [[[1,6],r],[[2,6],r],[[3,6],r],[[4,6],r],[[5,6],r],[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]
            ], Joueur).

test('etatGagnant(Grille,Player)',[Joueur == 2]) :-
    etatGagnant([
        [[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],
        [[[1,6],r],[[2,5],r],[[3,4],r],[[4,3],r],[[5,2],r],[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]
            ], Joueur).

test('etatGagnant(Grille,Player)',[Joueur == 2]) :-
    etatGagnant([
        [[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],
        [[[5,6],r],[[4,5],r],[[3,4],r],[[2,3],r],[[1,2],r],[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]
            ], Joueur).

test('etatGagnant(Grille,Player)',[Joueur == 1]) :-
    etatGagnant([
        [[[1,5],b],[[2,4],b],[[3,3],b],[[4,2],b],[[5,1],b],[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],
        [[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]
            ], Joueur).

test('etatGagnant(Grille,Player)',[Joueur == 1]) :-
    etatGagnant([
        [[[5,5],b],[[4,4],b],[[3,3],b],[[2,2],b],[[1,1],b],[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],
        [[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]
            ], Joueur).

test('moveDown(Colonne, Grille, NvGrille)',[NVG == [[[2,8],r],[[4,8],r],[[1,8],r],[[3,7],r],[[5,7],r]]]) :-
    moveDown(1, [[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]], NVG).

test('moveDown(Colonne, Grille, NvGrille)',[NVG == [[[1,7],r],[[4,8],r],[[1,8],r],[[3,7],r],[[5,7],r]]]) :-
    moveDown(1, [[[1,6],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]], NVG).


:-end_tests(newtontests).





