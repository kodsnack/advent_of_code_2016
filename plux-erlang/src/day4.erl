-module(day4).

-compile([export_all]).

solve_part1() ->
    {ok, Input} = file:read_file("input/day4"),
    solve(parse(Input)).

solve_part2() ->
    {ok, Input} = file:read_file("input/day4"),
    solve2(parse(Input)).

parse(Bin) ->
    lists:map(fun parse_line/1, split_lines(Bin)).

parse_line(Line) ->
    {match, [Line, Name, Id, Checksum]} =
        re:run(Line, "^(.*)-(\\d+)\\[([a-z]+)\\]$", [{capture, all, list}]),
    {Name, list_to_integer(Id), Checksum}.

split_lines(Bin) ->
    string:tokens(binary_to_list(Bin), "\n").

solve(Rooms) ->
    ValidIds = [Id || {Name, Id, Checksum} <- Rooms, is_room(Name, Checksum)],
    lists:sum(ValidIds).

solve2(Rooms) ->
    [Id || {Name, Id, Checksum} <- Rooms,
           is_room(Name, Checksum),
           decrypt(Name, Id) =:= "northpole object storage"].

is_room(Name, Checksum) ->
    Checksum =:= calc_checksum(Name).

calc_checksum(Name) ->
    Counters = lists:foldl(fun(C, Map) when C =:= $- ->
                                   Map;
                              (C, Map) ->
                                   N = maps:get(C, Map, 1),
                                   maps:put(C, N+1, Map)
                           end, #{}, Name),
    {Chars, _} = lists:unzip(lists:sort(fun({_, V1}, {_, V2}) ->
                                                V1 >= V2
                                        end, maps:to_list(Counters))),
    lists:sublist(Chars, 5).

decrypt(Name, 0) -> Name;
decrypt(Name, N) -> decrypt(lists:map(fun rot/1, Name), N-1).

rot($z) -> $a;
rot($-) -> $ ;
rot($ ) -> $ ;
rot(C)  -> C+1.

%%%_* Tests ============================================================
-include_lib("eunit/include/eunit.hrl").

day4_test_() ->
    Example  = <<"aaaaa-bbb-z-y-x-123[abxyz]\n",
                 "a-b-c-d-e-f-g-h-987[abcde]\n",
                 "not-a-real-room-404[oarel]\n",
                 "totally-real-room-200[decoy]\n">>,
    [ ?_assertEqual({"aczupnetwp-mfyyj-opalcexpye", 977, "peyac"},
                    parse_line("aczupnetwp-mfyyj-opalcexpye-977[peyac]"))
    , ?_assert(is_room("aczupnetwp-mfyyj-opalcexpye", "peyac"))
    , ?_assertEqual(1514, solve(parse(Example)))
    , ?_assertEqual("abcde", calc_checksum("a-b-c-d-e-f-g-h"))
    , ?_assertEqual("abxyz", calc_checksum("aaaaa-bbb-z-y-x"))
    , ?_assertEqual("oarel", calc_checksum("not-a-real-room"))
    , ?_assertEqual("very encrypted name", decrypt("qzmt-zixmtkozy-ivhz", 343))
    , ?_assertEqual(361724, solve_part1())
    , ?_assertEqual([482], solve_part2())
    ].
