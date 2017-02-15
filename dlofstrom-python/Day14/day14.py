from hashlib import md5
import re

input = 'jlmsuwbz'

i3 = 0
keys = []
while len(keys)<64:
    h3 = md5(input+str(i3)).hexdigest()
    m3 = re.findall(r'((\w)\2\2)',h3)
    if m3:
        for i5 in range(i3,i3+1000):
            h5 = md5(input+str(i5)).hexdigest()
            m5 = re.findall(r'((\w)\2\2\2\2)',h5)
            if m5:
                if m3[0][1] in [m[0][1] for m in m5] and not i3==i5:
                    keys += [i3]
                    break
    #print index, hash
    i3 += 1

print 'Part 1:', keys[-1]
