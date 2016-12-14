#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Advent of Code, Day 1
=====================

Author: hbldh <henrik.blidh@nedomkull.com>

"""
from operator import add

with open('input_01.txt', 'r') as f:
    data = f.read().strip().split(', ')

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
            print("[Part 2] First location visited twice is at "
                  "({1:-3d}, {2:-3d}), {0:-3d} blocks away.".format(
                      l1_norm(position), *position))
            has_printed = True

print("[Part 1] Easter Bunny HQ distance: {0:-3d} blocks.".format(l1_norm(position)))
