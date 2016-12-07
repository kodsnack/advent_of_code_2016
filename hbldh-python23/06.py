#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 6
=====================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

from collections import Counter

with open('input_06.txt', 'r') as f:
    data = f.read().strip().splitlines()

message_1 = []
message_2 = []
columns = list(map(list, zip(*[[ch for ch in row] for row in data])))
for column in columns:
    c = Counter(column)
    message_1.append(c.most_common(1)[0][0])
    message_2.append(c.most_common()[-1][0])

print("Message #1: {0}".format("".join(message_1)))
print("Message #2: {0}".format("".join(message_2)))
