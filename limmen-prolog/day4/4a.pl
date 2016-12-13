%% AdventOfCode day 4 4a.pl
%% swi-prolog
%% compile: ['4a.pl']
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
    string_codes("aaaaa-bbb-z-y-x-123[abxyz]", Codes),
    string_codes("a-b-c-d-e-f-g-h-987[abcde]", Codes1),
    string_codes("not-a-real-room-404[oarel]", Codes2),
    string_codes("totally-real-room-200[decoy]", Codes3),
    real_rooms([Codes, Codes1, Codes2, Codes3], 1514).

%% Solves the puzzle with 4.txt as input string
start:-
    get_input(Input),
    real_rooms(Input, Sum),
    pretty_print(Sum).

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

%% Calculates sum of sectorIds for real rooms
%% real_rooms(+,-).
%% real_rooms(ListOfRooms, sumOfSectorId'sForRealRooms).
real_rooms(Input, Sum):-
    real_rooms(Input, 0, Sum).

real_rooms([], Sum, Sum).

real_rooms([H|T], Acc, Sum):-
    real_room(H, SectorId),
    string_codes(Str, H),
    Acc1 is Acc + SectorId,
    real_rooms(T, Acc1, Sum).

%% Calculates the value of the room, 0 if not real, otherwise SectorId
%% real_room(+,-).
%% real_room(Room, Val).
real_room(Codes, 0):-
    parse_line(Codes, IndexedLetters, SectorId, CheckSum),
    \+ valid_checksum(IndexedLetters, CheckSum).

real_room(Codes, Nmr):-
    parse_line(Codes, IndexedLetters, SectorId, CheckSum),
    valid_checksum(IndexedLetters, CheckSum),
    string_codes(Str, SectorId),
    number_codes(Nmr, Str).

%% Checks if a given checksum is consistent with the letters
%% valid_checksum(+,+).
%% valid_checksum(OrderedLetters, CheckSum).
valid_checksum(_, []).

valid_checksum([(H,_)|T], [H|T2]):-
    valid_checksum(T, T2).
    
%% parses input line and extracts important pieces
%% parse_line(+,-,-,-).
%% parse_line(Line, IndexedLetters, SectorId, CheckSum).
parse_line(Line, IndexedLetters, SectorId, CheckSum):-
    get_letters(Line, R0, Letters),
    get_sector_id(R0, R1, SectorId),
    get_checksum(R1, CheckSum),
    index_letters(Letters, IndexedLetters).

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

get_sector_id([91|T], T, SectorId , SectorId). 

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
    get_letters(T, Rest, Acc, Letters).

get_letters([H|T], Rest, Acc, Letters):-
    H > 96,
    get_letters(T, Rest, [H|Acc], Letters).

%% Indexes the letters based on occurences/alphabetic order
%% index_letters(+,-).
%% index_letters(Letters, IndexedLetters).
index_letters(Letters, IndexedLetters):-
    count_letters(Letters, Counted),
    sort(1,@=<, Counted, Counted1),
    sort(2,@>=, Counted1, IndexedLetters).

%% Counts number of occurences for each letter
%% count_letters(+,-).
%% count_letters(Letters, Counted).
count_letters(Letters, Counted):-
    count_letters(Letters, Letters, [], Counted).

count_letters(_, [], Acc, Acc).

count_letters(L, [H|T], Acc, CountedLetters):-
    member((H,_), Acc),
    count_letters(L, T, Acc, CountedLetters).

count_letters(L, [H|T], Acc, CountedLetters):-
\+ member((H,_), Acc),
count_letter(H, L, 0, N),
count_letters(L, T, [(H,N)|Acc], CountedLetters).

%% Counts number of occurences of a single letter
%% count_letter(+,-,-,-)
%% count_letter(Line, LineLeft, Accl N).
count_letter(_, [], N, N).

count_letter(H, [H|T], Acc, N):-
    Acc1 is Acc + 1,
    count_letter(H, T, Acc1, N).

count_letter(X, [H|T], Acc, N):-
    X \= H,
    count_letter(X, T, Acc, N).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Sum):-
    format("Sum of sector ID's for real rooms are: ~p ~n", [Sum]).
