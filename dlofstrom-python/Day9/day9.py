import re

input = open('day9-input.txt','r').read().strip(' \r\n')

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
