#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 11
======================

Author: hbldh <henrik.blidh@nedomkull.com>

This is a modified version of original solution,
speeding it up by factor 10.

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re
import time
from itertools import combinations, chain

from heapq import heappop, heappush

with open('input_11.txt', 'r') as f:
    data = f.read().strip()


def hash_state(s):
    return hash(tuple(s[1]))


class Solver(object):

    def __init__(self, data):
        self.all_elements = re.findall('([\w]*) generator', data, re.M)
        self.mapping = {}
        self.mchips = []
        self.gens = []
        self.valid_dict = {}

        # Create bitmask for object.
        for i, element in enumerate(self.all_elements):
            self.mapping["{0} generator".format(element)] = 2 ** (i * 2)
            self.mapping["{0}-compatible microchip".format(element)] = 2 ** ((i * 2) + 1)
            self.gens.append(2 ** (i * 2))
            self.mchips.append(2 ** ((i * 2) + 1))
        self.G = sum(self.gens)
        self.components = tuple(sorted(self.mapping.values()))

        self.initial_setup = [1, 0, 0, 0, 0]
        for i, floor_start in enumerate(data.strip().splitlines()):
            generators = re.findall('([\w]* generator)', floor_start)
            for g in generators:
                self.initial_setup[i + 1] += self.mapping[g]
            microchip = re.findall('(\w*-compatible microchip)', floor_start)
            for m in microchip:
                self.initial_setup[i + 1] += self.mapping[m]

    def isvalid(self, v):
        valid = self.valid_dict.get(v)
        if valid is None:
            valid = True
            for m in self.mchips:
                if v & m:
                    # Chip is present.
                    if v & (m >> 1):
                        # Own generator present. No danger.
                        continue
                    if v & self.G:
                        # Other generators present. Fried chip.
                        valid = False
                        break
            self.valid_dict[v] = valid
        return valid

    def get_possible_moves(self, source_state):
        distance, s = source_state
        current_floor_contents = list(filter(None, [s[s[0]] & c for c in self.components]))
        floors = [s[0] + 1, ] if s[0] == 1 else [s[0] - 1, ] if s[0] == 4 else [s[0] + 1, s[0] - 1]
        for components_to_move in chain(combinations(current_floor_contents, 1),
                                        combinations(current_floor_contents, 2)):
            for new_floor in floors:
                s_move = s[:]
                s_move[0] = new_floor
                c = sum(components_to_move)
                s_move[new_floor] += c
                s_move[s[0]] -= c
                if self.isvalid(s_move[new_floor]) and self.isvalid(s_move[s[0]]):
                    yield [distance + 1, s_move]

    def run(self):
        q = []
        heappush(q, [0, self.initial_setup])
        visited = {}
        completed = sum(self.mapping.values())

        while len(q) > 0:
            state = heappop(q)
            if state[1][-1] == completed and state[1][0] == 4:
                break
            else:
                for changed_state in self.get_possible_moves(state):
                    h = hash_state(changed_state)
                    if h not in visited:
                        heappush(q, changed_state)
                        visited[h] = 1
        return state


t = time.time()
solution_1 = Solver(data).run()
print("[Part 1] Minimum number of steps: {0} (Runtime: {1:.2f} s)".format(solution_1[0], time.time() - t))

t = time.time()
print("N.B. Runtime of part 2 is at least 3 minutes...")
data = data.replace('and a strontium generator.', 'a strontium generator. an elerium generator, an elerium-compatible microchip, a dilithium generator, and a dilithium-compatible microchip.')
solution_2 = Solver(data).run()
print("[Part 2] Minimum number of steps: {0} (Runtime: {1:.2f} s)".format(solution_2[0], time.time() - t))



