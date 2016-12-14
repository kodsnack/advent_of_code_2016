#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 4
=====================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re
import string
from collections import Counter

try:
    maketrans = str.maketrans
except AttributeError:
    maketrans = string.maketrans


def data_generator():
    with open('input_04.txt', 'r') as f:
        indata = f.readline()
        while indata:
            yield indata
            indata = f.readline()

regex = re.compile('^(.*)\-([0-9]*)\[(\w{5})\]$', re.DOTALL)


def splitter(s):
    return regex.search(s.strip()).groups()


def validator(data):
    c = Counter(data[0].replace('-', ''))
    five_most_common = sorted(c.items(), key=lambda x: (x[1], -ord(x[0])), reverse=True)[:5]
    checksum = "".join([x[0] for x in five_most_common])
    return True if checksum == data[2] else False

the_sum = 0
for row in data_generator():
    split_row = splitter(row)
    the_sum += int(split_row[1]) if validator(split_row) else 0
print("[Part 1] Section ID Sum: {0}".format(the_sum))


def translate(s, section_id):
    d = section_id % len(string.ascii_lowercase)
    t = maketrans(string.ascii_lowercase, string.ascii_lowercase[d:] + string.ascii_lowercase[:d])
    return s.translate(t)

for row in data_generator():
    split_row = splitter(row)
    if validator(split_row):
        decrypted_name = translate(split_row[0], int(split_row[1]))
        if 'north' in decrypted_name and 'pole' in decrypted_name:
            print("[Part 2] Room name: {0}, Sector ID: {1}".format(decrypted_name, split_row[1]))
