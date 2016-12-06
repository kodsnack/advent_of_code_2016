%% AdventOfCode day 1 1b.pl
%% swi-prolog
%% compile: ['1b.pl']
%%
%% start.
%% or
%% solve(+,-,-,-,-)
%%
%% solve(Input,Nort, South, East, West)
%% North is the number of blocks north of first location visited twice
%% South is the number of blocks south of first location visited twice
%% East is the number of blocks east of first location visited twice
%% West is the number of blocks West of first location visited twice
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%% Facts

left(76).
right(82).

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    solve("R8, R4, R4, R8", 0, 0, 4, -4).

%% Solves the puzzle with the inputstring 1a.txt
start:-
    read_input(Input),
    !,
    solve(Input, N, S ,E ,W),
    pretty_print(N, S, E, W).

%% Reads inputstring
%% read_input(-).
%% read_input(VariableToStoreInput).
read_input(Input):-
    open("1a.txt", read, Stream),
    read_input(Stream, [], [], Input),
    close(Stream).

read_input(_, Input, end_of_file, Input).

read_input(Stream, Lines, Line, Input):-
    append(Lines, Line, Lines1),
    read_line_to_codes(Stream,Line1),
    read_input(Stream, Lines1, Line1, Input).

%% Solves the puzzle
%% solve(+,-,-,-,-).
%% solve(InputString, NorthPos, SouthPos, EastPos, WestPos).
solve(Input, N, S, E, W):-
    solve(Input, north, 0, 0, 0, 0, N, S, E, W, []).

solve([], _, N, S, W, E, N, S, W, E, Pos):-
    member((N,S,W,E), Pos),
    !.

solve([], _, _, _, _, _, _, _, _, _, _):-
    fail.

solve([32|Y], Direction, N1, S1 , E1, W1, N, S, E, W, Pos):-
    solve(Y, Direction, N1, S1, E1, W1, N, S, E, W, Pos).


solve([Turn|Y], Direction, N1, S1 , E1, W1, N, S, E, W, Pos):-
    get_steps(Y, [], Steps, Rest),
    turn(Direction, Turn, NewDirection),
    move_steps(NewDirection, Steps, N1, S1, E1, W1, N2, S2, E2, W2, Pos, Pos1),
    !,
    solve(Rest, NewDirection, N2, S2, E2, W2, N, S, E, W, Pos1).

%% Retrieve the number of steps from the text parsed from the input file
%% get_steps(+,+,-,-).
%% get_steps(InputString, Accumulator, Steps, RestOfInputString)
get_steps([], Acc, Steps, []):-
    atom_codes(T, Acc),
    atom_number(T, Steps).

get_steps([44|R], Acc, Steps, R):-
    atom_codes(T, Acc),
    atom_number(T, Steps).

get_steps([X|Y], Acc, Res, R):-
    append(Acc, [X], Acc2),
    get_steps(Y, Acc2, Res, R).

%% Move steps in the facing direction. For each position, check if it have been visited before.
%% move_steps(+,+,+,+,+,+,-,-,-,-,+,-)
%% move_steps(FacingDirection, NoSteps, NorthPos, SouthPos, EastPos, WestPos, NewNorthPos, NewSouthPos, NewEastPos, NewWestPos, ListOfVisitedPos, NewListOfVisitedPos).
move_steps(_, _, N, S, E, W, N, S, E, W, Pos, Pos):-    
    member((N, S, E, W), Pos).

move_steps(_, 0, N, S, E ,W, N, S, E, W, Pos, Pos).

move_steps(north, Steps, N, S, E, W, N2, S2, E2, W2, Pos, Pos1):-
    N1 is N + 1,
    S1 is S - 1,
    Steps1 is Steps - 1,    
    move_steps(north, Steps1, N1, S1, E, W, N2, S2, E2, W2, [(N, S, E, W)| Pos], Pos1).

move_steps(south, Steps, N, S, E, W, N2, S2, E2, W2, Pos, Pos1):-
    N1 is N - 1,
    S1 is S + 1,
    Steps1 is Steps - 1,    
    move_steps(south, Steps1, N1, S1, E, W, N2, S2, E2, W2, [(N, S, E, W)| Pos], Pos1).

move_steps(west, Steps, N, S, E, W, N2, S2, E2, W2, Pos, Pos1):-
    W1 is W + 1,
    E1 is E - 1,
    Steps1 is Steps - 1,    
    move_steps(west, Steps1, N, S, E1, W1, N2, S2, E2, W2, [(N, S, E, W)| Pos], Pos1).

move_steps(east, Steps, N, S, E, W, N2, S2, E2, W2, Pos, Pos1):-
    W1 is W - 1,
    E1 is E + 1,
    Steps1 is Steps - 1,    
    move_steps(east, Steps1, N, S, E1, W1, N2, S2, E2, W2, [(N, S, E, W)| Pos], Pos1).

%% Turn and change direction
%% turn(+,+,-).
%% turn(FacingDirection, TurningDirection, NewDirection).
turn(north, Turn, west):-
    left(Turn).

turn(north, Turn, east):-
    right(Turn).

turn(south, Turn, east):-
    left(Turn).

turn(south, Turn, west):-
    right(Turn).

turn(west, Turn, south):-
    left(Turn).

turn(west, Turn, north):-
    right(Turn).

turn(east, Turn, north):-
    left(Turn).

turn(east, Turn, south):-
    right(Turn).

%% Pretty print the result
%% pretty_print(+,+,+,+).
%% pretty_print(NorthPos, SouthPos, EastPos, WestPos).
pretty_print(N, _, E, _):-
    N > 0,
    E > 0,
    T is N + E,
    format("First location visited twice is ~p blocks North, ~p blocks East, Total ~p blocks away ~n", [N, E, T]).

pretty_print(_, S, E, _):-    
    S > 0,
    E > 0,
    T is S + E,
    format("First location visited twice is ~p blocks South, ~p blocks East, Total ~p blocks away ~n", [S, E, T]).

pretty_print(N, _ , _, W):-
    N > 0,
    W > 0,
    T is N + W,
    format("First location visited twice is ~p blocks North, ~p blocks West, Total ~p blocks away ~n", [N, W, T]).

pretty_print(_, S, _, W):-
    S > 0,
    W > 0,
    T is S + W,
    format("First location visited twice is ~p blocks South, ~p blocks West, Total ~p blocks away ~n", [S, W, T]).

%%%===================================================================
%%% Facts
%%%===================================================================

left(76).
right(82).
