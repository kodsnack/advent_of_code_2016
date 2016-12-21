import re

input = open('day9-input.txt','r').read().strip(' \r\n')

#Part 1
uncompressed = ''
pattern = '\([0-9]{1,}x[0-9]{1,}\)'
while True:
    match = re.search(pattern, input)
    if match:
        marker = [int(x) for x in match.group(0)[1:-1].split('x')]
        split = re.split(pattern, input, 1)
        uncompressed += split[0]
        uncompressed += split[1][:marker[0]]*marker[1]
        input = split[1][marker[0]:]
    else:
        uncompressed += input
        input = ''
    if input == '':
        break

print 'Part 1:', len(uncompressed)

#Part 2
input = open('day9-input.txt','r').read().strip(' \r\n')
#Search for marker and recursively summarize length of decompressed data
def s(p, w, d):
    match = re.search(p, d)
    if match:
        l, next_w = [int(x) for x in match.group(0)[1:-1].split('x')]
        sp = re.split(p, d, 1)
        return w*(s(p, 1, sp[0])+s(p,next_w,sp[1][:l])+s(p,1,sp[1][l:]))
    else:
        return w*len(d)
            
print 'Part 2:', s(pattern, 1, input)
