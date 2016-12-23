import sys


def step1(inp):
    blacklist = parse_blacklist(inp)
    r = 0
    for lower, upper in blacklist:
        if lower > r:
            return r
        else:
            r = max(r, upper + 1)
    return r


def step2(inp):
    blacklist = parse_blacklist(inp)
    r = 0
    prev = 0
    for lower, upper in blacklist:
        r += max(0, lower - prev)
        prev = max(prev, upper + 1)
    r += max(0, 2**32 - prev)
    return r


def parse_blacklist(inp):
    blacklist = []
    for [lower, upper] in map(lambda s: s.split('-'), inp):
        blacklist += [(int(lower), int(upper))]
    blacklist.sort()
    return blacklist


inp = sys.stdin.readlines()
print(step1(inp))
print(step2(inp))
