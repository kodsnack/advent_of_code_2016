from hashlib import md5
import re

input = 'jlmsuwbz'

#Pre generate hash, key stretch n times
def generate_hash(s,n):
    h = [s+str(i) for i in range(100000)]
    for i in range(n):
        h = [md5(x).hexdigest() for x in h]
    return h

#Find keys
def find_keys(hash):
    i3 = 0
    keys = []
    while len(keys)<64:
        h3 = hash[i3]
        m3 = re.findall(r'((\w)\2\2)',h3)
        if m3:
            for i5 in range(i3,i3+1000):
                h5 = hash[i5]
                m5 = re.findall(r'((\w)\2\2\2\2)',h5)
                if m5:
                    if m3[0][1] in [m[0][1] for m in m5] and not i3==i5:
                        keys += [i3]
                        break
        i3 += 1
    return keys[-1]


print 'Part 1:', find_keys(generate_hash(input, 1))
print 'Part 2:', find_keys(generate_hash(input, 2017))

