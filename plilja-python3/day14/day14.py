import hashlib
import sys
from collections import defaultdict


def step1(salt):
    return solve(salt, md5)


def step2(salt):
    return solve(salt, stretched_hash)


def solve(salt, hash_function):
    i = 0
    keys = set()
    max_key = -1
    consecutive3 = []
    consecutive3_chr = defaultdict(list)
    while True:
        h = hash_function(salt + str(i))

        while consecutive3 and i - consecutive3[0][0] > 1000:
            (j, c) = consecutive3[0]
            consecutive3 = consecutive3[1:]
            consecutive3_chr[c] = consecutive3_chr[c][1:]

        for c in consecutive(h, 5):
            for j in consecutive3_chr[c]:
                keys |= {j}
                max_key = max(max_key, j)

        cs = consecutive(h, 3)
        if cs:
            consecutive3 += [(i, cs[0])]
            consecutive3_chr[cs[0]] += [i]

        if len(keys) >= 64 and max_key < i - 1000:
            break

        i += 1

    return sorted(list(keys))[63]


def consecutive(s, n):
    count = 0
    p = chr(ord(s[0]) + 1)
    r = []
    for c in s:
        if c != p:
            count = 0
        p = c
        count += 1
        if count == n:
            r += [c]
    return r


def stretched_hash(s):
    r = s
    for _ in range(0, 2017):
        r = md5(r)
    return r


def md5(v):
    m = hashlib.md5()
    m.update(v.encode('utf-8'))
    return m.hexdigest()


salt = input().strip()
print(step1(salt))
print('This one is slow...', file=sys.stderr)
print(step2(salt))
