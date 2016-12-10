%% AdventOfCode day 3 3b.pl
%% swi-prolog
%% compile: ['3b.pl']
%%
%% start.
%% or
%% count_valid_triangles(+,-).
%%
%% count_valid_triangles(InputColumn, NumberOfValidTriangles).
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>


%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    create_columns(["  101  301  501", "  102  302  502", "  103  303  503", "  201  401  601", "  202  402  602", "  203   403  603"], First, Second, Third),
    count_valid_triangles(First, I1),
    count_valid_triangles(Second, I2),
    count_valid_triangles(Third, I3),
    ValidCount is I1 + I2 + I3,
    ValidCount is 6.

%% Solves the puzzle with 3.txt as input string
start:-
    get_input(Input),
    !,
    create_columns(Input, First, Second, Third),
    count_valid_triangles(First, I1),
    count_valid_triangles(Second, I2),
    count_valid_triangles(Third, I3),
    ValidCount is I1 + I2 + I3,
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

%% Converts the input which is row-based to column-based
%% create_columns(+,-,-,-).
%% create_columns(InputString, FirstColumn, SecondColumn, ThirdColumn).
create_columns(Input, First, Second, Third):-
    create_columns(Input, [], [], [], First, Second, Third).

create_columns([], First, Second, Third, First, Second, Third).

create_columns([H|T], FirstAcc, SecondAcc, ThirdAcc, First, Second, Third):-
    split_string(H, " ", " ", [Astr,Bstr,Cstr]),
    number_codes(A, Astr),
    number_codes(B, Bstr),
    number_codes(C, Cstr),
    create_columns(T, [A|FirstAcc], [B|SecondAcc], [C|ThirdAcc], First, Second, Third).

%% Counts number of valid triangles in the column
%% count_valid_triangles(+,-).
%% count_valid_triangles(Column, NumberOfValidTriangles).
count_valid_triangles(Input, ValidCount):-
    count_valid_triangles(Input, 0, ValidCount).

count_valid_triangles([], I, I).

count_valid_triangles([_], I, I).

count_valid_triangles([_, _], I, I).

count_valid_triangles([A,B,C|T], I, R):-
    valid_triangle(A,B,C),
    I1 is I + 1,
    count_valid_triangles(T, I1, R).

count_valid_triangles([A,B,C|T], I, R):-
    \+ valid_triangle(A,B,C),
    count_valid_triangles(T, I, R).

%% Checks for a valid triangle
%% valid_triangle(+,+,+).
%% valid_trinagle(A,B,C).
valid_triangle(A, B, C):-
    A + B > C,
    A + C > B,
    B + C > A.

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(ValidCount):-
    format("Number of valid triangles are: ~p ~n", [ValidCount]).
