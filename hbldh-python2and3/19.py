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

from collections import deque

try:
    _range = xrange

except NameError:
    _range = range


with open('input_19.txt', 'r') as f:
    data = f.read().strip()


def find_last_elf_part_1(n):
    elfs = list(range(1, n + 1))
    while len(elfs) > 1:
        elfs = elfs[::2][1:] if len(elfs) % 2 else elfs[::2]
    return elfs[0]

print("[Part 1] Last elf standing: {0}".format(find_last_elf_part_1(int(data))))


def find_last_elf_part_2(n):
    thief_index = 0
    last_victim_distance = 0
    elfs = deque(_range(1, n+1))
    while len(elfs) > 1:
        victim_distance = (thief_index + (len(elfs) // 2)) % len(elfs)
        elfs.rotate(-(victim_distance - last_victim_distance))
        elfs.popleft()
        last_victim_distance = victim_distance
        thief_index = (thief_index + 1) % len(elfs) if thief_index < victim_distance else thief_index % len(elfs)
    return elfs.popleft()

print("[Part 2] Last elf standing: {0}".format(find_last_elf_part_2(int(data))))






