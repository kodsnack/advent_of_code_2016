import re
import sys


def run(puzzle):
    """Day 3: Squares With Three Sides"""
    h = find_fake_triangles_hor(puzzle)
    v = find_fake_triangles_ver(puzzle)

    print('Fake triangles count, horizontal:       %s' % h)
    print('Fake triangles count, vertical:         %s' % v)


def find_fake_triangles_hor(puzzle):
    # see commit 8fd8787 for the more readable edition
    return sum(map(lambda t: t[0] + t[1] > t[2] and t[1] + t[2] > t[0] and t[0] + t[2] > t[1],
                   map(lambda l: [int(s) for s in l.split()], puzzle.split('\n'))))


def find_fake_triangles_ver(puzzle):
    # do it in 1 loc? challenge accepted! also, I'm sorry.
    return sum([map(lambda t: t[0] + t[1] > t[2] and t[1] + t[2] > t[0] and t[0] + t[2] > t[1],
                    [x[i:i + 3] for i in range(0, len(x), 3)]) for x in
                [(list(map(lambda s: int(s), re.findall(r'^\s+(\d+)', puzzle, flags=re.MULTILINE))) + list(
                    map(lambda s: int(s), re.findall(r'^\s+\d+\s+(\d+)', puzzle, flags=re.MULTILINE))) + list(
                    map(lambda s: int(s), re.findall(r'^\s+\d+\s+\d+\s+(\d+)', puzzle, flags=re.MULTILINE))))]][0])


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
