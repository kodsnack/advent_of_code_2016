#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 17
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import heapq
from hashlib import md5

with open('input_17.txt', 'r') as f:
    data = f.read().strip()

directions = ('U', 'D', 'L', 'R')
movement_functions = {
    'U': lambda x: [x[0], x[1] - 1] if x[1] > 0 else None,
    'D': lambda x: [x[0], x[1] + 1] if x[1] < 3 else None,
    'L': lambda x: [x[0] - 1, x[1]] if x[0] > 0 else None,
    'R': lambda x: [x[0] + 1, x[1]] if x[0] < 3 else None
}


def get_possible_movements(key, position):
    open_doors = [directions[i] for i, c in
                  enumerate(md5(key.encode('utf-8')).hexdigest()[:4]) if int(c, 16) > 10]
    return [(d, movement_functions[d](position)) for d in open_doors]


def path_generator(passcode):
    position = [0, 0]
    heap = [(0, passcode, position), ]
    while heap:
        state = heapq.heappop(heap)
        for new_state in get_possible_movements(state[1], state[2]):
            if new_state[1]:
                if new_state[1] == [3, 3]:
                    yield state[0] + 1, (state[1] + new_state[0]).replace(passcode, ''), new_state[1]
                else:
                    heapq.heappush(heap, (state[0] + 1,
                                          state[1] + new_state[0],
                                          new_state[1]))

for solution in path_generator(data):
    print("[Part 1] Shortest path: {0}".format(solution[1]))
    break

for solution in path_generator(data):
    pass
print("[Part 2] Longest path: {0}.".format(solution[0]))
