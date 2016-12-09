import sys


def run(pinput):
    """Day 2: Bathroom Security"""
    imaginary_code = break_code_imaginary(5, pinput)
    real_code = break_code_real(5, pinput)

    print('Code using imaginary pad:               %s' % imaginary_code)
    print('Code using real pad:                    %s' % real_code)


def break_code_real(start, instructions):
    """
    real pad:

        1
      2 3 4
    5 6 7 8 9
      A B C
        D
    """
    pos = start
    code = ''
    for l in instructions.split('\n'):
        for g in l.strip():
            if g == 'U' and pos not in [1, 2, 4, 5, 9]:
                pos -= 2 if pos in [13, 3] else 4
            if g == 'D' and pos not in [5, 9, 10, 12, 13]:
                pos += 2 if pos in [1, 11] else 4
            if g == 'L' and pos not in [1, 2, 5, 10, 13]:
                pos -= 1
            if g == 'R' and pos not in [1, 4, 9, 12, 13]:
                pos += 1
        code += format(pos, 'X')
    return code


def break_code_imaginary(start, instructions):
    """
    imaginary pad:

    1 2 3
    4 5 6
    7 8 9
    """
    pos = start
    code = ''
    for l in instructions.split('\n'):
        for g in l.strip():
            if g == 'U' and pos > 3:
                pos -= 3
            if g == 'D' and pos < 7:
                pos += 3
            if g == 'L' and pos not in [1, 4, 7]:
                pos -= 1
            if g == 'R' and pos not in [3, 6, 9]:
                pos += 1
        code += str(pos)
    return code


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
    except IndexError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
