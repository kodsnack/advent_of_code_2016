input = open('day2-input.txt','r')
input = [l.strip('\n') for l in input]

#Part 1
code = ''
for line in input:
    x = 0
    y = 0
    #Handle x and y moves separately 
    for move in [1 if c=='R' else -1 if c=='L' else 0 for c in line]:
        x = max(min(x+move, 2), 0)
    for move in [1 if c=='D' else -1 if c=='U' else 0 for c in line]:
        y = max(min(y+move, 2), 0)
    #Add digit to code
    code += str(3*y+x+1)
print 'Part 1:', code

#Part 2
code = ''
lut = {(0,2):'1', (-1,1):'2', (0,1):'3', (1,1):'4', (-2,0):'5', (-1,0):'6', (0,0):'7', (1,0):'8', (2,0):'9', (-1,-1):'A', (0,-1):'B', (1,-1):'C', (0,-2):'D'}

for line in input:
    #Starting at 5, (0,0) in middle (positive is right and up))
    x = -2
    y = 0

    #List of moves in x and y
    for move in zip([1 if c=='R' else -1 if c=='L' else 0 for c in line],[-1 if c=='D' else 1 if c=='U' else 0 for c in line]):
        next = [sum(i) for i in zip([x,y],move)]
        (x,y) = next if sum([abs(n) for n in next])<=2 else (x,y)
    code += lut[(x,y)]
print 'Part 2:', code

