import sys
from collections import namedtuple
from math_util import *


Disc = namedtuple('Disc', 'nr num_positions start')


def step1(discs):
    return solve(discs)


def step2(discs):
    return solve(discs + [Disc(len(discs) + 1, 11, 0)])


def solve(discs):
    # Solve the following system:
    # x == -start_1 - 1 % num_positions_1
    # x == -start_2 - 2 % num_positions_2
    # ...
    # x == -start_m - m % num_positions_m
    d1 = discs[0]
    r = ((-d1.start - d1.nr) % d1.num_positions, d1.num_positions)
    for d in discs[1:]:
        r = chinese_remainder_theorem(r[0], r[1], (-d.start - d.nr) % d.num_positions, d.num_positions)
    return r[0]
        
        
def parse_discs(inp):
    res = []
    for i in range(1, len(inp) + 1):
        [_, _, _, num_positions, _, _, _, _, _, _, _, start] = inp[i - 1].split()
        res += [Disc(i, int(num_positions), int(start[:-1]))]
    return res


inp = sys.stdin.readlines()
discs = parse_discs(inp)
print(step1(discs))
print(step2(discs))
