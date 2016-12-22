import sys

def step1(ops):
    return scramble('abcdefgh', ops)


def step2(ops):
    return unscramble('fbgdceah', ops)


def unscramble(start, ops):
    for i in range(0, len(ops)):
        if 'left' in ops[i]:
            ops[i] = ops[i].replace('left', 'right')
        else:
            ops[i] = ops[i].replace('right', 'left')
        if 'move' in ops[i]:
            parts = ops[i].split()
            parts[2], parts[5] = parts[5], parts[2]
            ops[i] = ' '.join(parts)
        if 'rotate based on' in ops[i]:
            parts = ops[i].split()
            ops[i] = 'rotate special %s' % parts[6]
    return scramble(start, reversed(ops))


def scramble(start, ops):
    def rotate_left(passwd, n):
        n = n % len(passwd)
        return passwd[n:] + passwd[:n]

    def rotate_right(passwd, n):
        n = n % len(passwd)
        return passwd[-n:] + passwd[:-n]

    def rotate_based_on(passwd, c):
        x = passwd.index(c)
        if x >= 4:
            x += 1
        x += 1
        return rotate_right(passwd, x)

    passwd = [x for x in start]
    for op in ops:
        parts = op.split()
        if parts[0] == 'swap' and parts[1] == 'position':
            x = int(parts[2])
            y = int(parts[5])
            passwd[x], passwd[y] = passwd[y], passwd[x]
        elif parts[0] == 'reverse':
            x = min(int(parts[2]), int(parts[4]))
            y = max(int(parts[2]), int(parts[4]))
            for i in range(0, (y - x + 1) // 2):
                passwd[x + i], passwd[y - i] = passwd[y - i], passwd[x + i]
        elif parts[0] == 'swap' and parts[1] == 'letter':
            x = parts[2][0]
            y = parts[5][0]
            for i in range(0, len(passwd)):
                if passwd[i] == x:
                    passwd[i] = y
                elif passwd[i] == y:
                    passwd[i] = x
        elif parts[0] == 'rotate' and parts[1] == 'special':
            c = parts[2][0]
            new_passwd = passwd
            while rotate_based_on(new_passwd, c) != passwd:
                new_passwd = rotate_left(new_passwd, 1)
            passwd = new_passwd
        elif parts[0] == 'rotate':
            if parts[1] == 'based':
                passwd = rotate_based_on(passwd, parts[6][0])
            else:
                x = int(parts[2])
                if parts[1] == 'left':
                    passwd = rotate_left(passwd, x) 
                else:
                    passwd = rotate_right(passwd, x) 
        else:
            assert parts[0] == 'move'
            x = int(parts[2])
            y = int(parts[5])
            tmp = passwd[x]
            passwd = passwd[:x] + passwd[x + 1:]
            passwd = passwd[:y] + [tmp] + passwd[y:]

    return ''.join(passwd)


ops = sys.stdin.readlines()
print(step1(ops))
print(step2(ops))
