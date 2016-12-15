%% AdventOfCode day 8 a&b 8ab.pl
%% swi-prolog
%% compile: ['8ab.pl']
%%
%% start.
%% or
%% manipulate_matrix(+,+,-).
%% manipulate_matrix(Matrix, Input, NewMatrix).
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Libs
:- use_module(library(lists)).
:- use_module(library(apply)).

%% Test cases
test:-
    string_codes("rect 3x2", C0),
    string_codes("rotate column x=1 by 1", C1),
    string_codes("rotate row y=0 by 4", C2),
    initial_matrix(Matrix),
    manipulate_matrix(Matrix, [C0,C1,C2], NewMatrix),
    count_lit_matrix(NewMatrix, 6).


%% Solves the puzzle with 8.txt as input string
start:-
    get_input(Input),
    initial_matrix(Matrix),
    manipulate_matrix(Matrix, Input, NewMatrix),
    count_lit_matrix(NewMatrix, LitPixels),
    pretty_print(LitPixels),
    print_screen(NewMatrix).

%% manipulates the matrix according to the instructions
%% manipulate_matrix(+,+,-)
%% manipulate_matrix(InitialMatrix, Instructions, NewMatrix).
manipulate_matrix(NewMatrix, [], NewMatrix).

manipulate_matrix(Matrix, [H|T], NewMatrix):-
    parse_line(Matrix, H, Matrix1),
    manipulate_matrix(Matrix1, T, NewMatrix).

%% parse line and apply instruction
%% parse_line(+,+,-)
%% parse_line(Matrix, Line, NewMatrix).
parse_line(Matrix, [114, 101, 99, 116, 32, Width, 120, Height], NewMatrix):-
    number_codes(WidthInt, [Width]),
    number_codes(HeightInt, [Height]),
    create_rect(Matrix, WidthInt, HeightInt, NewMatrix).

parse_line(Matrix, [114, 101, 99, 116, 32, Width1, Width2, 120, Height], NewMatrix):-
    number_codes(WidthInt, [Width1, Width2]),
    number_codes(HeightInt, [Height]),
    create_rect(Matrix, WidthInt, HeightInt, NewMatrix).

parse_line(Matrix, [114,111,116,97,116,101,32,99,111,108,117,109,110,32,120,61,Col,32,98,121,32|Pixels], NewMatrix):-
    number_codes(ColInt, [Col]),
    number_codes(PixelsInt, Pixels),
    rotate_down(Matrix, ColInt, PixelsInt, NewMatrix).

parse_line(Matrix, [114,111,116,97,116,101,32,99,111,108,117,109,110,32,120,61,Col1,Col2,32,98,121,32|Pixels], NewMatrix):-
    number_codes(ColInt, [Col1,Col2]),
    number_codes(PixelsInt, Pixels),
    rotate_down(Matrix, ColInt, PixelsInt, NewMatrix).

parse_line(Matrix, [114,111,116,97,116,101,32,114,111,119,32,121,61,Row,32,98,121,32|Pixels], NewMatrix):-
    number_codes(RowInt, [Row]),
    number_codes(PixelsInt, Pixels),
    rotate_right(Matrix, RowInt, PixelsInt, NewMatrix).

%% counts number of lit pixels in matrix
%% count_lit_matrix(+,-).
%% count_lit_matrix(Matrix, NumberOfLitPixels)
count_lit_matrix(Matrix, LitPixels):-
    count_lit_matrix(Matrix, 0, LitPixels).

count_lit_matrix([], LitPixels, LitPixels).

count_lit_matrix([H|T], Count, LitPixels):-
    count_lit_row(H, 0, Count1),
    Count2 is Count + Count1,
    count_lit_matrix(T, Count2, LitPixels).

%% counts number of lit pixels in a row
%% count_lit_row(+,+,-)
%% count_lit_row(Row, InitCount, Count).
count_lit_row([], Lit, Lit).

count_lit_row([1|T], Count, Lit):-
    Count1 is Count + 1,
    count_lit_row(T, Count1, Lit).

count_lit_row([0|T], Count, Lit):-
    count_lit_row(T, Count, Lit).

%% Creates a rectangle on the matrix
%% create_rect(+,+,+,-)
%% create_rect(Matrix, Width, Height, NewMatrix).
create_rect(Rest, _, 0, Rest).

create_rect([H|T], Width, Height, [NewRow|X]):-
    Height > 0,
    rect_row(H, Width, NewRow),
    Height1 is Height - 1,
    create_rect(T, Width, Height1, X).

%% Creates a row of a rectangle on matrix
%% create_rect(+,+,-)
%% create_rect(Matrix, Width, NewMatrix).
rect_row(Rest, 0, Rest).

rect_row([_|T], Width, [1|X]):-
    Width > 0,
    Width1 is Width - 1,
    rect_row(T, Width1, X).

%% Rotates column down
%% create_rect(+,+,+,-)
%% create_rect(Matrix, ColumnIndex, Pixels, NewMatrix).
rotate_down(Matrix, ColumnIndex, Pixels, NewMatrix):-
    get_col(Matrix, ColumnIndex, Col),
    rotate_row(Col, Pixels, NewCol),
    set_col(Matrix, ColumnIndex, NewCol, NewMatrix).

%% Auxillary function to build up the column
%% add_elem(+,+,-).
%% add_elemt(Row, (Accumulator, ColumnIndex), NewColumn).
add_elem(X, (L, I), ([Val|L], I)):-
    nth0(I, X, Val).

%% Retrieves a column at the given index of the matrix
%% get-col(+,+,-).
%% get_col(Matrix, ColumnIndex, Column).
get_col(Xs,ColIndex, Column1):-
    foldl(add_elem,Xs,([], ColIndex),(Column, _)),
    reverse(Column, Column1).

%% Updates the column with new values
%% set_elem(+,+,-).
%% set_elem(Matrix (Acc, ColIndex, RowIndex, NewColumn), NewMatrix)
set_elem(X, (L, I, J, Col), Xs):-
    set_elem(X, (L, I, J, 0, Col), [], Xs).

set_elem([_|Rest], (L, I, J, I, Col), Acc,  ([Acc2|L], I, J1, Col)):-
    nth0(J, Col, Y),
    reverse([Y|Acc], Acc1),
    append(Acc1, Rest, Acc2),
    J1 is J + 1.

set_elem([H|T], (L, I, J, K, Col), Acc, Res):-
    K < I,
    K1 is K + 1,
    set_elem(T, (L, I, J, K1, Col), [H|Acc], Res).

%% Updates the a column in the matrix
%% set_col(+,+,+,-).
%% set_col(Matrix, ColumnIndex, NewColumn, NewMatrix).
set_col(X, ColIndex, Col, Matrix1):-
    foldl(set_elem, X, ([], ColIndex, 0, Col), (Matrix, _, _, _)),
    reverse(Matrix, Matrix1).

%% Rotates all rows in the matrix to the right
%% rotate_right(+,+,+,-).
%% rotate_right(Matrix, RowIndex, PixelsToRotate, NewMatrix)
rotate_right([H|T], 0, Pixels, [NewRow|T]):-
    rotate_row(H, Pixels, NewRow).

rotate_right([H|T], RowIndex, Pixels, [H|NewMatrix]):-
    RowIndex > 0,
    RowIndex1 is RowIndex - 1,
    rotate_right(T, RowIndex1, Pixels, NewMatrix).

%% Rotates a row in the matrix
%% rotate_row(+,+,-)
%% rotate_row(OldRow, PixelsToRotate, NewRow)
rotate_row(Row, Pixels, NewRow):-
    reverse(Row, Row1),
    rotate_row(Row1, [], Pixels, NewRow).

rotate_row([], Acc, Pixels, NewRow):-
    rotate_row(Acc, [], Pixels, NewRow).

rotate_row(Rest, Acc, 0, NewRow):-
    reverse(Rest, Rest1),
    append(Acc, Rest1, NewRow).

rotate_row([H|T], Acc, Pixels, NewRow):-
    Pixels > 0,
    Pixels1 is Pixels -1,
    rotate_row(T, [H|Acc], Pixels1, NewRow).

%% Creates an initial matrix with all lits off
%% initial_matrix(-)
%% initial_matrix(Matrix).
initial_matrix(Matrix):-
    initial_matrix(Matrix, 50, 6).

initial_matrix([],_,0).

initial_matrix([Row|X], Width, Height):-
    Height > 0,
    Height1 is Height - 1,
    initial_row(Row, Width),
    initial_matrix(X, Width, Height1).

%% Creats a row of lights that are off
%% initial_row(-,+).
%% initial_row(Row, Width).
initial_row([],0).

initial_row([0|X], Width):-
    Width > 0,
    Width1 is Width - 1,
    initial_row(X, Width1).

%% Reads inputstring
%% read_input(-).
%% read_input(VariableToStoreReadData).
get_input(Input):-
    open("8.txt", read, Stream),
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

%% Prints the matrix on the screen in such a way that you can read it
%% print_screen(+).
%% print_screen(Matrix).
print_screen([]).

print_screen([H|T]):-
    print_row(H),
    format("~n"),
    print_screen(T).

%% Pretty prints a row in the matrix
%% print_row(+).
%% print_row(Row).

print_row([]).

print_row([1|T]):-
    format("1"),
    print_row(T).

print_row([0|T]):-
    format(" "),
    print_row(T).

%EFEYKFRFIJ

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Count):-
    format("~p Pixels should be lit ~n", [Count]).

