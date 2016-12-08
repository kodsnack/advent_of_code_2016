import re
import sys


def rotate(o, w, h, matrix):
    e = re.match(r'rotate.+([x|y])=(\d+) by (\d+)', o)
    if e:
        t, s, d = e.groups()
        lit = list()
        m = list()
        if t == 'x':
            for c in range(0, w):
                lit.append(matrix[c::w])
            for r in range(0, int(d)):
                lit[int(s)] = lit[int(s)][h - 1:] + lit[int(s)][0:h - 1]
            for c in zip(*lit):
                m.extend(c)
        if t == 'y':
            for c in range(0, w):
                lit.append(matrix[c::w])
            lit = list(zip(*lit))
            for r in range(0, int(d)):
                lit[int(s)] = lit[int(s)][w - 1:] + lit[int(s)][0:w - 1]
            for c in lit:
                m.extend(c)
        return m
    else:
        return matrix


def rect(o, w, h, matrix):
    e = re.match(r'rect (\d+)x(\d+)', o)
    if e:
        x, y = e.groups()
        lit = list()
        r = list(range(0, w * h))
        for c in range(0, int(x)):
            lit += r[c::w][:int(y)]
        for n in lit:
            matrix[n] = True
        return matrix
    else:
        return matrix


def lit_screen(w, h, pinput):
    matrix = [False for i in range(0, w * h)]

    for o in pinput:
        matrix = rect(o, w, h, matrix)
        matrix = rotate(o, w, h, matrix)

    out = list()
    for l in range(0, w * h, w):
        out.append(''.join(map(lambda l: '#' if l else ' ', matrix[l:l+w])))

    return sum(matrix), '\n'.join(out)


def run(pinput):
    """Day 8: Two-Factor Authentication"""
    pl, out = lit_screen(50, 6, pinput.strip().split('\n'))

    print('\n%s\n' % out)
    print('Pixels lit:                             %s' % pl)


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read().strip())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
    except IndexError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
