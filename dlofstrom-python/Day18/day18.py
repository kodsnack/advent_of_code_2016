input = open('day18-input.txt','r')
input = [r.strip('\n') for r in input]

for i in range(40-1):
    row = '.'+input[-1]+'.'
    row = [row[i:i+3] for i in range(len(row)-2)]
    input.append(''.join(['^' if t in ['^..','..^','^^.','.^^'] else '.' for t in row]))
    
print 'Part 1:', ''.join(input).count('.')

