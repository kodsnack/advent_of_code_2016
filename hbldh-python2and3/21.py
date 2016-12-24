#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 21
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import re

try:
    _range = xrange
except NameError:
    _range = range

with open('input_21.txt', 'r') as f:
    data = f.read().strip().splitlines()


swap_regex = re.compile('swap ([\w]+) ([\d\w]+) with ([\w]+) ([\d\w]+)')
rotate_based_regex = re.compile('rotate based on position of letter ([\w])')
rotate_left_right_regex = re.compile('rotate ([\w]+) ([\d]+) step')
reverse_regex = re.compile('reverse positions ([\d]+) through ([\d]+)')
move_regex = re.compile('move position ([\d]+) to position ([\d]+)')


def scramble(instructions, plaintext):
    scrambled_text = plaintext
    for instruction in instructions:
        if instruction.startswith('swap'):
            scrambled_text = swap(scrambled_text, *swap_regex.search(
                instruction).groups())
        elif instruction.startswith('rotate based'):
            letter = rotate_based_regex.search(instruction).groups()[0]
            i = scrambled_text.find(letter)
            if i >= 4:
                i += 1
            scrambled_text = rotate(scrambled_text, 1, i + 1)
        elif instruction.startswith('rotate'):
            direction, distance = rotate_left_right_regex.search(
                instruction).groups()
            scrambled_text = rotate(scrambled_text,
                                    1 if direction == 'right' else -1,
                                    int(distance))
        elif instruction.startswith('reverse'):
            positions = reverse_regex.search(instruction).groups()
            scrambled_text = reverse(
                scrambled_text, int(positions[0]), int(positions[1]))
        elif instruction.startswith('move'):
            positions = move_regex.search(instruction).groups()
            scrambled_text = move(
                scrambled_text, int(positions[0]), int(positions[1]))
        else:
            raise ValueError("Unhandled instruction: {0}".format(instruction))
    return scrambled_text


def swap(text, source_obj, source_item, dest_obj, dest_item):
    """Swap operations.

    ``swap position X with position Y`` means that the letters at
    indexes X and Y (counting from 0) should be swapped.

    ``swap letter X with letter Y`` means that the letters X and Y should be
    swapped (regardless of where they appear in the string).
    """
    if source_obj == 'letter':
        source_indices = [x.start() for x in re.finditer(source_item, text)]
        dest_indices = [x.start() for x in re.finditer(dest_item, text)]
        chars = [t for t in text]
        for i in source_indices:
            chars[i] = dest_item
        for i in dest_indices:
            chars[i] = source_item
        return "".join(chars)
    else:
        chars = [t for t in text]
        tmp = chars[int(source_item)]
        chars[int(source_item)] = chars[int(dest_item)]
        chars[int(dest_item)] = tmp
        return "".join(chars)


def rotate(text, direction, distance):
    """Rotate operations.

    rotate left/right X steps means that the whole string should be
    rotated; for example, one right rotation would turn abcd into dabc.

    rotate based on position of letter X means that the whole string should be
    rotated to the right based on the index of letter X (counting from 0) as
    determined before this instruction does any rotations. Once the index is
    determined, rotate the string to the right one time, plus a number of
    times equal to that index, plus one additional time if the index was at
    least 4.

    """

    d = direction * (distance % len(text))
    return text[-d:] + text[:-d]


def reverse(text, i, j):
    """Reverse operation.

    reverse positions X through Y means that the span of letters at
    indexes X through Y (including the letters at X and Y) should be
    reversed in order.

    """
    chars = [t for t in text]
    return "".join(chars[:i] + chars[i:j+1][::-1] + chars[j+1:])


def move(text, i, j):
    """Move operation.

    move position X to position Y means that the letter which is at
    index X should be removed from the string, then inserted such that it
    ends up at index Y.

    """
    chars = [t for t in text]
    letter = chars[i]
    chars.pop(i)
    chars.insert(j, letter)
    return "".join(chars)

print("[Part 1] Scrambling results: {0}".format(scramble(data, "abcdefgh")))

# Brute force the unscrambling since password is only 8 characters long
# and has only 8 possible values...
from itertools import permutations

for permutation in permutations("abcdefgh"):
    if scramble(data, "".join(permutation)) == "fbgdceah":
        print("[Part 2] Unscrambling results: {0}".format("".join(permutation)))
        break


