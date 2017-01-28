# Advent of Code (AoC) 2016 Solutions in Prolog

## Problems

[AdventOfCode](http://adventofcode.com/ "AdventOfCode")

## Usage

Locate yourself in the right directory, e.g `./dayX` and run:


    $ swipl

    ?- ['dayX.pl'].

    ?- start.

Or direct from commandline:

`$ swipl -s dayX.pl -g start`


## Dependencies

SWI-Prolog, I used *SWI-Prolog version 7.3.32 for x86_64-linux* for development but other versions should work as well.

Solutions to some days uses SWI-Prolog maps, so that might require a quite recent version.

## Why Prolog

Some problems in AoC16 are really perfect prolog problems, for other problems it is the complete opposite and is quite painful to solve in prolog.

I used it mainly to learn more about the language.

## Caveats

- This was written by a prolog beginner so expect beginner solutions. However I like to believe that my solutions progressed in quality! For instance I learned how to parse with DCG after day 11 :) 

- Some solutions are sloow and 1 or 2 solutions are optimized for my input and probably is not general enough to solve every input.

## Author

Kim Hammar

<kimham@kth.se>

