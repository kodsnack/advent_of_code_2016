#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Advent of Code, Day 1
=====================

Author: hbldh <henrik.blidh@nedomkull.com>

"""
from operator import add

data = "R3, L5, R2, L1, L2, R5, L2, R2, L2, L2, L1, R2, L2, " \
       "R4, R4, R1, L2, L3, R3, L1, R2, L2, L4, R4, R5, L3, " \
       "R3, L3, L3, R4, R5, L3, R3, L5, L1, L2, R2, L1, R3, " \
       "R1, L1, R187, L1, R2, R47, L5, L1, L2, R4, R3, L3, " \
       "R3, R4, R1, R3, L1, L4, L1, R2, L1, R4, R5, L1, R77, " \
       "L5, L4, R3, L2, R4, R5, R5, L2, L2, R2, R5, L2, R194, " \
       "R5, L2, R4, L5, L4, L2, R5, L3, L2, L5, R5, R2, L3, R3, " \
       "R1, L4, R2, L1, R5, L1, R5, L1, L1, R3, L1, R5, R2, R5, " \
       "R5, L4, L5, L5, L5, R3, L2, L5, L4, R3, R1, R1, R4, L2, " \
       "L4, R5, R5, R4, L2, L2, R5, R5, L5, L2, R4, R4, L4, R1, " \
       "L3, R1, L1, L1, L1, L4, R5, R4, L4, L4, R5, R3, L2, L2, " \
       "R3, R1, R4, L3, R1, L4, R3, L3, L2, R2, R2, R2, L1, L4, " \
       "R3, R2, R2, L3, R2, L3, L2, R4, L2, R3, L4, R5, R4, R1, " \
       "R5, R3".split(', ')

turn_funcs = {
    'R': lambda d: (d[1], -d[0]),
    'L': lambda d: (-d[1], d[0])
}

def l1_norm(x):
    return sum(map(abs, x))

direction = (0, 1)
position = [0, 0]
positions_visited = {}
has_printed = False

for d in data:
    direction = turn_funcs.get(d[0])(direction)
    for i in range(int(d[1:])):
        position = tuple(map(add, position, direction))
        if position not in positions_visited:
            positions_visited[position] = 1
        elif not has_printed:
            positions_visited[position] += 1
            print("First location visited twice is at "
                  "({1:-3d}, {2:-3d}), {0:-3d} blocks away.".format(
                      l1_norm(position), *position))
            has_printed = True

print("Easter Bunny HQ distance: {0:-3d} blocks.".format(l1_norm(position)))
