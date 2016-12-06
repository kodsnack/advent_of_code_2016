import hashlib
import sys


def hack_password(puzzle):
    passwd = ''
    i = 0
    while len(passwd) < 8:
        s = hashlib.md5(bytes('%s%d' % (puzzle, i), 'ascii')).hexdigest()
        if s.startswith('00000'):
            passwd += s[5]
        i += 1
    return passwd


def hack_password_again(puzzle):
    passwd = [' ' for n in range(0, 8)]
    i = 0
    while ' ' in passwd:
        s = hashlib.md5(bytes('%s%d' % (puzzle, i), 'ascii')).hexdigest()
        try:
            pos = int(s[5])
            if s.startswith('00000') and pos < 8:
                passwd[pos] = s[6] if passwd[pos] == ' ' else passwd[pos]
        except ValueError:
            pass
        i += 1
    return ''.join(passwd)


def run(puzzle):
    """Day 5: How About a Nice Game of Chess?"""
    p = hack_password(puzzle)
    q = hack_password_again(puzzle)

    print('Password, first door:                   %s' % p)
    print('Password, second door:                  %s' % q)


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read().strip())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
