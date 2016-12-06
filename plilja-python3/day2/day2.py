import sys

def step1(inp):
    keypad = ['-----',
              '-123-',
              '-456-',
              '-789-',
              '-----']
    x, y = 2, 2
    return solve(inp, keypad, x, y)

def step2(inp):
    keypad = ['-------',
              '---1---',
              '--234--',
              '-56789-',
              '--ABC--',
              '---D---',
              '-------']
    x, y = 1, 3
    return solve(inp, keypad, x, y)

def solve(inp, keypad, start_x, start_y):
    x, y = start_x, start_y
    code = ''
    directions = {'U' : (0, -1),
                  'D' : (0, 1),
                  'L' : (-1, 0),
                  'R' : (1, 0)}
    for line in map(str.strip, inp):
        for c in line:
            dx, dy = directions[c]
            if keypad[y + dy][x + dx] != '-':
                x += dx
                y += dy
        code += keypad[y][x]
    return code

inp = sys.stdin.readlines()
print(step1(inp))
print(step2(inp))
