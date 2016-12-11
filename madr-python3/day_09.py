import re
import sys


def decompress(pinput):
    parts = list()
    m = re.match(r'.*\((\d+)x(\d+)\)', pinput)
    if m:
        while re.match(r'.*\((\d+)x(\d+)\)', pinput):
            a, c, r, b = re.split(r'\((\d+)x(\d+)\)', pinput, maxsplit=1)
            parts.append(a)
            parts.append(''.join([b[0:int(c)] for i in range(0, int(r))]))
            pinput = b[int(c):]
        return sum(map(lambda s: len(s), parts)) + len(pinput)
    else:
        return len(pinput)


def decompress_V2(pinput):
    # Algorithm found at:
    # https://www.reddit.com/r/adventofcode/comments/5hbygy/2016_day_9_solutions/
    l = 0
    w = [1 for c in pinput]
    cur = 0
    while cur < len(pinput):
        if pinput[cur] == '(':
            s, r = re.match(r'\((\d+)x(\d+)\)', pinput[cur:]).groups()
            cur += len('(%sx%s)' % (s, r))
            for i in range(cur, cur + int(s)):
                w[i] *= int(r)
        else:
            l += w[cur]
            cur += 1
    return l


def run(pinput):
    """Day 9: Explosives in Cyberspace"""
    v1 = decompress(pinput)
    v2 = decompress_V2(pinput)
    print('Decrompressed length, v1:               %s' % v1)
    print('Decrompressed length, v2:               %s' % v2)


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read().strip())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
    except IndexError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
