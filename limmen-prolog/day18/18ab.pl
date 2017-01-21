%% AdventOfCode day 18 part a and b 18ab.pl
%% swi-prolog
%% compile: ['18ab.pl']
%%
%% start.
%% or
%% count_safe_tiles(+,+,-).
%% count_safe_tiles(Input, MaxRows-1, Result).
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- set_prolog_flag(double_quotes, codes).

safe(46).
trap(94).

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    count_safe_tiles(".^^.^.^^^^", 9, 38).

%% Solves the puzzle with ".^.^..^......^^^^^...^^^...^...^....^^.^...^.^^^^....^...^^.^^^...^^^^.^^.^.^^..^.^^^..^^^^^^.^^^..^" as input
start:-
    Input =  ".^.^..^......^^^^^...^^^...^...^....^^.^...^.^^^^....^...^^.^^^...^^^^.^^.^.^^..^.^^^..^^^^^^.^^^..^",
    format("part a: ~n"),
    count_safe_tiles(Input, 39, NoSafe),
    pretty_print(NoSafe),
    format("part b: ~n"),
    count_safe_tiles(Input, 399999, NoSafe2),
    pretty_print(NoSafe2).

%% Computes rows and counts number of total safe tiles
%% count_safe_tiles(+,+,-).
%% count_safe_tiles(Input, MaxRows, NoSafe).
count_safe_tiles(Input, MaxRows, NoSafe):-
    count_safe_row(Input, Count),
    compute_rows(Input, Count, NoSafe, 0, MaxRows).

%% Counts number of safe tiles in a row
%% count_safe_row(+,-).
%% count_safe_row(Row, SoSafe).
count_safe_row(Row, NoSafe):-
    findall(X, (safe(X), member(X, Row)), All),
    length(All, NoSafe).

%% Computes the rows and counts the safe tiles for each
%% compute_rows(+,+,-,+,+).
%% compute_rows(Prev, CountAcc, Count, Index, MaxRows).
compute_rows(_, Count, Count, MaxRows, MaxRows).

compute_rows(Prev, CountAcc, Count, I, MaxRows):-
    \+ I = MaxRows,
    compute_row(Row, 0, Prev),
    I1 is I + 1,
    count_safe_row(Row, NoSafe),
    CountAcc1 is CountAcc + NoSafe,
    compute_rows(Row, CountAcc1, Count, I1, MaxRows).

%% Computes next row given the previous one
%% compute_row(-,+,+).
%% compute_row(Row, Index, Prev).
compute_row([Pos|X], I, Prev):-
    left_center_right(I, Prev, (Left, Center, Right)),
    new_pos(Left, Center, Right, Pos),
    I1 is I + 1,
    length(Prev, L),
    (I1 < L ->
     compute_row(X, I1, Prev);
     X = []
    ).

%% Gets the Left,Center,Right elements from the previous row given a index
%% left_center_right(+,+,-).
%% left_center_right(Index, Prev, (Left, Center, Right)).
left_center_right(I, Prev, (Left, Center, Right)):-
    nth0(I, Prev, Center),
    ILeft is I - 1,
    IRight is I + 1,
    (nth0(ILeft, Prev, E) ->
     Left = E;
     Left = 46),
    (nth0(IRight, Prev, E2) ->
     Right = E2;
     Right = 46).

%% Calculates new position given Left,Center,Right
%% new_pos(+,+,+,-).
%% new_pos(Left, Center, Right, Pos).
new_pos(Left, Center, Right, Pos):-
    (new_trap(Left, Center, Right) ->
     Pos = 94;
     Pos = 46).

%% Checks if the new position should be a trap or not
%% new_trap(+,+,+).
%% new_trap(Left, Center, Right).
new_trap(Left, Center, Right):-
    trap(Left),
    trap(Center),
    \+ trap(Right).

new_trap(Left, Center, Right):-
    trap(Right),
    trap(Center),
    \+ trap(Left).

new_trap(Left, Center, Right):-
    trap(Left),
    \+ trap(Center),
    \+ trap(Right).

new_trap(Left, Center, Right):-
    trap(Right),
    \+ trap(Center),
    \+ trap(Left).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(SafeTiles):-
    format("Number of safe tiles are: ~p ~n", [SafeTiles]).