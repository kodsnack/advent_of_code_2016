#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Advent of Code, Day 24
======================

Author: hbldh <henrik.blidh@nedomkull.com>

"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import heapq
import itertools

with open('input_24.txt', 'r') as f:
    data = f.read().strip().splitlines()


def parse_data_to_map(input_data):
    positions = {}
    map_grid = []
    for y, row in enumerate(input_data):
        map_grid.append([])
        for x, element in enumerate(row):
            map_grid[-1].append(element)
            if element.isdigit():
                positions[element] = (x, y)
    return map_grid, positions


def find_distances(map_grid, positions):
    distances = {t: {tt: None for tt in positions.keys()} for t in positions.keys()}
    for start_tag in sorted(distances.keys()):
        distances[start_tag].pop(start_tag)
        start = positions[start_tag]
        q = []
        heapq.heappush(q, (0, start, 0))

        visited = {start: True}
        while any([v is None for v in distances[start_tag].values()]):
            state = heapq.heappop(q)

            for x, y in zip([-1, 1, 0, 0], [0, 0, -1, 1]):
                new_x, new_y = state[1][0] + x, state[1][1] + y
                # Check if already visited.
                if (new_x, new_y) in visited:
                    continue
                # Check if wall.
                elif map_grid[new_y][new_x] == '#':
                    continue
                elif map_grid[new_y][new_x].isdigit() and map_grid[new_y][new_x] in distances[start_tag]:
                    # Arrived at numbered location.
                    if distances[start_tag][map_grid[new_y][new_x]] is None:
                        distances[start_tag][map_grid[new_y][new_x]] = state[-1] + 1
                        distances[map_grid[new_y][new_x]][start_tag] = state[-1] + 1

                heapq.heappush(q, (state[-1] + 1, (new_x, new_y), state[-1] + 1))
                visited[(new_x, new_y)] = True
    return distances


def solve_part_1(map_grid, positions):
    distances = find_distances(map_grid, positions)
    path_distances = {}
    for p in itertools.permutations(sorted(positions.keys())[1:]):
        path_distances[p] = 0
        for p_src, p_dest in zip(['0', ] + list(p[:-1]), p):
            path_distances[p] += distances[p_src][p_dest]
    return path_distances


def solve_part_2(map_grid, positions):
    distances = find_distances(map_grid, positions)
    path_distances = {}
    for p in itertools.permutations(sorted(positions.keys())[1:]):
        path_distances[p] = 0
        for p_src, p_dest in zip(['0', ] + list(p), list(p) + ['0', ]):
            path_distances[p] += distances[p_src][p_dest]
    return path_distances


the_map, target_positions = parse_data_to_map(data)

solution_1 = solve_part_1(the_map, target_positions)
print("[Part 1]: Shortest path: {0}".format(min(solution_1.values())))

solution_2 = solve_part_2(the_map, target_positions)
print("[Part 2]: Shortest path: {0}".format(min(solution_2.values())))
