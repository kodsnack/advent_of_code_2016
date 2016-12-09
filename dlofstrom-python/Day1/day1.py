#Part 1
#Import data to list
input = open('day1-part1-input.txt','r').read()
input = input.strip(' \n').split(', ')

#Convert rotations to positive or negative turn
direction = [1 if x[0]=='L' else -1 for x in input]
#Convert to tuples with absolute orientation 0=north, 1=west... and number of steps
direction = [(sum(direction[0:i+1])%4, int(input[i][1:])) for i in range(len(direction))]

steps_ew = abs(sum([ew[1] if ew[0]==1 else -ew[1] if ew[0]==3 else 0 for ew in direction]))
steps_ns = abs(sum([ns[1] if ns[0]==0 else -ns[1] if ns[0]==2 else 0 for ns in direction]))

print 'Part 1:', steps_ew + steps_ns

#Part 2
coordinates = [(0,0)]
#Iterate over all steps and generate list of passed coorinates
for d in direction:
    #Generate positive or negative steps based on orientation
    r = range(1,d[1]+1) if (d[0] in [0,1]) else range(-d[1],0)[::-1]
    #Step in east/west or north/south and add to list
    if d[0] in [0,2]:
        coordinates += [(coordinates[-1][0],coordinates[-1][1]+x) for x in r]
    else:
        coordinates += [(coordinates[-1][0]+x,coordinates[-1][1]) for x in r] 

visited = {}
#Check if a coordinate have been visited
for c in coordinates:
    if c in visited:
        print 'Part 2:', sum(c)
        break
    else:
        visited[c] = 1
