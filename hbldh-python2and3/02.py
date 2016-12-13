#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Advent of Code, Day 2
=====================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

with open('input_02.txt', 'r') as f:
    instructions = f.read().strip().splitlines()

def solve_part_1():
    funcs = {
        'U': lambda x: (max(x[0] - 1, 0), x[1]),
        'D': lambda x: (min(x[0] + 1, 2), x[1]),
        'L': lambda x: (x[0], max(x[1] - 1, 0)),
        'R': lambda x: (x[0], min(x[1] + 1, 2)),
    }

    def get_digit(x):
        return [[1, 2, 3], [4, 5, 6], [7, 8, 9]][x[0]][x[1]]

    position = [1, 1]
    digits = []

    for instruction in instructions:
        for move in instruction.strip():
            position = funcs.get(move)(position)
        digits.append(str(get_digit(position)))

    print("[Part 1] Combination: {0}".format("".join(digits)))


def solve_part_2():
    characters = [
        [None, None, 1, None, None],
        [None, 2, 3, 4, None],
        [5, 6, 7, 8, 9],
        [None, 'A', 'B', 'C', None],
        [None, None, 'D', None, None]
    ]

    def get_character(x):
        return characters[x[0]][x[1]]

    def apply_move(p, d):
        funcs = {
            'U': lambda x: (max(x[0] - 1, 0), x[1]),
            'D': lambda x: (min(x[0] + 1, 4), x[1]),
            'L': lambda x: (x[0], max(x[1] - 1, 0)),
            'R': lambda x: (x[0], min(x[1] + 1, 4)),
        }
        new_pos = funcs.get(d)(p)
        if get_character(new_pos):
            return new_pos
        else:
            return p

    position = [2, 0]
    chars = []

    for instruction in instructions:
        for direction in instruction.strip():
            position = apply_move(position, direction)
        chars.append(str(get_character(position)))

    print("[Part 2] Combination: {0}".format("".join(chars)))

solve_part_1()
solve_part_2()
