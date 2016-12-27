import sys
from collections import *


Node = namedtuple('Node', 'size used')


def step1(inp):
    grid = parse_grid(inp)
    r = 0
    for y1 in range(0, len(grid)):
        for x1 in range(0, len(grid[y1])):
            for y2 in range(0, len(grid)):
                for x2 in range(0, len(grid[y2])):
                    if x1 == x2 and y1 == y2:
                        continue
                    n1 = grid[y1][x1]
                    n2 = grid[y2][x2]
                    if n1.used > 0 and n2.size - n2.used >= n1.used:
                        r += 1
    return r


def step2(inp):
    def bfs(grid):
        """
        Finds the cheapest way (sort of at least, it's assumes that the input is easy like the problem example)
        to move a node that has enough room for the payload to the cell right left of the payload.
        """
        payload = grid[0][-1]
        target_coord = (len(grid[0]) - 2, 0)
        q = []
        for y in range(0, len(grid)):
            for x in range(0, len(grid[y])):
                n = grid[y][x]
                if grid[y][x].size - grid[y][x].used >= payload.used:
                    q += [(x, y, 0)]
        directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        visited = set()
        while q:
            (x, y, d) = q[0]
            q = q[1:]
            if (x, y) == target_coord:
                return d
            for dx, dy in directions:
                if x + dx >= 0 and \
                        y + dy >= 0 and \
                        y + dy < len(grid) and \
                        x + dx < len(grid[y + dy]) and \
                        grid[y][x].size >= grid[y + dy][x + dx].used and \
                        grid[y + dy][x + dx].used > 0 and \
                        (x + dx, y + dy) not in visited:
                    visited |= {(x + dx, y + dy)}
                    q += [(x + dx, y + dy, d + 1)]

        return float('inf') # impossible


    grid = parse_grid(inp)
    d = bfs(grid)
    x_dist = len(grid[0])
    # A crazy simplification really. Take an empty cell large enough
    # to fit the payload. Move that empty cell right left of the payload. Then iterate 
    # the payload one step to the left until we reach top left, each one step cost 5 moves (just like the example case).
    # This would not work for any problem input but it happens to work for the current problem input.
    # A general purpose solution would be way to slow for the current problem input.
    return d + 5 * (x_dist - 2) + 1


def parse_grid(inp):
    nodes_dict = defaultdict(dict)
    nodes = []
    max_x = 0
    max_y = 0
    for [node, size, used, avail, percentage] in map(str.split, inp):
        [x_str, y_str] = node[node.index('-') + 1:].split('-')
        x = int(x_str[1:])
        y = int(y_str[1:])
        size = int(size[:-1])
        used = int(used[:-1])
        avail = int(avail[:-1])
        assert(size - used == avail)
        nodes_dict[y][x] = Node(size, used)
        max_x = max(max_x, x)
        max_y = max(max_y, y)

    grid = [[Node(0, 0)] * (max_x + 1) for i in range(0, max_y + 1)]
    for y, v in nodes_dict.items():
        for x, node in v.items():
            grid[y][x] = node

    return grid


input() # skip
input() # skip
df = sys.stdin.readlines()
print(step1(df))
print(step2(df))
