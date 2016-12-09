-module(day3).

-compile([export_all]).

solve_part1() ->
    {ok, Input} = file:read_file("input/day3"),
    solve(parse(Input)).

solve_part2() ->
    {ok, Input} = file:read_file("input/day3"),
    solve(parse2(Input)).

parse2(Bin) ->
    parse_by_column(split_lines(Bin)).

parse_by_column([]) ->
    [];
parse_by_column([L1,L2,L3|T]) ->
    [A1,B1,C1] = parse_line(L1),
    [A2,B2,C2] = parse_line(L2),
    [A3,B3,C3] = parse_line(L3),
    [[A1,A2,A3], [B1,B2,B3], [C1,C2,C3] | parse_by_column(T)].

parse(Bin) ->
    lists:map(fun parse_line/1, split_lines(Bin)).

split_lines(Bin) ->
    string:tokens(binary_to_list(Bin), "\n").

parse_line(Line) ->
    [list_to_integer(T) || T <- string:tokens(Line, " ")].

solve(Triangles) ->
    length(lists:filter(fun is_triangle/1, Triangles)).

is_triangle([A, B, C]) ->
    A + B > C andalso A + C > B andalso B + C > A.

%%%_* Tests ============================================================
-include_lib("eunit/include/eunit.hrl").

day3_test_() ->
    [ ?_assertEqual(false, is_triangle([5,10,25]))
    , ?_assertEqual(true, is_triangle([3,4,5]))
    , ?_assertEqual(993, solve_part1())
    , ?_assertEqual(1849, solve_part2())
    ].
