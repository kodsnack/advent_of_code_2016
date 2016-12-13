#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 3
=====================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import


def splitter(s):
    return list(map(int, s.strip().split()))


def part_1_generator():
    with open('input_03.txt', 'r') as f:
        data = f.readline()
        while data:
            yield sorted(splitter(data))
            data = f.readline()


def part_2_generator():
    # Unreadable functional version.
    # try:
    #     from itertools import izip_longest as zip_longest  # for Python 2.x
    # except ImportError:
    #     from itertools import zip_longest  # for Python 3.x
    # from itertools import chain
    # with open('input_03.txt', 'r') as f:
    #     for column in zip_longest(*[iter(chain(*list(map(
    #             list, zip(*[splitter(row) for row in f.readlines()])))))] * 3):
    #         yield sorted(column)

    with open('input_03.txt', 'r') as f:
        data = [splitter(f.readline()) for i in range(3)]
        while data[0]:
            for column in list(map(list, zip(*data))):
                yield sorted(column)
            data = [splitter(f.readline()) for i in range(3)]


def solve(generator):
    return sum([((x[0] + x[1]) > x[2]) for x in generator])

print("[Part 1] {0} valid triangles.".format(solve(part_1_generator())))
print("[Part 2] {0} valid triangles.".format(solve(part_2_generator())))
