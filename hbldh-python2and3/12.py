#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 12
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re

with open('input_12.txt', 'r') as f:
    instructions = f.read().strip().splitlines()


def solve(registers):
    n = 0
    while n < len(instructions):
        parts = instructions[n].split(' ')
        if parts[0] == 'cpy':
            registers[parts[2]] = int(parts[1]) if parts[1].isdigit() else registers[parts[1]]
        elif parts[0] == 'inc':
            registers[parts[1]] += 1
        elif parts[0] == 'dec':
            registers[parts[1]] -= 1
        elif parts[0] == 'jnz':
            parts[1] = int(parts[1]) if parts[1].isdigit() else registers[parts[1]]
            if parts[1] != 0:
                n += int(parts[2])
                continue
        else:
            raise ValueError(str(parts))
        n += 1

    return registers

print("[Part 1]: Register 'a': {a}".format(**solve({'a': 0, 'b': 0, 'c': 0, 'd': 0})))
print("[Part 2]: Register 'a': {a}".format(**solve({'a': 0, 'b': 0, 'c': 1, 'd': 0})))


