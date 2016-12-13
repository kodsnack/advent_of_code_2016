%% AdventOfCode day 4 4b.pl
%% swi-prolog
%% compile: ['4b.pl']
%%
%% start.
%% or
%% real_rooms(+,-).
%%
%% real_rooms(ListOfRooms, sumOfSectorId'sForRealRooms).
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>


%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    string_codes("qzmt-zixmtkozy-ivhz-343[xxxx]", Codes),   
    parse_line(Codes, Cipher, SectorId, _),
    reverse(Cipher, Cipher1),
    decrypt(Cipher1, SectorId, PlainText),
    string_codes(PlainTextStr, PlainText),
    normalize_space(string(PlainText1), PlainTextStr),
    PlainText1 = "very encrypted name".

%% Solves the puzzle with 4.txt as input string
start:-
    get_input(Input),
    find_north_pole(Input, SectorId),
    pretty_print(SectorId).

%% Reads inputstring
%% read_input(-).
%% read_input(VariableToStoreReadData).
get_input(Input):-
    open("4.txt", read, Stream),
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

%% Find the sectorId of the room with the decrypted text "northpole object storage"
%% find_north_pole(+,-).
%% find_north_pole(Rooms, SectorId).
find_north_pole([H|_], SectorId):-
    parse_line(H, Cipher, SectorId, _),
    reverse(Cipher, Cipher1),
    decrypt(Cipher1, SectorId, PlainText),
    string_codes(PlainTextStr, PlainText),
    normalize_space(string(PlainText1), PlainTextStr),
    PlainText1 = "northpole object storage".

find_north_pole([H|T], SecId):-
    parse_line(H, Cipher, SectorId, _),
    reverse(Cipher, Cipher1),
    decrypt(Cipher1, SectorId, PlainText),
    string_codes(PlainTextStr, PlainText),
    normalize_space(string(PlainText1), PlainTextStr),
    PlainText1 \= "northpole object storage",
    find_north_pole(T, SecId).

%% Decrypts a room
%% decrypt(+,+,-).
%% decrypt(Room, SectorId, PlainText).
decrypt([], _, []).

decrypt([32|Xs], SectorId, [32|Ys]):-
    decrypt(Xs, SectorId, Ys).

decrypt([X|Xs],SectorId, [Y|Ys]):-
    X \= 32,
    T is SectorId mod 26,
    X > 122 - T,
    Y is (96 + (T-(122 - X))),
    decrypt(Xs, SectorId, Ys).

decrypt([X|Xs],SectorId, [Y|Ys]):-
    X \= 32,
    T is SectorId mod 26,
    X =< 122 - T,
    Y is X + T,
    decrypt(Xs, SectorId, Ys).

%% parses input line and extracts important pieces
%% parse_line(+,-,-,-).
%% parse_line(Line, Letters, SectorId, CheckSum).
parse_line(Line, Letters, SectorId, CheckSum):-
    get_letters(Line, R0, Letters),
    get_sector_id(R0, R1, SectorId),
    get_checksum(R1, CheckSum).

%% Extracts the checksum
%% get_checksum(+,-).
%% get_checksum(Line, CheckSum).
get_checksum(Line, CheckSum):-
    get_checksum(Line, [], CheckSum).

get_checksum([93|_], CheckSum, CheckSum).

get_checksum([H|T], Acc, CheckSum):-
    H \= 93,
    append(Acc, [H], Acc1),
    get_checksum(T, Acc1, CheckSum).

%% Extracts the SectorId
%% get_sector_id(+,-,-).
%% get_sector_id(Line, RestOfLine, SectorId).
get_sector_id(Line, Rest, SectorId):-
    get_sector_id(Line, Rest, [], SectorId).

get_sector_id([91|T], T, SectorId , Nmr):-
    string_codes(Str, SectorId),
    number_codes(Nmr, Str).

get_sector_id([H|T], Rest, Acc , SectorId):-
    append(Acc, [H], Acc1),
    get_sector_id(T, Rest, Acc1, SectorId).

%% Extracts letters
%% get_letters(+,-,-).
%% get_letters(Line, Rest, Letters).
get_letters(Line, Rest, Letters):-
    get_letters(Line, Rest, [], Letters).

get_letters([H|T], [H|T], Acc, Acc):-
    H > 47,
    H < 58.

get_letters([45|T], Rest, Acc, Letters):-
    get_letters(T, Rest, [32|Acc], Letters).

get_letters([H|T], Rest, Acc, Letters):-
    H > 96,
    get_letters(T, Rest, [H|Acc], Letters).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(SectorId):-
    format("SectorId of the northpole is ~p ~n", [SectorId]).
