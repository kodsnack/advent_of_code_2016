#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 22
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re

with open('input_22.txt', 'r') as f:
    data = f.read().strip()

row_regex = re.compile("/dev/grid/node-x([\d]+)-y([\d]+)\s*([\d]+)T\s*([\d]+)T\s*([\d]+)T\s*([\d]+)%", re.M)
nodes = [list(map(int, node)) for node in row_regex.findall(data)]

n_viable = 0
viable_indices = []
minimal_used = min(x[3] for x in nodes if x[3] > 0)
for i, node in enumerate(nodes):
    if node[4] >= minimal_used:
        n_viable += sum([x[3] <= node[4] for x in nodes[:i] + nodes[i+1:]])
        viable_indices += [(x[1], x[0]) for x in nodes[:i] + nodes[i+1:] if x[3] <= node[4]]

print("[Part 1] Number of viable nodes: {0}".format(n_viable))

X, Y = max([n[0] for n in nodes]), max([n[1] for n in nodes])
grid = [[None, ] * (X + 1) for i in range(Y + 1)]
for node in nodes:
    grid[node[1]][node[0]] = node[2:5]


def print_grid(grid):
    print('X' + "".join(['.' if (e[0] < 200 and e[1] > 0) else '#' if e[0] > 200 else '_' for e in grid[0]])[1:-1] + 'G')
    for row in grid:
        print("".join(['.' if (e[0] < 200 and e[1] > 0) else '#' if e[0] > 200 else '_' for e in row]))

# print_grid(grid)
# All nodes except the large ones and the empy one are viable nodes.
# Thus, all moves except these are available.
# Find distance from empty node to one step in front of goal data.
# Add 5 (moves required to move G one step) times (X - 1)
# Add one for final step.

moves = 0
min_large_node = min(x[0] for x in nodes if x[2] > 200)
empty_node = [node for node in nodes if node[3] == 0][0]

moves += (empty_node[0] - (min_large_node - 1)) + empty_node[1] + (X - min_large_node)
moves += (X - 1) * 5
moves += 1

print("[Part 2] Minimal number of steps: {0}".format(moves))
