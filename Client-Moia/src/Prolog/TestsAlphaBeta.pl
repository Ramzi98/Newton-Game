:- use_module(library(lists)).
:- include('alphaBeta.pl').

:-begin_tests(newtontests).

test('getLigneElementsD',[E == 1] ) :-
getLigneElementsD(1,3,8,[[[1,8],b],[[2,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],E).

test('getLigneElementsG',[E == 0] ) :-
    getLigneElementsG(1,3,8,[[[1,8],b],[[2,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],E).

test('getColElements',[E == 1] ) :-
getColElements(6,4,1,[[[1,6],b],[[1,1],b],[[1,5],b],[[1,4],b],[[1,4],b],[[4,7],b]],E).

test('getDiagElements',[E == 1] ) :-
getDiagElements(1,6,2,[[[1,6],b],[[1,1],b],[[1,5],b],[[1,4],b],[[2,5],b],[[4,7],b]],E).

test('nbNSigne',[E == 1] ) :-
nbNSigne([[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b],[[2,6],b],[[2,5],b]],2,E).

test('InitialEvaluate',[Eval == 0] ) :-
evalue([[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]], [[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]], Prof, Eval).

test('almostBleuWinEvaluate',[E == -13] ) :-
evalue([[[1,7],r],[[2,7],r],[[3,7],r],[[4,7],r],[[5,7],r],[[1,2],r],[[1,3],r],[[1,4],r],[[2,3],r],[[2,4],r]],[[[1,8],b],[[2,8],b],[[3,8],b],[[4,8],b],[[1,6],b],[[2,6],b],[[3,6],b],[[4,6],b],[[1,5],b],[[2,5],b],[[1,1],b]],0,E).

test('BleuWinEvaluate',[E == -1000] ) :-
    evalue([[[1,7],r],[[2,7],r],[[3,7],r],[[4,7],r],[[5,7],r],[[1,2],r],[[1,3],r],[[1,4],r],[[2,3],r],[[2,4],r]],[[[1,8],b],[[2,8],b],[[3,8],b],[[4,8],b],[[1,6],b],[[2,6],b],[[3,6],b],[[4,6],b],[[5,6],b],[[1,5],b],[[2,5],b],[[1,1],b]],0,E).

test('getCoupPossible',[Coup == [[1,7],b]] ) :-
getCoupPossible([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1, NVG, Coup, TypeDepl).

test('getCoupPossible',[TypeDepl == d ]) :-
    getCoupPossible([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1, NVG, Coup, TypeDepl).
test('genererCoup',[TyCoup == n ]) :-
genererCoup([[[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1,79,80,Coup ,NvGrille, TyCoup, Typdepl).

test('parcoursSuivant',[NvGrilleList == [[[[[[1,7],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,8],r],[[3,7],r],[[5,7],r]]],[[1,7],b],n,d],[[[[[3,7],b],[[1,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,8],r],[[5,7],r]]],[[3,7],b],n,d],[[[[[5,7],b],[[1,8],b],[[3,8],b],[[2,6],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,8],r]]],[[5,7],b],n,d],[[[[[1,6],b],[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[1,6],b],n,p],[[[[[2,4],b],[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[2,4],b],n,p],[[[[[3,6],b],[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[3,6],b],n,p],[[[[[4,6],b],[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[4,6],b],n,p],[[[[[5,6],b],[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[5,6],b],n,p]] ]) :-

parcoursSuivant([[[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1,79,80,NvGrilleList).

test('getCoupPossible',[Coup == [[[[[[[1,7],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,8],r],[[3,7],r],[[5,7],r]]],[[1,7],b],2,d]],[[[[[[3,7],b],[[1,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,8],r],[[5,7],r]]],[[3,7],b],2,d]],[[[[[[5,7],b],[[1,8],b],[[3,8],b],[[2,6],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,8],r]]],[[5,7],b],2,d]],[[[[[[1,6],b],[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[1,6],b],6,p]],[[[[[[2,4],b],[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[2,4],b],7,p]],[[[[[[3,6],b],[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[3,6],b],2,p]],[[[[[[4,6],b],[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[4,6],b],2,p]],[[[[[[5,6],b],[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[5,6],b],2,p]]] ]) :-

getCoupList([[[[1,8],b],[[3,8],b],[[2,6],b],[[5,8],b],[[2,7],b],[[2,5],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]], 1, Coup).

test('alphaBeta',[MeilleurCoup == [[[[[1,6],b],[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],[[1,6],b],c,p] ]) :-
alphaBeta([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r]]],1, 0, 80, 8, MeilleurCoup).

test('alphaBeta',[MeilleurCoup == [[[[[1,6],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,8],r],[[3,7],r],[[5,7],r],[[1,7],r],[[2,6],r],[[3,6],r],[[4,6],r],[[1,7],r]]],[[1,6],b],c,d]]) :-
alphaBeta([[[[1,8],b],[[3,8],b],[[5,8],b],[[2,7],b],[[4,7],b]],[[[2,8],r],[[4,8],r],[[1,7],r],[[3,7],r],[[5,7],r],[[1,6],r],[[2,6],r],[[3,6],r],[[4,6],r],[[1,6],r]]],1, 0, 80, 4, MeilleurCoup).
:-end_tests(newtontests).

