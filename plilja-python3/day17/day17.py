import hashlib


def solve(passcode):
    def open(c):
        return c >= 'b' and c <= 'f'

    q = []
    q += [(0, 0, 0, '')]
    step1 = float('inf')
    step1_path = 'IMPOSSIBLE'
    step2 = -1
    while q:
        (dist, x, y, path) = q[0]
        q = q[1:]
        if x == 3 and y == 3:
            if dist < step1:
                step1 = dist
                step1_path = path
            step2 = max(step2, dist)
            continue

        h = md5(passcode + path)
        if y > 0 and open(h[0]):
            q += [(dist + 1, x, y - 1, path + 'U')]
        if y < 3 and open(h[1]):
            q += [(dist + 1, x, y + 1, path + 'D')]
        if x > 0 and open(h[2]):
            q += [(dist + 1, x - 1, y, path + 'L')]
        if x < 3 and open(h[3]):
            q += [(dist + 1, x + 1, y, path + 'R')]

    return (step1_path, step2)


def md5(v):
    m = hashlib.md5()
    m.update(v.encode('utf-8'))
    return m.hexdigest()


passcode = input()
step1, step2 = solve(passcode)
print(step1)
print(step2)
