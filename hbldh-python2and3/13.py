#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 13
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

from collections import namedtuple
try:
    from queue import PriorityQueue
except ImportError:
    from Queue import PriorityQueue

with open('input_13.txt', 'r') as f:
    data = int(f.read().strip())

path = namedtuple('path', ['priority', 'x', 'y', 'history'])


def solve(initial_state, magic_number, target_position):
    q = PriorityQueue()
    q.put(initial_state)
    labyrinth = {}
    visited_less_than_50 = set()

    def priority_fcn(s, x, y):
        return -(abs(s.x - x) + abs(s.y - y))

    def is_wall(x, y):
        return bool(sum(map(int, bin(
            x * x + 3 * x + 2 * x * y + y + y * y + magic_number)[2:])) % 2)

    while q.qsize() > 0:
        state = q.get()
        if len(state.history) <= 50:
            visited_less_than_50.add((state.x, state.y))
        if state.x == target_position[0] and state.y == target_position[1]:
            break
        else:
            history = [(state.x, state.y), ] + state.history
            for x, y in zip([-1, 1, 0, 0], [0, 0, -1, 1]):
                new_x, new_y = state.x + x, state.y + y
                # Check if outside labyrinth.
                if new_x < 0 or new_y < 0:
                    continue
                # Check if already visited.
                x_group = labyrinth.setdefault(new_x, {})
                if new_y in x_group:
                    continue
                else:
                    # Check if wall.
                    x_group[new_y] = is_wall(new_x, new_y)
                    if x_group[new_y]:
                        continue
                q.put(path(priority=priority_fcn(state, new_x, new_y),
                           x=new_x, y=new_y, history=history))

    # Print map
    columns = []
    N = max([max(labyrinth[k].keys()) + 1 for k in range(max(labyrinth.keys()) + 1)])
    for k in sorted(labyrinth.keys()):
        columns.append([' ' for x in range(N)])
        for kk, value in sorted(labyrinth[k].items(), key=lambda x: x[0]):
            columns[-1][kk] = '#' if value else '.'
            if (k, kk) in state.history:
                columns[-1][kk] = 'O'
    columns[target_position[0]][target_position[1]] = 'X'

    rows = list(map(list, zip(*columns)))
    print("   {0}".format('0123456789' * (N // 10))[:len(rows[0]) + 3])
    for i, row in enumerate(rows):
        print("{0:02d} {1}".format(i, "".join(row)))

    return state, visited_less_than_50

solution, n_less_than_50 = solve(path(priority=0, x=1, y=1, history=[]), data, (31, 39))
print("[Part 1] Number of steps: {0}".format(len(solution.history)))
print("[Part 2] Distinct locations < 50 steps away: {0}".format(len(list(n_less_than_50))))
