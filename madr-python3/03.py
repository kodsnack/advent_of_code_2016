import re
import sys


def find_fake_triangles_hor(puzzle):
    return sum(map(lambda t: t[0] + t[1] > t[2] and t[1] + t[2] > t[0] and t[0] + t[2] > t[1],
                   map(lambda s: (int(s[0]), int(s[1]), int(s[2])), map(lambda l: l.split(), puzzle.split('\n')))))


def find_fake_triangles_ver(puzzle):
    x = (list(map(lambda s: int(s), re.findall(r'^\s+(\d+)', puzzle, flags=re.MULTILINE))) + list(
        map(lambda s: int(s), re.findall(r'^\s+\d+\s+(\d+)', puzzle, flags=re.MULTILINE))) + list(
        map(lambda s: int(s), re.findall(r'^\s+\d+\s+\d+\s+(\d+)', puzzle, flags=re.MULTILINE))))

    return sum([map(lambda t: t[0] + t[1] > t[2] and t[1] + t[2] > t[0] and t[0] + t[2] > t[1],
                   [tuple(x[i:i + 3]) for i in range(0, len(puzzle.split('\n')) * 3, 3)]) for x in [(list(map(lambda s: int(s), re.findall(r'^\s+(\d+)', puzzle, flags=re.MULTILINE))) + list(
        map(lambda s: int(s), re.findall(r'^\s+\d+\s+(\d+)', puzzle, flags=re.MULTILINE))) + list(
        map(lambda s: int(s), re.findall(r'^\s+\d+\s+\d+\s+(\d+)', puzzle, flags=re.MULTILINE))))]][0])


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
