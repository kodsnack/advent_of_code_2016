# Advent of Code 2016

Solutions for [Advent of Code 2016](https://adventofcode.com/2016), written
in Python, compliant with both version 2.7 and 3.5.

To run problem solvers, run the `__init__.py` script in the Python iterpreter:

```sh
$ python __init__.py --help
usage: Advent of Code 2016 - hbldh [-h] [--token TOKEN] [day [day ...]]

positional arguments:
  day            Run only specific day's problem

optional arguments:
  -h, --help     show this help message and exit
  --token TOKEN  AoC session token. Needed to download data automatically.
```

Execute all days by omitting any number arguments 
(*Note that Day 11 solution takes about 20 minutes!*), or specify a subset of
days by integer values as input. Add the `--token` argument if you want the
solution runner to download input data from the website as well:

```sh
$ python __init__py --token 53616c[...]
```

The token can be found as a cookie pertaining to the Advent of Code website 
in your webbrowser. 

