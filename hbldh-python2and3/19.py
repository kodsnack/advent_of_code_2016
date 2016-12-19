#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 19
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import time

try:
    _range = xrange
    PY2 = True
except NameError:
    _range = range
    PY2 = False


with open('input_19.txt', 'r') as f:
    data = f.read().strip()


def find_last_elf_part_1(n):
    elfs = list(range(1, n + 1))
    while len(elfs) > 1:
        elfs = elfs[::2][1:] if len(elfs) % 2 else elfs[::2]
    return elfs[0]

print("[Part 1] Last elf standing: {0}".format(find_last_elf_part_1(int(data))))


def find_last_elf_part_2(n, print_progress=False):
    elfs = list(range(1, n + 1))
    i = 0
    iters = 0
    print_every = n // 100
    while len(elfs) > 1:
        j = (i + (len(elfs) // 2)) % len(elfs)
        elfs.pop(j)
        i = (i + 1) % len(elfs) if i < j else i % len(elfs)
        iters += 1
        if print_progress and iters > print_every:
            print('{:2.1f} % of the elfs left...'.format((len(elfs) / float(n) * 100)))
            iters = 0
    return elfs[0]

t = time.time()
print("[Part 2] Last elf standing: {0}".format(find_last_elf_part_2(int(data), True)))
print("Computation time: {0:.2f} s".format(time.time() - t))




