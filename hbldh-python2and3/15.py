#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 15
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re
with open('input_15.txt', 'r') as f:
    data = f.read().strip()

disc_data = re.findall('Disc #(\d*) has (\d*) positions; at time=(\d*), it is at position (\d*).', data, re.M)


def generator(n_positions, start_position, generator, offset):
    if not generator:
        n = n_positions - start_position
        yield n
        while True:
            n += n_positions
            yield n
    else:
        desired_value = offset % n_positions
        for k in generator:
            if ((k + start_position) % n_positions) == desired_value:
                yield k


def solve(discs):
    g = None
    for offset, disc in enumerate(discs[::-1]):
        g = generator(int(disc[1]), int(disc[3]), g, offset)

    for value in g:
        break
    return value - len(discs)


print("[Part 1] First value: {0}".format(solve(disc_data)))
disc_data.append((7, 11, 0, 0))
print("[Part 2] First value: {0}".format(solve(disc_data)))
