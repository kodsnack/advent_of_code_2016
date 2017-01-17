%% AdventOfCode day 16 part a and b 16ab.pl
%% swi-prolog
%% compile: ['16ab.pl']
%%
%% start.
%% or
%% get_checksum(+,-).
%% get_checksum(Input, CheckSum).
%%
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(lists)).
:- set_prolog_flag(double_quotes, codes).
:- set_prolog_flag(optimise, true).
:- set_prolog_stack(local,  limit(2 000 000 000 000 000 000)).
:- set_prolog_stack(global,  limit(2 000 000 000 000 000 000)).

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    extend([1], [1,0,0]),
    extend([0], [0,0,1]),
    extend([1,1,1,1,1], [1,1,1,1,1,0,0,0,0,0,0]),
    extend([1,1,1,1,0,0,0,0,1,0,1,0], [1,1,1,1,0,0,0,0,1,0,1,0,0,1,0,1,0,1,1,1,1,0,0,0,0]).

%% Solves the puzzle with "11101000110010100" as input
start:-
    fill_disk([1,1,1,0,1,0,0,0,1,1,0,0,1,0,1,0,0], 272, Filled),
    get_checksum(Filled, CheckSum),
    format("Part a: ~n"),
    pretty_print(CheckSum),
    !,
    fill_disk([1,1,1,0,1,0,0,0,1,1,0,0,1,0,1,0,0], 35651584, Filled2),
    !,
    get_checksum(Filled2, CheckSum2),
    reverse(CheckSum2, CheckSum3),
    format("Part b: ~n"),
    pretty_print(CheckSum3).

%% Fills the disk
%% fill_disk(+,+,-).
%% fill_disk(State, Size, Filled).
fill_disk(State, Size, Filled):-
    length(State, L),
    (L < Size ->
     extend(State, State1),
     fill_disk(State1, Size, Filled);
     string_codes(Str, State),
     sub_string(Str, 0, Size, _, FilledStr),
     string_codes(FilledStr, Filled)
    ).

%% One extend-interation
%% extend(+,-).
%% extend(Input, Extended).
extend(A, New):-
    B = A,
    reverse(B, B1),
    replace_0(B1, [], B2),    
    append(A, [0|B2], New).

%% Swaps 0 and 1
%% replace_0(+,+,-).
%% replace_0(Input, Acc, Swapped).
replace_0([], Acc, Acc1):-
    reverse(Acc, Acc1).

replace_0([1|T], Acc, Res):-
    replace_0(T, [0|Acc], Res).

replace_0([0|T], Acc, Res):-
    replace_0(T, [1|Acc], Res).

%% Gets the checksum of some state
%% get_checksum(+,-).
%% get_checksum(State, CheckSum).
get_checksum(Data, Chk1):-
    parse_checksum(Data, [], Chk0),
    length(Chk0, L),
    ((1 is L mod 2) ->
     Chk1 = Chk0;
     !,
     get_checksum(Chk0, Chk1)).

%% Parses the input for the checksum
%% parse_checksum(+,+,-).
%% parse_checksum(State, Acc, Parsed).
parse_checksum([], Acc, Acc).

parse_checksum([_], Acc, Acc).

parse_checksum([X,X|Y], Acc, CheckSum):-
    parse_checksum(Y,[1|Acc], CheckSum).

parse_checksum([X,Y|Y0], Acc, CheckSum):-
    \+ Y = X,
    parse_checksum(Y0, [0|Acc], CheckSum).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(CheckSum):-
    format("The CheckSum is: ~p ~n", [CheckSum]).