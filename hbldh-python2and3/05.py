#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 5
=====================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import hashlib

with open('input_05.txt', 'r') as f:
    data = f.read().strip()

pwd = []
n = 0
while len(pwd) < 8:
    n += 1
    s = hashlib.md5((data + str(n)).encode('utf-8')).hexdigest()
    if s.startswith('00000'):
        pwd.append(s[5])
        print(n, s[5])

print("[Part 1] Password: {0}".format("".join(pwd)))


pwd = [-1] * 8
n = 0
while -1 in pwd:
    n += 1
    s = hashlib.md5((data + str(n)).encode('utf-8')).hexdigest()
    if s.startswith('00000'):
        i = int(s[5], 16)
        if i < len(pwd) and pwd[i] == -1:
            pwd[i] = s[6]
            print(n, s[5], s[6])

print("[Part 2] Password: {0}".format("".join(pwd)))
