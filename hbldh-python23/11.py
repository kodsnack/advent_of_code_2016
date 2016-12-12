#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
11.py
-----------

:copyright: 2016-12-11 by hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re
from copy import copy
from collections import namedtuple
from itertools import chain, combinations
try:
    from queue import PriorityQueue
except ImportError:
    from Queue import PriorityQueue


state_tuple = namedtuple('state', ['d', 'e', 'F1', 'F2', 'F3', 'F4'])


data_1 = """
The first floor contains a thulium generator, a thulium-compatible microchip, a plutonium generator, and a strontium generator.
The second floor contains a plutonium-compatible microchip and a strontium-compatible microchip.
The third floor contains a promethium generator, a promethium-compatible microchip, a ruthenium generator, and a ruthenium-compatible microchip.
The fourth floor contains nothing relevant.
"""
initial_state_1 = state_tuple(d=0, e='F1', F1=['thG', 'thM', 'plG', 'stG'], F2=['plM', 'stM'], F3=['prG', 'prM', 'ruG', 'ruM'], F4=[])

data_2 = """
The first floor contains a thulium generator, a thulium-compatible microchip, a plutonium generator, a strontium generator, an elerium generator, an elerium-compatible microchip, a dilithium generator, and a dilithium-compatible microchip.
The second floor contains a plutonium-compatible microchip and a strontium-compatible microchip.
The third floor contains a promethium generator, a promethium-compatible microchip, a ruthenium generator, and a ruthenium-compatible microchip.
The fourth floor contains nothing relevant.
"""
initial_state_2 = state_tuple(d=0, e='F1', F1=['thG', 'thM', 'plG', 'stG', 'elG', 'elM', 'diG', 'diM'], F2=['plM', 'stM'], F3=['prG', 'prM', 'ruG', 'ruM'], F4=[])


def is_valid(s):
    for floor in ['F1', 'F2', 'F3', 'F4']:
        microchips = [x for x in getattr(s, floor) if x.endswith('M')]
        generators = [x for x in getattr(s, floor) if x.endswith('G')]
        if len(generators) > 0:
            for m in microchips:
                if m[:2] + 'G' not in generators:
                    return False
    return True


def hash_state(s):
    return hash((s.e, tuple(sorted(s.F1)), tuple(sorted(s.F2)),
                tuple(sorted(s.F3)), tuple(sorted(s.F4))))


def get_possible_moves(s):
    possible_moves = []
    current_floor_contents = getattr(s, s.e)
    for components_to_move in list(combinations(current_floor_contents, 1)) + list(combinations(current_floor_contents, 2)):
        # Move components down one level
        if int(s.e[1]) - 1 > 0:
            s_move = state_tuple(**{
                'd': s.d + 1,
                'e': "F{0}".format(int(s.e[1]) - 1),
                'F1': copy(s.F1),
                'F2': copy(s.F2),
                'F3': copy(s.F3),
                'F4': copy(s.F4)
            })
            for c in components_to_move:
                getattr(s_move, s.e).remove(c)
                getattr(s_move, s_move.e).append(c)
            if is_valid(s_move):
                possible_moves.append(s_move)

        # Move components up one level
        if int(s.e[1]) + 1 < 5:
            s_move = state_tuple(**{
                'd': s.d + 1,
                'e': "F{0}".format(int(s.e[1]) + 1),
                'F1': copy(s.F1),
                'F2': copy(s.F2),
                'F3': copy(s.F3),
                'F4': copy(s.F4)
            })
            for c in components_to_move:
                getattr(s_move, s.e).remove(c)
                getattr(s_move, s_move.e).append(c)
            if is_valid(s_move):
                possible_moves.append(s_move)
    return possible_moves


def solve(data, initial_state):

    q = PriorityQueue()
    q.put(initial_state)
    elements = re.findall('(\w*) generator', data, re.M)
    visited = {}

    while q.qsize() > 0:
        state = q.get()
        if len(state.F4) == len(elements) * 2 and state.e == 'F4':
            break
        else:
            for changed_state in get_possible_moves(state):
                h = hash_state(changed_state)
                if h not in visited:
                    q.put(changed_state)
                    visited[h] = 1
    print(state)

solve(data_1, initial_state_1)
solve(data_2, initial_state_2)

