#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 8
=====================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import


def data_generator():
    with open('input_08.txt', 'r') as f:
        indata = f.readline()
        while indata:
            yield indata
            indata = f.readline()


def rect(display, x, y):
    for i in range(x):
        for ii in range(y):
            display[ii][i] = '#'


def rotate_row(display, row, k):
    n_columns = len(display[0])
    display[row] = display[row][-(k % n_columns):] + display[row][:-(k % n_columns)]


def rotate_column(display, column, k):
    n_rows = len(display)
    c = [display[i][column] for i in range(n_rows)]
    c = c[-(k % n_rows):] + c[:-(k % n_rows)]
    for i in range(n_rows):
        display[i][column] = c[i]


size = (50, 6)
display = [[' ', ] * size[0] for i in range(size[1])]

for instruction in data_generator():
    action, params = instruction.strip().split(' ', 1)
    if action == 'rect':
        rect(display, *list(map(int, params.split('x'))))
    else:
        row_or_column, rc_id, _, distance = params.split(' ')
        if row_or_column == 'row':
            rotate_row(display, int(rc_id.split('=')[-1]), int(distance))
        else:
            rotate_column(display, int(rc_id.split('=')[-1]), int(distance))

print("[Part 1] Number of lit pixels: {0}".format(sum([sum([element == '#' for element in row]) for row in display])))
print("[Part 2]")
for r in display:
    print("".join(r))
