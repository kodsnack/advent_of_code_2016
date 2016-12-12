#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 7
=====================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re
from itertools import chain


def data_generator():
    with open('input_07.txt', 'r') as f:
        indata = f.readline()
        while indata:
            yield indata
            indata = f.readline()


def supernet_hypernet_splitter(s):
    return re.split(r'\[\w*\]', s), re.findall(r'\[(\w*)\]', s)


def abba_detector(s):
    detected_abba = re.search(r"(\w)(\w)\2\1", s, re.DOTALL)
    return detected_abba is not None and len(set(detected_abba.groups())) == 2


def tls_support(s):
    supernet_sequences, hypernet_sequences = supernet_hypernet_splitter(s)
    supernet_abbas_detected = any(map(abba_detector, supernet_sequences))
    hypernet_abbas_detected = any(map(abba_detector, hypernet_sequences))
    return supernet_abbas_detected and not hypernet_abbas_detected


def aba_extractor(supernet_sections):
    abas = [list(filter(lambda x: x[0] != x[1], re.findall(r'(?=(\w)(\w)(\1))', s)))
                 for s in supernet_sections]
    return list(chain(*abas))


def ssl_support(s):
    supernet_sequences, hypernet_sequences = supernet_hypernet_splitter(s)
    supernet_abas = aba_extractor(supernet_sequences)
    hypernet_abas = aba_extractor(hypernet_sequences)
    abas = ["".join(aba) for aba in supernet_abas]
    return any(["{1}{0}{1}".format(bab[0], bab[1]) in abas for bab in hypernet_abas])


print("[Part 1] Number of IPs with TLS support: {0}".format(sum([tls_support(ip) for ip in data_generator()])))
print("[Part 2] Number of IPs with SSL support: {0}".format(sum([ssl_support(ip) for ip in data_generator()])))
