input = open('day2-input.txt','r')

code = ''
for line in input:
    x = 0
    y = 0
    for move in [1 if c=='R' else -1 if c=='L' else 0 for c in line]:
        x = max(min(x+move, 2), 0)
    for move in [1 if c=='D' else -1 if c=='U' else 0 for c in line]:
        y = max(min(y+move, 2), 0)
    code += str(3*y+x+1)
print code
