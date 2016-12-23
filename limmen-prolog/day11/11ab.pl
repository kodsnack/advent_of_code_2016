%% AdventOfCode day 11 11ab.pl
%% swi-prolog
%% compile: ['11ab.pl']
%%
%% start.
%% or
%% solve_all(+,-).
%% solve_all(ParsedInput, MinimumSteps)
%%
%% solves both problem a and b.
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- dynamic(best_sol/1).
:- dynamic(snaps/1).

floor(first).
floor(second).
floor(third).
floor(fourth).

num(first, 1).
num(second, 2).
num(third, 3).
num(fourth, 4).

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    S1 = "The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.",
    S2 = "The second floor contains a hydrogen generator.",
    S3 = "The third floor contains a lithium generator.",
    S4 = "The fourth floor contains nothing relevant.",
    assertz(best_sol(inf)),
    assertz(snaps([])),
    parse([S1,S2,S3,S4], Floors),
    solve_all(Floors, 11),
    end.

%% cleanup predicate
end:-
    retractall(best_sol(_)),
    retractall(snaps(_)).

%% Solves the puzzle with 11.txt as input string
start:-
    get_input(Input),
    !,
    assertz(best_sol(inf)),
    assertz(snaps([])),
    parse(Input, Floors),
    solve_all(Floors, MinSteps),
    end,
    pretty_print_a(MinSteps),
    assertz(best_sol(inf)),
    assertz(snaps([])),
    Floors1 = Floors.put(first, [(elerium, generator), (elerium, microchip), (dilithium, generator), (dilithium, microchip)|Floors.first]),
    solve_all(Floors1, MinSteps1),
    pretty_print_b(MinSteps1).

%% Reads inputstring
%% read_input(-).
%% read_input(VariableToStoreReadData).
get_input(Input):-
    open("11.txt", read, Stream),
    read_line_to_string(Stream,Line1),
    get_input(Stream, Line1, Input).

get_input(Stream, Line1, Input):-
    get_input(Stream, Line1, [], Input).

get_input(_, end_of_file, Input, Input).

get_input(Stream, Line, Acc, Input):-
    append(Acc, [Line], Acc1),
    read_line_to_string(Stream,Line1),
    get_input(Stream, Line1, Acc1, Input).

%% Parses the input line by line
%% parse(+,-).
%% parse(Input, Floors).
parse(Input, Floors):-
    foldl(parse_line, Input, floors{first:[], second:[], third:[], fourth:[], elevator:_}, Floors).

%% Parses a single line
%% parse_line(+,+,-)
%% parse_line(Line, Acc, Floors).
parse_line(LineStr, Floors0, Floors):-
    split_string(LineStr, ".", "", [H0|_]),
    split_string(H0, ",", "", [H|T]), 
    parse_floor(H, F, Floors0, Floors1),
    foldl(parse_item(F), T, Floors1, Floors).

%% Parses a single item on the line
%% parse_line(+,+,+,-)
%% parse_line(Floor, Item, Acc, Floors).
parse_item(F, H, Floors0, Floors):-
    string(H),
    split_string(H, " ", "", [_, Name, Type]),
    split_string(Name, "-", "", [Name1|_]),
    atom_string(TypeAtm, Type),
    Floors = Floors0.put(F, [(Name1, TypeAtm)|Floors0.F]).

parse_item(F, H, Floors0, Floors):-
    string(H),
    split_string(H, " ", "", [_, _, Name, Type]),
    split_string(Name, "-", "", [Name1|_]),
    atom_string(TypeAtm, Type),
    Floors = Floors0.put(F, [(Name1, TypeAtm)|Floors0.F]).

parse_item(F, H, Floors0, Floors):-
    string(H),
    split_string(H, " ", "", [_, _, _, Name, Type]),
    split_string(Name, "-", "", [Name1|_]),
    atom_string(TypeAtm, Type),
    Floors = Floors0.put(F, [(Name1, TypeAtm)|Floors0.F]).

parse_item(_, [_, "nothing", _], Floors0, Floors0).

parse_item(F, [_, _, Name, Type], Floors0, Floors):-
    \+ Name = "nothing",
    split_string(Name, "-", "", [Name1|_]),
    atom_string(TypeAtm, Type),
    Floors = Floors0.put(F, [(Name1, TypeAtm)|Floors0.F]).

parse_item(F, [_, _, Name, Type, _, _, Name2, Type2], Floors0, Floors):-
    split_string(Name, "-", "", [Name1|_]),
    split_string(Name2, "-", "", [Name22|_]),
    atom_string(TypeAtm, Type),
    atom_string(TypeAtm2, Type2),
    Floors1 = Floors0.put(F, [(Name1, TypeAtm)|Floors0.F]),
    Floors = Floors0.put(F, [(Name22, TypeAtm2)|Floors1.F]).

%% Parses the floor that the line concerns
%% parse_floor(+,-,-,-)
%% parse_line(Input, Floor, Acc, Floors).
parse_floor(H, F, Floors0, Floors):-
    split_string(H, " ", "", [_,Floor,_|R]),
    atom_string(F, Floor),
    parse_item(F, R, Floors0, Floors).

%% Finds all solutions and returns the best one
%% solve_all(+,-).
%% solve_all(Floors, BestSolution).
solve_all(Floors, B):-
    findall(X, solve(Floors, X), _),
    best_sol(B).

%% Solves the puzzle, i.e moves all items to the fourth floor in a safe way
%% solve(+,-).
%% solve(Floors, MinSteps).
solve(Floors, MinSteps):-
    Floors0 = Floors.put(elevator, first),
    take_snapshot(Floors0, Snap),
    solve(1, [Snap], Floors0, MinSteps).

solve(I, SnapShots, Floors, Steps):-
    best_sol(B),
    I < B,
    move(Floors, Floors1), 
    \+ have_seen(SnapShots, Floors1),
    take_snapshot(Floors1, Snap),
    (done(Floors1) ->
     Steps is I,
     (Steps < B ->
      retract(best_sol(_)),
      assertz(best_sol(Steps)));
     (
      I1 is I + 1,
      solve(I1, [Snap|SnapShots], Floors1, Steps)
     )).

%% Checks if the current configuration is done or not
%% done(+).
%% done(Floors).
done(Floors):-
    Floors.first = [],
    Floors.second = [],
    Floors.third = [],
    \+ Floors.fourth = [].

%% Moves an item
%% move(+,-).
%% move(Floors, UpdatedFloors).
move(Floors, Floors1):-    
    move_2(up, Floors, Floors1).

move(Floors, Floors1):-
    \+ move_2(up, Floors, Floors1),
    move_1(up, Floors, Floors1).

move(Floors, Floors1):-
    move_1(down, Floors, Floors1).

move(Floors, Floors1):-
    \+ move_1(down, Floors, Floors1),
    move_2(down, Floors, Floors1).

move(Floors, _):-
    take_snapshot(Floors, Snap),
    snaps(S),
    retractall(snaps(_)),
    assertz(snaps([Snap|S])),
    fail.

%% Moves two items
%% move_2(+,+,-).
%% move_2(Dir, Floors, UpdatedFloors).
move_2(Dir, Floors, Floors1):-
    floor(F),
    Floors.elevator = F,
    member((P1, P1Type), Floors.F),
    member((P2, P2Type), Floors.F),
    \+ (P1 = P2,
        P1Type = P2Type),
    move(Dir, (P1, P1Type), (P2, P2Type), F, Floors, Floors1).

%% Moves one items
%% move_2(+,+,-).
%% move_2(Dir, Floors, UpdatedFloors).
move_1(Dir, Floors, Floors1):-
    floor(F),
    Floors.elevator = F,
    member((P1, P1Type), Floors.F),
    move(Dir, (P1, P1Type), F, Floors, Floors1).

%% Decides if the given floor is the one to move to given the direction
%% move_up_down(+,+,+,+).
%% move_up_down(Dir, CurrentFloor, NextFloor, Floors).
move_up_down(Dir, F, OldF, Floors):-
    num(OldF, N1),
    num(F, N2),
    N3 is N1 + 1,
    N4 is N2 + 1,
    (Dir = up ->
     N2 = N3;
     N1 = N4,
     findall(N, between(1,N1,N), LowerFloors),
     \+ maplist(check_empty(Floors), LowerFloors)
    ).

%% Checks if a given floor number is empty
%% check_empty(+,+).
%% check_empty(FloorNumber, Floors).
check_empty(N, Floors):-
    num(F, N),
    Floors.F = [].

%% Performs a move of two items
%% move(+,+,+,+,+,-).
%% move(Direction, Item1, Item2, OldFloor, OldFloors, UpdatedFloors).
move(Dir, P1, P2, OldF, Floors0, Floors):-
    floor(F),
    move_up_down(Dir, F, OldF, Floors0),
    subtract(Floors0.OldF, [P1, P2], NewOld),
    Floors1 = Floors0.put(OldF, NewOld),
    Floors = Floors1.put(F, [P1, P2|Floors1.F]).put(elevator, F),
    safe(Floors).

%% Performs a move of one item
%% move(+,+,+,+,-).
%% move(Direction, Item1, OldFloor, OldFloors, UpdatedFloors).
move(Dir, P1, OldF, Floors0, Floors):-
    floor(F),
    move_up_down(Dir, F, OldF, Floors0),
    subtract(Floors0.OldF, [P1], NewOld),
    Floors1 = Floors0.put(OldF, NewOld),
    Floors = Floors1.put(F, [P1|Floors1.F]).put(elevator, F),
    safe(Floors).

%% Checks wether the given configuration is safe or not
%% safe(+).
%% safe(Floors).
safe(Floors):-
    forall(floor(F), safe_floor(Floors.F)).

%% Checks wether a given floor is safe
%% safe_floor(+).
%% safe_floor(Floor).
safe_floor(Floor):-
    \+ (
        member((P1, microchip), Floor),
        \+ member((P1, generator), Floor),
        member((P2, generator), Floor),
        \+ P2 = P1
       ).

%% Takes a snapshot of the current configuration
%% take_snapshot(+,-).
%% take_snapshot(Floors, Snapshot).
take_snapshot(Floors, floors{first:First1, second:Second1, third:Third1, fourth:Fourth1}):-
    sort(Floors.first, First1),
    sort(Floors.second, Second1),
    sort(Floors.third, Third1),
    sort(Floors.fourth, Fourth1).

%% Checks if the current configuration is new or old
%% have_seen(+,+).
%% have_seen(SnapShots, Floors).
have_seen(SnapShots, Floors):-
    take_snapshot(Floors, Snap),
    (snaps(S) ->
     (
      append(SnapShots, S, SnapShots2),      
      matching_snapshot(SnapShots2, Snap)
     );
     matching_snapshot(SnapShots, Snap)
    ).

%% Checks wether there exist a matching snapshot to the given configuration
%% matching_snapshot(+,+).
%% matching_snapshot(SnapShots, Floors)
matching_snapshot([H|T], Floors):-
    (
     equal_floor(Floors.first, H.first),
     equal_floor(Floors.second, H.second),
     equal_floor(Floors.third, H.third),
     equal_floor(Floors.fourth, H.fourth)
    );
    matching_snapshot(T, Floors).

%% Checks wethter two floors are "equal"
%% equal_floor(+,+).
%% equal_floor(Floor1, Floor2).
equal_floor(F1, F2):-
    length(F1, L),
    length(F2, L),
    count_pairs(F1, 0, N),
    count_pairs(F2, 0, N).

%% Counts the number of pairs on the floor
%% count_pairs(+,+,-).
%% count_pairs(Floor, Acc, Count).
count_pairs([], Acc, Acc).

count_pairs([(P1,_)|R], Acc, Count):-
    subset([(P1, _)], R),
    Acc1 is Acc + 1,
    subtract(R, [(P1, _)], R1),
    count_pairs(R1, Acc1, Count).

count_pairs([(P1,_)|R], Acc, Count):-
    \+ subset([(P1, _)], R),    
    count_pairs(R, Acc, Count).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print_a(MinSteps):-
    format("The minimum number of steps necessary for part a is ~p ~n", [MinSteps]).

pretty_print_b(MinSteps):-
    format("The minimum number of steps necessary for part b is ~p ~n", [MinSteps]).