import re
import sys
from collections import Counter


def sum_sector_ids(puzzle):
    codes = list()
    for l in puzzle.splitlines():
        code, id, checksum = re.match(r'^(\D+)(\d+)\[(\D+?)\]$', l.translate({ord('-'): None})).groups()
        most_common = ''.join(map(lambda x: x[0], sorted(
            sorted(Counter(''.join(sorted(code))).most_common(20)),
            key=lambda x: x[1], reverse=True)[:5]))
        if most_common == checksum:
            codes.append(int(id))
    return sum(codes)


def run(puzzle):
    """Day 4: Security Through Obscurity"""
    s = sum_sector_ids(puzzle)

    print('Sum of sector IDs, real rooms:          %s' % s)


if __name__ == '__main__':
    try:
        run('\n'.join(['aaaaa-bbb-z-y-x-123[abxyz]', 'a-b-c-d-e-f-g-h-987[abcde]', 'not-a-real-room-404[oarel]',
                       'totally-real-room-200[decoy]']))
        with open(sys.argv[1], 'r') as f:
            run(f.read())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
