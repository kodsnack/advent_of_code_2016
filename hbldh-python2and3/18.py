#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 18
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

try:
    _range = xrange
except NameError:
    _range = range


with open('input_18.txt', 'r') as f:
    data = f.read().strip()


def is_trap(t):
    """Check if triplet is a trap.

    Its left and center tiles are traps, but its right tile is not.
    Its center and right tiles are traps, but its left tile is not.
    Only its left tile is a trap.
    Only its right tile is a trap.

    """
    return sum([
        t[0] and t[1] and not t[2],
        t[2] and t[1] and not t[0],
        t[0] and not t[1] and not t[2],
        t[2] and not t[1] and not t[0],
    ]) == 1


def row_generator(first_row, n=40):
    buffered_row = [False, ] + first_row + [False, ]
    for k in _range(n):
        row = [is_trap(buffered_row[i:i + 3]) for i in _range(0, len(first_row))]
        yield row
        buffered_row = [False, ] + row + [False, ]


def print_map(rows):
    for r in rows:
        print("".join(['^' if v else '.' for v in r]))


rows = [[c == '^' for c in data], ]
for row in row_generator(rows[0], n=40 - 1):
    rows.append(row)

print("[Part 1] Number of safe tiles: {0}".format(
    sum([len(r) - sum(r) for r in rows])))

first_row = [c == '^' for c in data]
count = len(first_row) - sum(first_row)
for row in row_generator(first_row, n=400000 - 1):
    count += len(row) - sum(row)

print("[Part 2] Number of safe tiles: {0}".format(count))
