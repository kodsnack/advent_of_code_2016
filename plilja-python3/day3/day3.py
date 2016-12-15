import sys


def step1(inp):
    r = 0
    for row in input_to_matrix(inp):
        if valid_triangle(row):
            r += 1
    return r


def step2(inp):
    columns = [[], [], []]
    for row in input_to_matrix(inp):
        for i in range(0, 3):
            columns[i] += [row[i]]
    r = 0
    for i in range(0, len(columns[0]), 3):
        for column in columns:
            if valid_triangle(column[i:i + 3]):
                r += 1
    return r


def valid_triangle(xs):
    [a, b, c] = sorted(xs)
    return a + b > c


def input_to_matrix(inp):
    res = []
    for line in inp.strip().split('\n'):
        res += [list(map(int, line.strip().split()))]
    return res


inp = sys.stdin.read()
print(step1(inp))
print(step2(inp))
