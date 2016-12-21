#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 20
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
import re

with open('input_20.txt', 'r') as f:
    data = f.read().strip()

MAX_VAL = 4294967295

def combine_ranges(ranges):
    ranges.sort()
    output_ranges = []
    current_range = list(ranges[0])
    for low, high in ranges:
        if (low - current_range[1]) < 2:
            current_range[1] = high if high > current_range[1] else current_range[1]
        else:
            output_ranges.append(current_range)
            current_range = [low, high]
    output_ranges.append(current_range)
    return output_ranges

disallowed_ranges = [(int(low), int(high)) for low, high in
                     re.findall("(\d*)-(\d*)", data, re.M)]
disallowed_ranges = combine_ranges(disallowed_ranges)

print("[Part 1] Lowest IP allowed: {0}".format(disallowed_ranges[0][1] + 1))

allowed_ips = [_range(disallowed_ranges[0][0]), ]
allowed_ips += [_range(lh_high + 1, rh_low) for (_, lh_high), (rh_low, _) in zip(disallowed_ranges[:-1], disallowed_ranges[1:])]
allowed_ips.append(_range(max([high for _, high in disallowed_ranges]), MAX_VAL))
n_allowed_ips = sum(map(len, allowed_ips))
print("[Part 2] Number of allowed ips: {0}".format(n_allowed_ips))



