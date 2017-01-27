%% AdventOfCode day 19 part a and b 19ab.pl
%% swi-prolog
%% compile: ['19ab.pl']
%%
%% start.
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(lists)).
:- set_prolog_stack(local,  limit(2 000 000 000 000 000 000)).
:- set_prolog_stack(global,  limit(2 000 000 000 000 000 000)).

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    deal_presents(5, 3),
    deal_presents_b(5, 2).

%% Solves the puzzle with 3005290 as input
start:-
    format("Part a: ~n"),
    deal_presents(3005290, Elf),
    pretty_print(Elf),
    format("Part b: ~n"),
    deal_presents_b(3005290, Elf2),
    pretty_print(Elf2).
    
%% Deals the presents and finds the Elf with all presents
%% deal_presents_b(+,-).
%% deal_presents(Key, Elf).
deal_presents_b(Key, Elf):-
    find_nearest_power_of_3(1, Key, PoW),
    PoW1 is PoW * 2,
    (PoW1 < Key ->
     Elf is (PoW + 2*(Key - (2*PoW)));
     Elf is Key - PoW
    ).

%% Finds the nearest power of 3
%% find_nearest_power_of_3(+,+,-).
%% find_nearest_power_of_3(PO, Key, PoW).
find_nearest_power_of_3(PO, Key, PoW):-
    X is 3^PO,
    (X >= Key ->
     X1 is 3^(PO-1),
     PoW is floor(X1);
     PO1 is PO + 1,
     find_nearest_power_of_3(PO1, Key, PoW)
    ).

%% deals the presents for real! Not exploiting the pattern (part a)
%% deal_presents(+,-).
%% deal_presents(NumElfs, Elf).
deal_presents(NumElfs, Elf):-
    findall(X, between(1,NumElfs, X), Ring),
    deal_presents(Ring, [], Elf).

%% Goes through the ever shrinking ring until only one elf remaining
%% deal_presents(+,+,-).
%% deal_presents(Ring, Acc, Elf).
deal_presents([], Acc, Elf):-
    length(Acc, L),
    (L = 1 ->
     nth0(0, Acc, Elf);
     reverse(Acc, Acc1),
     deal_presents(Acc1, [], Elf)
    ).

deal_presents([X], Acc, Elf):-
    append(Acc, [X], Acc1),
    deal_presents([], Acc1, Elf).

deal_presents([X,_|Xs], Acc, Elf):-
    deal_presents(Xs, [X|Acc], Elf).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Elf):-
    format("Elf number ~p gets all the presents ~n", [Elf]).