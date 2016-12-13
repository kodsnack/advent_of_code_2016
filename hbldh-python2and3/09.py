#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 9
=====================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re

with open('input_09.txt', 'r') as f:
    input_data = f.read().strip()

regex = re.compile('\((\d*)x(\d*)\)')


def decompress(data, recursive=True):
    i = 0
    output = []

    while i < len(data):
        m = regex.search(data[i:])
        if m:
            n_letters, n_reps = map(int, m.groups())
            marker_length = m.end() - m.start()
            decompressed_data = data[i + marker_length: i + marker_length + n_letters]
            if recursive:
                if regex.match(decompressed_data):
                    decompressed_data = decompress(decompressed_data, recursive=True) * n_reps
            output.append(decompressed_data * n_reps)
            i += marker_length + n_letters
        else:
            output.append(data[i:])
            break
    return "".join(output)


def count(data, recursive=True):
    n = 0
    i = 0

    while i < len(data):
        m = regex.search(data[i:])
        if m:
            n_letters, n_reps = map(int, m.groups())
            marker_length = m.end() - m.start()
            if recursive and regex.match(data[i + marker_length: i + marker_length + n_letters]):
                n += count(data[i + marker_length: i + marker_length + n_letters], recursive=True) * n_reps
            else:
                n += n_letters * n_reps
            i += marker_length + n_letters
        else:
            n += len(data[i:])
            break
    return n


decompressed_data = decompress(input_data, False)
print("[Part 1] Decompressed length: {0}".format(len(decompressed_data)))

recursively_decompressed_data_length = count(input_data, True)
print("[Part 2] Decompressed length: {0}".format(recursively_decompressed_data_length))

