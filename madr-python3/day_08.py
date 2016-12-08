import re
import sys


def rotate(o, w, h, matrix):
    try:
        t, s, d = re.match(r'rotate.+([x|y])=([\d+]) by ([\d+])', o).groups()
        print(t, s, d)
        if t == 'y':
            lit = list()
            for c in range(0, w):
                lit.append(matrix[c::w])
            for r in range(0, int(d)):
                c = lit[int(s)]
                lit[int(s)] = c[2:].extend(c[0])
        #for c in range(0, int(x)):
        #    lit += matrix[c::w][:int(y)]
        return [p in lit for p in list(range(0, w * h))]
    except AttributeError:
        return matrix


def rect(o, w, h, matrix):
    try:
        x, y = re.match(r'rect (\d+)x(\d+)', o).groups()
        lit = list()
        for c in range(0, int(x)):
            lit += matrix[c::w][:int(y)]
        return [p in lit for p in list(range(0, w * h))]
    except AttributeError:
        return matrix


def lit_screen(w, h, pinput):
    matrix = list(range(0, w * h))

    for o in pinput:
        matrix = rect(o, w, h, matrix)

    for l in range(0, w * h, w):
        print(''.join(map(lambda l: '#' if l else '.', matrix[l:l+w])))
    return sum(matrix)


def run(pinput):
    """Day 8: Two-Factor Authentication"""
    pl = lit_screen(7, 3, ['rect 3x2', 'rotate column x=1 by 1', 'rotate row y=0 by 4', 'rotate column x=1 by 1'])
    #pl2 = lit_screen(50, 6, pinput)

    print('Pixels lit:                             %s' % pl)
    #print('Pixels lit:                             %s' % pl2)


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read().strip())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
    except IndexError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
