#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 14
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re
from hashlib import md5
try:
    _range = xrange
except NameError:
    _range = range

with open('input_14.txt', 'r') as f:
    data = f.read().strip()


def md5hex_part_1(key, value):
    return md5("{0}{1}".format(key, value).encode()).hexdigest()


def md5hex_part_2(key, value):
    m = md5("{0}{1}".format(key, value).encode()).hexdigest()
    for k in _range(2016):
        m = md5(m.encode()).hexdigest()
    return m


def solve(key, hashing_fcn):
    keys = {}
    to_find = {}

    n = 0
    three_in_a_row = re.compile(r'(.)\1\1', re.DOTALL)
    while len(keys) < 64:
        md5_for_n = hashing_fcn(key, n)
        to_pop = []
        for index, (value, potential_key) in to_find.items():
            if n - index <= 1000:
                if value in md5_for_n:
                    keys[potential_key] = index
                    to_pop.append(index)
            else:
                to_pop.append(index)
        [to_find.pop(index) for index in to_pop]

        m = three_in_a_row.search(md5_for_n)
        if m:
            to_find[n] = (m.groups()[0] * 5, md5_for_n)
        n += 1
    return keys

keys = solve(data, md5hex_part_1)
print("[Part 1] Index for key 64: {0}".format(sorted(keys.values())[63]))

keys = solve(data, md5hex_part_2)
print("[Part 2] Index for key 64: {0}".format(sorted(keys.values())[63]))
