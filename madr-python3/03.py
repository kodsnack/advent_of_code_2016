import re
import sys


def find_fake_triangles_hor(puzzle):
    count = 0
    for line in puzzle.split('\n'):
        a, b, c = map(lambda s: int(s), line.split())
        if a + b > c and b + c > a and a + c > b:
            count += 1
    return count


def find_fake_triangles_ver(puzzle):
    count = 0
    t = list(map(lambda x: int(x), re.findall(r'^\s+(\d+)', puzzle, flags=re.MULTILINE))) + \
        list(map(lambda x: int(x), re.findall(r'^\s+\d+\s+(\d+)', puzzle, flags=re.MULTILINE))) + \
        list(map(lambda x: int(x), re.findall(r'^\s+\d+\s+\d+\s+(\d+)', puzzle, flags=re.MULTILINE)))

    return sum(map(lambda t: t[0] + t[1] > t[2] and t[1] + t[2] > t[0] and t[0] + t[2] > t[1], [tuple(t[i:i + 3]) for i in range(0, len(t), 3)]))

if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            puzzle = f.read()

        h = find_fake_triangles_hor(puzzle)
        v = find_fake_triangles_ver(puzzle)

        print('Fake triangles count, horizontal:       %s' % h)
        print('Fake triangles count, vertical:         %s' % v)
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
