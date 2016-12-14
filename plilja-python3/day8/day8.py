import sys
import operator

def rect(grid, x, y):
    for i in range(0, y):
        for j in range(0, x):
            grid[i][j] = True

def rotate(getter, setter, n, m):
    new = [getter(i) for i in range(0, m)]
    n = n % m 
    for i in range(0, m):
        new[i] = getter(i - n % m)
    for i in range(0, m):
        setter(i, new[i])

def rotate_row(grid, y, n):
    rotate(lambda i: grid[y][i], lambda i, v: operator.setitem(grid[y], i, v), n, len(grid[y]))

def rotate_column(grid, x, n):
    rotate(lambda i: grid[i][x], lambda i, v: operator.setitem(grid[i], x, v), n, len(grid))

def get_grid(inp):
    grid = [[False for i in range(0, 50)] for j in range(0, 6)]
    for line in inp:
        instructions = line.split()
        op = instructions[0]
        if op == 'rect':
            [x, y] = list(map(int, instructions[1].split('x')))
            rect(grid, x, y)
        elif instructions[1] == 'row':
            x= int(instructions[2][2:])
            n = int(instructions[4])
            rotate_row(grid, x, n)
        else:
            assert(instructions[1] == 'column')
            y = int(instructions[2][2:])
            n = int(instructions[4])
            rotate_column(grid, y, n)
    return grid

def step1(inp):
    grid = get_grid(inp)
    ans = 0
    for row in grid:
        for cell in row:
            if cell:
                ans += 1
    return ans

def step2(inp):
    grid = get_grid(inp)
    for row in grid:
        for cell in row:
            c = '#' if cell else ' '
            print(c, end='')
        print()

inp = sys.stdin.readlines()
print(step1(inp))
step2(inp)
