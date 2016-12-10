def walk(inp):
    x = 0
    y = 0
    dx = 0
    dy = -1 # face north initially
    r = [(0, 0)]
    for s in inp.replace(',', '').split():
        if s[0] == 'L':
            dx, dy = dy, -dx
        else:
            dx, dy = -dy, dx
        steps = int(s[1:])
        for i in range(0, steps):
            x += dx
            y += dy
            r += [(x, y)]
    return r

def step1(inp):
    (endx, endy) = walk(inp)[-1]
    return abs(endx) + abs(endy)

def step2(inp):
    w = walk(inp)
    visited = set()
    for w in walk(inp):
        if w in visited:
            return abs(w[0]) + abs(w[1])
        visited |= {w}
    return -1

inp = input()
print(step1(inp))
print(step2(inp))
