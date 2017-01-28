%% AdventOfCode day 24 24ab.pl
%% swi-prolog
%% compile: ['24ab.pl']
%%
%% start.
%%
%% solves both problem a and b.
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(pio)).
:- use_module(library(dcg/basics)).
:- use_module(library(lists)).
:- set_prolog_flag(double_quotes, codes).
:- dynamic(wall/2).
:- dynamic(point/3).
:- dynamic(best_sol/1).


%%%===================================================================
%%% Definite Clause Grammars for parsing input file
%%%===================================================================

map(_,_) --> eos, !.
map(_,_) --> "\n\n", !.
map(X,Y) --> row(X,Y), {Y1 is Y + 1}, map(0,Y1).

row(X,Y) --> pos(X,Y), {X1 is X + 1}, row(X1, Y).
row(_,_) --> "\n".

pos(X,Y) --> "#", {assertz(wall(X,Y))}.
pos(_,_) --> ".".
pos(X,Y) --> integer(Z), {assertz(point(X,Y,Z))}.

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    phrase(map(0,0), "###########\n#0.1.....2#\n#.#######.#\n#4.......3#\n###########\n\n\n"),
    reduce_to_TSP(TSP),
    !,
    solve_TSP(TSP, 14),
    end.

%% Solves the puzzle with 24.txt as input
start:-
    phrase_from_file(map(0,0), "24.txt"),
    reduce_to_TSP(TSP),
    !,
    solve_TSP(TSP, Min, a),
    format("Part a: ~n"),
    pretty_print(Min),
    solve_TSP(TSP, Min2, b),
    format("Part b: ~n"),
    pretty_print(Min2),
    end.

%% Cleanup the database
end:-
    retractall(wall(_,_)),
    retractall(point(_,_,_)),
    retractall(best_sol(_)).

%% Reduce the problem to the Travelling Salesman Problem between the points
%% reduce_to_TSP(-).
%% reduce_to_TSP(TSP).
reduce_to_TSP(TSP):-
    all_points(Points),
    foldl(tsp_reducer, Points, [], TSP).

%% Solve the Travelling Salesman Problem through brute force
%% solve_TSP(+,-,+).
%% solve_TSP(TSP, Min, Part).
solve_TSP(TSP, Min, Part):-
    retractall(best_sol(_)),
    assertz(best_sol(inf)),
    !,
    findall(L, traverse(TSP, L, Part), _),
    best_sol(Min).

%% Traverses the TSP Graph and returns the length
%% traverse(+,-,+).
%% traverse(TSP, Min, Part).
traverse(TSP, Min, Part):-
    member((0, Paths), TSP),
    traverse((0, Paths), TSP, [0], 0, Min, Part).

%% Traverses the TSP graph and returns the length
%% traverse(+,+,+,+,-,+).
%% traverse(CurrentPos, TSP, Visited, Acc, Length, Part).
traverse(_, _, Visited, Length, Length, a):-
    done(Visited),
    best_sol(Best),
    Length < Best,
    retractall(best_sol(_)),
    assertz(best_sol(Length)).

traverse((_, Paths), _, Visited, Length, Length1, b):-
    done(Visited),
    member((0, Len), Paths),
    Length1 is Length + Len,
    best_sol(Best),
    Length1 < Best,
    retractall(best_sol(_)),
    assertz(best_sol(Length1)).

traverse((_, Paths), TSP, Visited, Acc, Length, Part):-
    best_sol(Best),
    Acc < Best,
    \+ done(Visited),
    member((Next, Len), Paths),
    \+ member(Next, Visited),
    Acc1 is Acc + Len,
    member((Next, Paths1), TSP),
    traverse((Next, Paths1), TSP, [Next|Visited], Acc1, Length, Part).

%% Checks if all points have been visited
%% done(+).
%% done(Visited).
done(Visited):-
    all_points(Points),
    forall(member(X, Points), member(X, Visited)).

%% Reduces the problem to the TSP problem by calculating pairwise shortest paths
%% tsp_reducer(+,+,-).
%% tsp_reducer(Point, Acc, PairWiseShortestPairs).
tsp_reducer(Point, Acc, [(Point, ShortestPaths)|Acc]):-
    all_points(Points),
    delete(Points, Point, Points1),
    get_dist(Point, Points1, ShortestPaths).

%% Gets the distance from a point to other points
%% get_dist(+,+,-).
%% get_dist(Point, Acc, Paths).
get_dist(Point, [X|Xs], [(X, PathLen)|R]):-
    shortest_path(Point, X, PathLen),
    get_dist(Point, Xs, R).

get_dist(_, [], []).

%% Gets the shortest path through BFS
%% shortest_path(+,+,-).
%% shortest_path(Source, Goal, Length).
shortest_path(Source, Goal, PathLen):-
    point(X,Y, Source),
    point(X1,Y1, Goal),
    agenda_search([(0, (X,Y))], (X1,Y1), [], PathLen).

%% Gets all points and their coordinates
%% all_points(-).
%% all_points(Points).
all_points(Points):-
    findall(Z, point(_,_,Z), Points).

%% BFS through the map
%% agenda_search(+,+,+,-).
%% agenda_search(Queue, Goal, Visited, ShortestPathLen).
agenda_search([(Steps, Goal)|_],Goal, _, Steps).

agenda_search([(Steps, Pos)|T], Goal, Visited, Res):-
    Steps1 is Steps + 1,
    \+ Pos = Goal,
    node_neighbours((Steps1, Pos), Visited, Neighbours),
    append(T, Neighbours, Queue),
    list_to_set(Queue, Queue1),
    agenda_search(Queue1, Goal, [Pos|Visited], Res).

%% Gets the neighbours of a node
%% node_neighbours(+,+,-).
%% node_neighbours(Node, Visited, NeighBours).
node_neighbours(Node, Visited, Neighbours):-
    findall((A,B), node_neighbour(Node, (A,B), Visited), Neighbours).

%% Gets a single neighbour of a node
%% node_neigbour(+,-,+).
%% node_neighbour(Node, Neighbour, Visited).
node_neighbour((Steps, (X,Y)), (Steps, (X1, Y)), Visited):-
    X1 is X + 1,
    \+ wall(X1,Y),
    \+ member((X1,Y), Visited).

node_neighbour((Steps, (X,Y)), (Steps, (X1, Y)), Visited):-
    X1 is X - 1,
    \+ wall(X1,Y),
    \+ member((X1,Y), Visited).

node_neighbour((Steps, (X,Y)), (Steps, (X, Y1)), Visited):-
    Y1 is Y + 1,
    \+ wall(X,Y1),
    \+ member((X,Y1), Visited).

node_neighbour((Steps, (X,Y)), (Steps, (X, Y1)), Visited):-
    Y1 is Y - 1,
    \+ wall(X,Y1),
    \+ member((X,Y1), Visited).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Steps):-
    format("Shortest path has ~p steps ~n", [Steps]).