%% AdventOfCode day 3 3a.pl
%% swi-prolog
%% compile: ['3a.pl']
%%
%% start.
%% or
%% count_valid_triangles(+,-).
%%
%% count_valid_triangles(InputString, NumberOfValidTriangles).
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>


%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    count_valid_triangles(["  5  10  25"], 0).

%% Solves the puzzle with 3.txt as input string
start:-
    get_input(Input),
    count_valid_triangles(Input, ValidCount),
    pretty_print(ValidCount).

%% Reads inputstring
%% read_input(-).
%% read_input(VariableToStoreReadData).
get_input(Input):-
    open("3.txt", read, Stream),
    read_line_to_codes(Stream,Line1),
    get_input(Stream, Line1, Input).

get_input(Stream, Line1, Input):-
    get_input(Stream, Line1, [], Input).

get_input(_, end_of_file, Input, Input).

get_input(Stream, Line, Acc, Input):-
    is_list(Line),
    append(Acc, [Line], Acc1),
    read_line_to_codes(Stream,Line1),
    get_input(Stream, Line1, Acc1, Input).

%% Counts number of valid triangles in the column
%% count_valid_triangles(+,-).
%% count_valid_triangles(Column, NumberOfValidTriangles).
count_valid_triangles(Input, ValidCount):-
    count_valid_triangles(Input, 0, ValidCount).

count_valid_triangles([], I, I).

count_valid_triangles([H|T], I, R):-
    split_string(H, " ", " ", Triangle),
    valid_triangle(Triangle),
    I1 is I + 1,
    count_valid_triangles(T, I1, R).

count_valid_triangles([H|T], I, R):-
    split_string(H, " ", " ", Triangle),
    \+ valid_triangle(Triangle),
    count_valid_triangles(T, I, R).

%% Checks for a valid triangle
%% valid_triangle(+,+,+).
%% valid_trinagle(A,B,C).
valid_triangle([Astr, Bstr, Cstr]):-
    number_codes(A, Astr),
    number_codes(B, Bstr),
    number_codes(C, Cstr),
    A + B > C,
    A + C > B,
    B + C > A.

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(ValidCount):-
    format("Number of valid triangles are: ~p ~n", [ValidCount]).
