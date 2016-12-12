#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 10
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re


class Bot(object):

    def __init__(self, nbr):
        self.nbr = nbr
        self.chips = []
        self.instruction = None

    def __str__(self):
        return 'Bot {0}: Chips: {1}, Instruction: "{2}"'.format(self.nbr, self.chips, self.instruction)

    @property
    def is_ready(self):
        return len(self.chips) == 2

    def check_part_1(self):
        if self.is_ready and self.chips[0] == 17 and self.chips[1] == 61:
            print("[Part 1] Bot {0} is responsible for comparing 61 and 17 microchips.".format(self.nbr))

    def add_chip(self, chip):
        self.chips.append(int(chip))
        self.chips.sort()
        self.check_part_1()
        return self.is_ready

    def execute_instruction(self, bots_dict, outputs_dict):
        ready_receiver_bots = []
        source_nbr, low_dest_what, low_dest_nbr, high_dest_what, high_dest_nbr = give_instruction_regex.search(self.instruction).groups()
        for dw, dn, chip in zip([low_dest_what, high_dest_what],
                                [int(low_dest_nbr), int(high_dest_nbr)],
                                self.chips):
            if dw == 'bot':
                if bots_dict[dn].add_chip(chip):
                    ready_receiver_bots.append(dn)
            else:
                if dn not in outputs_dict:
                    outputs_dict[dn] = []
                outputs_dict[dn] = chip
        self.chips = []
        return ready_receiver_bots

with open('input_10.txt', 'r') as f:
    data = f.read().strip().splitlines()

give_instruction_regex = re.compile("bot (\d*) gives low to (\w*)\s(\d*) and high to (\w*)\s(\d*)")
assignment_regex = re.compile("value (\d*) goes to (\w*)\s(\d*)")

actions = []
bots = {}
outputs = {}

for instruction in data:
    if assignment_regex.match(instruction):
        chip, what, nbr = assignment_regex.search(instruction).groups()
        nbr = int(nbr)
        if what == 'bot':
            if nbr not in bots:
                bots[nbr] = Bot(nbr)
            bots[nbr].add_chip(chip)
    else:
        source_nbr, low_dest_what, low_dest_nbr, high_dest_what, high_dest_nbr = give_instruction_regex.search(instruction).groups()
        source_nbr = int(source_nbr)
        if source_nbr not in bots:
            bots[source_nbr] = Bot(source_nbr)
        bots[source_nbr].instruction = instruction

ready_bots = []
for k in bots:
    if bots.get(k).is_ready:
        ready_bots.append(k)

while len(ready_bots):
    next_ready_bots = []
    for k in ready_bots:
        next_ready_bots += bots.get(k).execute_instruction(bots, outputs)
    ready_bots = next_ready_bots

print("[Part 2] Multiplied contents of Output 0, 1 & 2: {0}".format(outputs[0] * outputs[1] * outputs[2]))
