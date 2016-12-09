import re
import sys


def run(pinput):
    """Day 3: Squares With Three Sides"""
    h = find_fake_triangles_hor(pinput)
    v = find_fake_triangles_ver(pinput)

    print('Fake triangles count, horizontal:       %s' % h)
    print('Fake triangles count, vertical:         %s' % v)


def find_fake_triangles_hor(pinput):
    # see commit 8fd8787 for the more readable edition
    return sum(map(lambda t: t[0] + t[1] > t[2], map(lambda l: sorted(map(int, l.split())), pinput.split('\n'))))


def find_fake_triangles_ver(pinput):
    # do it in 1 loc? challenge accepted! also, I'm sorry.
    return sum([map(lambda t: t[0] + t[1] > t[2],
                    [sorted(x[i:i + 3]) for i in range(0, len(x), 3)]) for x in
                [(list(map(int, re.findall(r'^\s+(\d+)', pinput, flags=re.MULTILINE))) + list(
                    map(int, re.findall(r'^\s+\d+\s+(\d+)', pinput, flags=re.MULTILINE))) + list(
                    map(int, re.findall(r'^\s+\d+\s+\d+\s+(\d+)', pinput, flags=re.MULTILINE))))]][0])


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
    except IndexError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
