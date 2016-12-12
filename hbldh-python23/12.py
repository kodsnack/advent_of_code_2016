#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
12
-----------

:copyright: 2016-12-12 by hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re

with open('input_12.txt', 'r') as f:
    instructions = f.read().strip().splitlines()

cpy = re.compile('cpy ([\d\w]*) ([\d\w]*)')
inc = re.compile('inc ([\d\w]*)')
dec = re.compile('dec ([\d\w]*)')
jnz = re.compile('jnz ([\d\w]*) ([\-\d\w]*)')


def solve(registers):
    n = 0
    while n < len(instructions):
        instruction = instructions[n]
        if cpy.match(instruction):
            x, y = cpy.search(instruction).groups()
            x = int(x) if x.isdigit() else registers[x]
            registers[y] = x
        elif inc.match(instruction):
            x = inc.search(instruction).groups()[0]
            registers[x] += 1
        elif dec.match(instruction):
            x = dec.search(instruction).groups()[0]
            registers[x] -= 1
        elif jnz.match(instruction):
            x, y = jnz.search(instruction).groups()
            x = int(x) if x.isdigit() else registers[x]
            if x != 0:
                n += int(y)
                continue
        n += 1

    print(registers)

solve({'a': 0, 'b': 0, 'c': 0, 'd': 0})
solve({'a': 0, 'b': 0, 'c': 1, 'd': 0})


