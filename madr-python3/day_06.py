import sys
from collections import Counter


def get_message(puzzle):
    return ''.join(map(lambda l: Counter(l).most_common(1)[0][0], list(zip(*puzzle.split('\n')))))


def get_real_message(puzzle):
    return ''.join(map(lambda l: Counter(l).most_common()[-1][0][0], list(zip(*puzzle.split('\n')))))


def run(puzzle):
    """Day 6: Signals and Noise"""
    m = get_message(puzzle)
    n = get_real_message(puzzle)

    print('Corrected message, most common char:    %s' % m)
    print('Corrected message, least common char:   %s' % n)


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read().strip())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
