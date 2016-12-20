input = open('day8-input.txt','r')

#Operations arranged in list with operation in first element and arguments in second
input = [r.strip('\r\n').split(' ',1) for r in input]

#Split arguments based on operation
input = [(o[0],o[1].split('x')) if o[0]=='rect' else (o[0],o[1].replace('=',' ').split(' ')) for o in input]

#Part 1
def shift(l, n):
    return l[-n:]+l[:-n]

screen = [['.' for e in range(50)] for r in range(6)]

#Go through every operation and apply to screen
for o in input:
    if o[0] == 'rect':
        #Fill every element in x,y rectangle from top left
        for x,y in [(i,j) for i in range(int(o[1][0])) for j in range(int(o[1][1]))]:
            screen[y][x] = '#'
    elif o[1][1] == 'y':
        #Shift row right
        screen[int(o[1][2])] = shift(screen[int(o[1][2])], int(o[1][4]))
    else:
        #Shift column down
        col = shift([r[int(o[1][2])] for r in screen], int(o[1][4]))
        for i,r in enumerate(screen):
            r[int(o[1][2])] = col[i]
        
print 'Part 1:', sum([1 if e=='#' else 0 for r in screen for e in r])

print 'Part 2:'
for r in screen:
    print ''.join(r)
