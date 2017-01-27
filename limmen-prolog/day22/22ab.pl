%% AdventOfCode day 22 part a and b 22ab.pl
%% swi-prolog
%% compile: ['22ab.pl']
%%
%% start.
%% or
%% count_viable_pairs(Nodes, Count) vs part_b(Nodes)
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(pio)).
:- use_module(library(dcg/basics)).
:- use_module(library(lists)).
:- set_prolog_flag(double_quotes, codes).
:- set_prolog_stack(local,  limit(2 000 000 000 000 000 000)).
:- set_prolog_stack(global,  limit(2 000 000 000 000 000 000)).

%%%===================================================================
%%% Definite Clause Grammars for parsing input file
%%%===================================================================

parse_file(X) --> string(_), "\n", string(_), "\n", nodes(X).

nodes([]) --> eos.
nodes([]) --> "\n\n".
nodes([X|Xs]) --> node(X), "\n", nodes(Xs).

node(node(x(X), y(Y), size(Size), used(Used), avail(Avail), use_p(UseP))) --> "/dev/grid/node-x", integer(X), "-y", integer(Y), blanks, integer(Size), "T", blanks, integer(Used), "T", blanks, integer(Avail), "T", blanks, integer(UseP), "%".

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Solves the puzzle with 21.txt as input
start:-
    phrase_from_file(parse_file(Nodes), "22.txt"),
    format("Part a: ~n"), 
    count_viable_pairs(Nodes, Count),
    pretty_print(Count),
    format("Part b, Matrix: ~n"), 
    part_b(Nodes).

%% Prints the matrix for part b
%% part_b(+).
%% part_b(Nodes).
part_b(Nodes):-
    rows(Nodes, NoRows),
    columns(Nodes, NoColumns),
    print_matrix(0,0, NoColumns, NoRows, Nodes).

%% Counts the number of viable pairs
%% count_viable_paris(+,-)
%% count_viable_pairs(Nodes, Count).
count_viable_pairs(Nodes, Count):-
    findall(Pair, viable_pair(Nodes, Pair), AllPairs),
    length(AllPairs, Count).

%% Attempts to find a viable pair
%% viable_pair(+,-).
%% viable(Nodes, Pair).
viable_pair(Nodes, (A, B)):-
    member(A, Nodes),
    member(B, Nodes),
    A = node(_, _, _, used(UsedA), _, _),
    B = node(_, _, _, _, avail(AvailB), _),
    UsedA > 0,
    \+ A = B,
    UsedA =< AvailB.

%% Counts number of columns for the matrix
%% columns(+,-).
%% columns(Nodes, NoColumns).
columns(Nodes, NoColumns):-
    member(C, Nodes),
    C = node(x(NoColumns),_, _, _, _, _),
    \+ (member(N, Nodes), N = node(x(X1), _, _, _, _, _), X1 > NoColumns).

%% Counts number of rows for the matrix
%% rows(+,-).
%% rows(Nodes, NoRows).
rows(Nodes, NoRows):-
    member(R, Nodes),
    R = node(_,y(NoRows), _, _, _, _),
    \+ (member(N, Nodes), N = node(_, y(Y1), _, _, _, _), Y1 > NoRows).

%% Prints the matrix one position at a time
%% print_matrix(+,+,+,+,+).
%% print_matrix(X,Y, NoColumns, NoRows, Nodes).
print_matrix(NoColumns, NoRows, NoColumns, NoRows, Nodes):-
    print_position(NoColumns, NoRows, NoColumns, NoRows, Nodes).

print_matrix(NoColumns, Y, NoColumns, NoRows, Nodes):-
    print_position(NoColumns, Y, NoColumns, NoRows, Nodes),
    Y1 is Y + 1,
    print_matrix(0, Y1, NoColumns, NoRows, Nodes).

print_matrix(X, Y, NoColumns, NoRows, Nodes):-
    X < NoColumns,
    print_position(X, Y, NoColumns, NoRows, Nodes),
    X1 is X + 1,
    print_matrix(X1, Y, NoColumns, NoRows, Nodes).

%% Prints a single position in the matrix
%% print_position(+,+,+,+,+).
%% print_position(X,Y, NoColumns, NoRows, Nodes).
print_position(NoColumns, Y, NoColumns, _, Nodes):-
    \+ Y = 0,
    member(N, Nodes),
    N = node(x(NoColumns), y(Y), size(Size), _, _, _),
    (Size = 0 ->
     format("_\n");
     (can_move(N, Nodes) ->
      format(".\n");
      format("#\n")
     )
    ).

print_position(NoColumns, 0, NoColumns, _, _):-
    format("G~n").

print_position(0, 0, _, _, Nodes):-
    member(N, Nodes),
    N = node(x(0), y(0), _, used(Used), _, _),
    (Used = 0 ->
     format("(_)");
     (can_move(N, Nodes) ->
      format("(.)");
      format("(#)")
     )
    ).

print_position(X, Y, NoColumns, _, Nodes):-
    \+ (X = 0, Y = 0),
    \+ X = NoColumns,
    member(N, Nodes),
    N = node(x(X), y(Y), _, used(Used), _, _),
    (Used = 0 ->
     format("_");
     (can_move(N, Nodes) ->
      format(".");
      format("#")
     )
    ).

%% Checks if a given node can move or too full
%% can_move(+,+).
%% can_move(Z, Nodes).
can_move(Z, Nodes):-
    Z = node(_, _, _, used(Used), _, _),
    member(N, Nodes),
    N = node(_, _, _, _, avail(Avail), _),
    \+ Z = N,
    Avail >= Used.

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(PairsCount):-
    format("Number of viable pairs is: ~p ~n", [PairsCount]).