import hashlib
import sys
from collections import Counter


def get_message(puzzle):
    return ''.join(map(lambda l: Counter(l).most_common(1)[0][0], list(zip(*puzzle.split('\n')))))


def run(puzzle):
    """Day 6: Signals and Noise"""
    m = get_message(puzzle)
    #q = hack_password_again(puzzle)

    print('Corrected message:                      %s' % m)
    #print('Password, second door:                  %s' % q)


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run("""eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
            """.strip())
            run(f.read().strip())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
