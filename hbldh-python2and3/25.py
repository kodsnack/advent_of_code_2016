#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 25
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import


with open('input_25.txt', 'r') as f:
    data = f.read().strip().splitlines()


def clock_signal_generator(instructions, registers):
    def get_value(v):
        if v in registers:
            return registers[v]
        else:
            return int(v)
    n = 0
    while n < len(instructions):
        parts = instructions[n].split(' ')
        if parts[0] == 'cpy':
            m = get_value(parts[1])
            if parts[2] in registers:
                registers[parts[2]] = m
            else:
                print("Invalid instruction: {0}".format(instructions[n]))
        elif parts[0] == 'inc':
            if ((n + 4) < len(instructions) and (len(instructions) - 1) >= 0 and
                    instructions[n - 1].startswith('cpy') and
                    instructions[n+1].startswith('dec') and
                    instructions[n+2].startswith('jnz') and
                    instructions[n+3].startswith('dec') and
                    instructions[n+4].startswith('jnz')):
                # Double for loop. Compress.
                # FIXME: Lots of checking should be done here but is omitted.
                # It works for this special case, and that is enough for the task...
                register_to_increment = parts[1]

                inner_loop_length = instructions[n - 1].split(" ")[1]
                inner_loop_register = instructions[n+1].split(' ')[1]
                outer_loop_register = instructions[n+3].split(' ')[1]

                registers[register_to_increment] += get_value(inner_loop_length) * get_value(outer_loop_register)
                registers[inner_loop_register] = 0
                registers[outer_loop_register] = 0

                n += 5
                continue
            else:
                registers[parts[1]] += 1
        elif parts[0] == 'dec':
            registers[parts[1]] -= 1
        elif parts[0] == 'jnz':
            x = get_value(parts[1])
            if x != 0:
                n += get_value(parts[2])
                continue
        elif parts[0] == 'tgl':
            to_toggle = n + get_value(parts[1])
            if to_toggle < len(instructions):
                toggle_parts = instructions[to_toggle].split(' ')
                if toggle_parts[0] == 'cpy':
                    toggle_parts[0] = 'jnz'
                elif toggle_parts[0] == 'inc':
                    toggle_parts[0] = 'dec'
                elif toggle_parts[0] == 'dec':
                    toggle_parts[0] = 'inc'
                elif toggle_parts[0] == 'jnz':
                    toggle_parts[0] = 'cpy'
                elif toggle_parts[0] == 'tgl':
                    toggle_parts[0] = 'inc'
                instructions[to_toggle] = " ".join(toggle_parts)
        elif parts[0] == 'out':
            yield get_value(parts[1])
        else:
            raise ValueError(str(parts))
        n += 1


out1 = '10' * 10
out2 = '01' * 10
k = 1
while True:

    out = []
    for x in clock_signal_generator(data, {'a': k, 'b': 0, 'c': 0, 'd': 0}):
        out.append(str(x))
        if len(out) == len(out1):
            break
    if "".join(out) == out1 or "".join(out) == out2:
        break
    k += 1

print("[Part 1]: Lowest possible integer: {0}".format(k))
