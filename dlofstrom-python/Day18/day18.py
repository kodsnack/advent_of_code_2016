input = open('day18-input.txt','r')
input = input.read().strip('\n')

def count_safe_tiles(row1, n):
    rows = [row1]
    for i in range(n-1):
        row = '.'+rows[-1]+'.'
        row = [row[i:i+3] for i in range(len(row)-2)]
        rows.append(''.join(['^' if t in ['^..','..^','^^.','.^^'] else '.' for t in row]))
    return ''.join(rows).count('.')
    
print 'Part 1:', count_safe_tiles(input,40)
print 'Part 2:', count_safe_tiles(input,400000)

