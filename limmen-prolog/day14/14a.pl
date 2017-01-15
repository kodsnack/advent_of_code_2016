%% AdventOfCode day 14 part a 14a.pl
%% swi-prolog
%% compile: ['14a.pl']
%%
%% start.
%% or
%% gen_hashes(+,-).
%% gen_hashes(Salt, HashIndex)
%%
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

use_module(library(md5)).

:- set_prolog_flag(double_quotes, codes).

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    gen_hashes("abc", 22728).

%% Solves the puzzle with the salt "cuanljph"
start:-
    gen_hashes("cuanljph", Index),
    pretty_print(Index).

%% Generates hashes until the 64th key is found and returns the number of hashes generated to find it
%% gen_hashes(+,-).
%% gen_hashes(Salt, KeyIndex).
gen_hashes(Salt, KeyIndex):-
    gen_hashes(Salt, 0, 0, KeyIndex).

gen_hashes(_, Index, 64, KeyIndex):-
    KeyIndex is Index - 1.

gen_hashes(Salt, Index, Count, KeyIndex):-
    Count < 64,
    (key(Salt, Index) ->
     Count1 is Count + 1;
     Count1 is Count
    ),
    Index1 is Index + 1,
    gen_hashes(Salt, Index1, Count1, KeyIndex).

%% Checks whether hashing Salt with given Index is a key
%% key(+,+).
%% key(Salt, Index).
key(Salt, Index):-
    number_codes(Index, IndexStr),
    append(Salt, IndexStr, Preimage),
    md5_hash(Preimage, Digest, []),
    atom_codes(Digest, DigestStr),
    contains_three(DigestStr, X),
    !,
    Index1 is Index + 1,
    next_1000(Salt, Index1, 0, X).

%% Checks whether the next 1000 hashes contains five subsequent X
%% next_1000(+,+,+,+).
%% next_1000(Salt, Index, Index2, X).
next_1000(Salt, Index, Index2, X):-
    Index2 =< 1000,
    number_codes(Index, IndexStr),
    append(Salt, IndexStr, Preimage),
    md5_hash(Preimage, Digest, []),
    atom_codes(Digest, DigestStr),
    (contains_five(DigestStr, X)
    ;
     (
      \+ contains_five(DigestStr, X),
      Index1 is Index + 1,
      Index20 is Index2 + 1,
      next_1000(Salt, Index1, Index20, X)
     )).

%% Checks wether a given hash contains a triple of X
%% contains_three(+,-).
%% contains_three(Hash, X).
contains_three([X,X,X|_], X):-
    !.
contains_three([_|T], X):-
    contains_three(T, X).

%% Checks wether a given hash contains a sequence of length 5 of X
%% contains_five(+,-).
%% contains_five(Hash, X).
contains_five([X,X,X,X,X|_], X):-
    !.
contains_five([_|T], X):-
    contains_five(T, X).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(KeyIndex):-
    format("The index of the 64th key is ~p ~n", [KeyIndex]).