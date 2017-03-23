import re
import math

input = open('day22-input.txt','r')
input = ''.join([i for i in input])
input = re.findall('(?<=/dev/grid/node-x)[0-9]{1,}-y[0-9]{1,}\s{1,}[0-9]{1,}T\s{1,}[0-9]{1,}',input)
input = [[int(j) for j in re.split('-y|\s{1,}|T\s{1,}',i)] for i in input if i]

def viable_pair(A, B):
    if A != B and A[3] != 0 and A[3] <= B[2] - B[3]:
        #print A, B
        return True
    else:
        return False

#Part 1
viable_pairs = 0
for A in input:
    for B in input:
        if viable_pair(A, B):
            viable_pairs += 1

print 'Part 1:', viable_pairs

#Printing viable pairs shows that the only viable nodes involve moving to an empty node
#There are also the large nodes which wont move, these must be identified and marked as permanent
#Other than that it is basically a sliding tile puzzle

def data_would_fit(A,B):
    return A[3] <= B[2]

def pretty_print(ta,tile):
    for y,r in enumerate(ta):
        if tile:
            for x,t in enumerate(r):
                if (x,y) == tile:
                    print 'x',
                else:
                    print t,
            print ''
        else:
            print ' '.join(r)

#Part 2
#Sort data in tile array
#Mark large nodes and empty node
tile_array = []
for A in input:
    if A[1] == 0:
        tile_array.append([])
    permanent_tile = False
    for B in input:
        if not data_would_fit(A, B):
            #print A, B
            permanent_tile = True
    if permanent_tile:
        tile_array[-1].append('#')
    elif A[3] == 0:
        tile_array[-1].append(' ')
    else:
        tile_array[-1].append('O')
tile_array[0][0] = 'G'
tile_array[-1][0] = 'S'

#Visualize tiles
#pretty_print(tile_array, ())

#Two steps
#1. Move hole to tile above S tile
#2. Move S tile to G tile

def get_next_steps(ta,tile,q,v):
    next_steps = []
    for p in [(tile[0]+1,tile[1]),(tile[0]-1,tile[1]),(tile[0],tile[1]+1),(tile[0],tile[1]-1)]:
        #print p, v, [t for l,t in q]
        if p[0] < 0 or p[0] >= len(ta[0]) or p[1] < 0 or p[1] >= len(ta):
            #Out of bounds
            #print p, 'out of bounds'
            pass
        elif p in v:
            #Already visited
            #print p, 'already visited'
            pass
        elif p in [t for l,y in q]:
            #Already visited
            #print p, 'in queue'
            pass
        elif ta[p[1]][p[0]] == '#':
            #Wall
            #print p, 'is a wall'
            pass
        else:
            next_steps.append(p)
    return next_steps
        
#BFS search path to S tile
#Queue with starting position (hole)
queue = [[(x,y) for x,t in enumerate(r) if t == ' '] for y,r in enumerate(tile_array) if ' ' in r]
queue = [(0,queue[0][0])]
visited = []
#print queue
goal = (0,len(tile_array)-2)
counter = 0
while queue:
    current_length, current_tile = queue.pop(0)
    if not current_tile in visited:
        #pretty_print(tile_array, current_tile)
        if current_tile == goal:
            break
        else:
            visited.append(current_tile)
            for t in get_next_steps(tile_array, current_tile, queue, visited):
                queue.append((current_length+1,t))
        #print queue
        #raw_input()

#Then its a matter of moving the S tile to the hole (1 step) and moving the hole to the front again and repeat (4 steps)
print 'Part 2:', current_length+1+5*(len(tile_array)-2)









    
