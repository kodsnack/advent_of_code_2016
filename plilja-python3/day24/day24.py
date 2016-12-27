import sys
from collections import *


def step1(grid):
    return tsp(grid, False)


def step2(grid):
    return tsp(grid, True)


def tsp(grid, return_to_start):
    def solve(grid, current, dists, unvisited, cache = {}):
        if len(unvisited) == 0:
            if return_to_start:
                return dists[current][0]
            else:
                return 0
        if (current, unvisited) in cache:
            return cache[(current, unvisited)]
        r = float('inf')
        for v in unvisited:
            r = min(r, dists[current][v] + solve(grid, v, dists, unvisited - {v}, cache))
        cache[(current, unvisited)] = r
        return r

    def dist(grid, x1, y1, x2, y2):
        q = [(x1, y1, 0)]
        v = set()
        while q:
            (x, y, d) = q[0]
            q = q[1:]
            if (x, y) == (x2, y2):
                return d
            directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
            for dx, dy in directions:
                if x + dx >= 0 and y + dy >= 0 and \
                        y + dy < len(grid) and x + dx < len(grid[y + dy]) and \
                        grid[y + dy][x + dx] != '#' and \
                        (x + dx, y + dy) not in v:
                    q += [(x + dx, y + dy, d + 1)]
                    v |= {(x + dx, y + dy)}
        return float('inf') # impossible

    positions = {}
    unvisited = frozenset()
    for y in range(0, len(grid)):
        for x in range(0, len(grid[y])):
            c = grid[y][x]
            if c >= '1' and c <= '9':
                d = ord(c) - ord('0')
                unvisited |= {d}
                positions[d] = (x, y)
            if c == '0':
                positions[0] = (x, y)
    dists = defaultdict(dict)
    for a in unvisited | {0}:
        for b in unvisited | {0}:
            x1, y1 = positions[a]
            x2, y2 = positions[b]
            dists[a][b] = dist(grid, x1, y1, x2, y2)

    return solve(grid, 0, dists, unvisited)


grid = sys.stdin.readlines()
print(step1(grid))
print(step2(grid))
