%% AdventOfCode day 14 part b 14b.pl
%% swi-prolog
%% compile: ['14b.pl']
%%
%% start.
%% or
%% gen_hashes(+,-).
%% gen_hashes(Salt, HashIndex)
%%
%% TODO: Gives correct result but is still rather time consuming even when using caching.
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

use_module(library(md5)).

:- set_prolog_flag(double_quotes, codes).
:- dynamic(computed_hash/2).

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    hash("abc0", "a107ff634856bb300138cac6568c0f24"),
    gen_hashes("abc", 22551).

%% Solves the puzzle with the salt "cuanljph"
start:-
    gen_hashes("cuanljph", Index),
    pretty_print(Index).

%% cleanup predicate
end:-
    retractall(computed_hash(_)).

%% Computes hash with stretching
%% hash(+,-).
%% hash(PreImage, Hash).
hash(PreImage, Hash):-
    computed_hash(PreImage, Hash).

hash(PreImage, Hash):-
    \+ computed_hash(PreImage, _),
    md5_hash(PreImage, Digest, []),
    atom_codes(Digest, DigestStr),
    stretch(DigestStr, Hash),
    assertz(computed_hash(PreImage, Hash)).

%% Stretches a given hash 2016 times
%% stretch(+,-).
%% stretch(Digest, Stretched).
stretch(Digest, Stretched):-
    stretch(Digest, 0, Stretched).

stretch(Digest,  2016, Digest).

stretch(Digest, N, Stretched):-
    N < 2016,
    md5_hash(Digest, Digest2, []),
    atom_codes(Digest2, Digest2Str),
    N1 is N + 1,
    stretch(Digest2Str, N1, Stretched).

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
     Count1 is Count + 1,
     format("Found key, count is: ~p, Index is: ~p ~n",[Count1, Index]);
     Count1 is Count
    ),
    Index1 is Index + 1,
    gen_hashes(Salt, Index1, Count1, KeyIndex).

%% Checks whether hashing Salt with given Index is a key
%% key(+,+).
%% key(Salt, Index).
key(Salt, Index):-
    number_codes(Index, IndexStr),
    append(Salt, IndexStr, PreImage),
    hash(PreImage, DigestStr),
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
    append(Salt, IndexStr, PreImage),
    hash(PreImage, DigestStr),
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