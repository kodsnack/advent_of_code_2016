import hashlib
import itertools

def step1(door_id):
    hashes = itertools.islice(interesting_hashes(door_id), 8)
    return ''.join(map(lambda x : x[5], hashes))

def step2(door_id):
    res = ['_'] * 8 
    for h in interesting_hashes(door_id):
        if h[5] >= '0' and h[5] <= '7':
            i = ord(h[5]) - ord('0')
            if res[i] == '_':
                res[i] = h[6]
                if not '_' in res:
                    return ''.join(res)

def interesting_hashes(door_id):
    j = 0
    while True:
        digest = md5(door_id + str(j))
        j += 1
        if digest[:5] == '00000':
            yield digest

def md5(v):
    m = hashlib.md5()
    m.update(v.encode('utf-8'))
    return m.hexdigest()

door_id = input().strip()
print(step1(door_id))
print(step2(door_id))
