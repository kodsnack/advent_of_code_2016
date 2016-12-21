#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 16
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

try:
    from itertools import izip as _zip
except ImportError:
    _zip = zip

with open('input_16.txt', 'r') as f:
    data = f.read().strip()


def checksum(x):
    c = "".join(['1' if a == b else '0' for a, b in _zip(x[::2], x[1::2])])
    return c if len(c) % 2 != 0 else checksum(c)


def solve(x, L):
    while len(x) < L:
        x = "{0}0{1}".format(x, "".join(['0' if int(b) else '1' for b in x[::-1]]))
    return checksum(x[:L])

print("[Part 1] Checksum: {0}".format(solve(data, 272)))
print("[Part 2] Checksum: {0}".format(solve(data, 35651584)))
