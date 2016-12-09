-module(day6).

-compile([export_all]).

solve_part1() ->
    {ok, Input} = file:read_file("input/day6"),
    solve(split_lines(Input), fun pick_most_frequent/1).

solve_part2() ->
    {ok, Input} = file:read_file("input/day6"),
    solve(split_lines(Input), fun pick_least_frequent/1).

split_lines(Bin) ->
    [Line || Line <- string:tokens(binary_to_list(Bin), "\n"), Line =/= []].

solve(Lines, PickFun) ->
    Len = length(hd(Lines)),
    lists:map(fun(I) ->
                      Cs = lists:map(fun(Line) ->
                                             lists:nth(I, Line)
                                     end, Lines),
                      PickFun(Cs)
              end, lists:seq(1, Len)).

pick_most_frequent(Cs) ->
    {C, _N} = hd(lists:reverse(count_chars(Cs))),
    C.

pick_least_frequent(Cs) ->
    {C, _N} = hd(count_chars(Cs)),
    C.

count_chars(Cs) ->
    Counters = lists:foldl(fun(C, Map) ->
                                   N = maps:get(C, Map, 0),
                                   maps:put(C, N+1, Map)
                           end, #{}, Cs),
    lists:keysort(2, maps:to_list(Counters)).

%%%_* Tests ============================================================
-include_lib("eunit/include/eunit.hrl").

day5_test_() ->
    Example = [ "eedadn"
              , "drvtee"
              , "eandsr"
              , "raavrd"
              , "atevrs"
              , "tsrnev"
              , "sdttsa"
              , "rasrtv"
              , "nssdts"
              , "ntnada"
              , "svetve"
              , "tesnvt"
              , "vntsnd"
              , "vrdear"
              , "dvrsen"
              , "enarar"
              ],
    [ ?_assertEqual("easter", solve(Example, fun pick_most_frequent/1))
    , ?_assertEqual("advent", solve(Example, fun pick_least_frequent/1))
    , ?_assertEqual("zcreqgiv", solve_part1())
    , ?_assertEqual("pljvorrk", solve_part2())
    ].
