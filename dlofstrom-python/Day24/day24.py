import itertools
import math

input = open('day24-input.txt','r')
input = [i.strip('\n') for i in input]

#input = ['###########','#0.1.....2#','#.#######.#','#4.......3#','###########']

def pretty_print(m,p):
    for y,l in enumerate(m):
        line = ''
        for x,c in enumerate(l):
            if (x,y) in p:
                line += 'x'
            else:
                line += c
        print line
    print '\n\n'


def get_next(m,p,q):
    f = p[-1]
    n = []
    for x,y in [(f[0]+1,f[1]),(f[0]-1,f[1]),(f[0],f[1]+1),(f[0],f[1]-1)]:
        if m[y][x] == '#':
            #print x,y,'is a wall'
            pass
        elif (x,y) in p:
            #print x,y,'in path'
            pass
        elif (len(p)+1,x,y) in [(len(Q),Q[-1][0],Q[-1][1]) for l,Q in q]:
            #print len(p),x,y,'already in queue'
            pass
        else:
            #print (len(p)+1,x,y), [(len(Q),Q[-1][0],Q[-1][1]) for l,Q in q]
            n.append((x,y))
    return n
            

#A* search
def find_shortest_path(a,b):
    queue = [[(x,y) for x,c in enumerate(l) if c == a] for y,l in enumerate(input) if a in l]
    queue = [[0, queue[0]]]
    #print queue
    xg,yg = [[(x,y) for x,c in enumerate(l) if c == b] for y,l in enumerate(input) if b in l][0][0]
    #print xg,yg
    while queue:
        #Pop path from queue
        l,p = queue.pop(0)
        #print p[-1],l
        #print p, queue
        #Check if any digit found
        x,y = p[-1][0],p[-1][1]
        c = input[y][x]
        if c == b:
            print a,b,'found',c
            pretty_print(input, p)
            break
            
        #Get next nodes
        for n in get_next(input, p, queue):
            queue.append([len(p)+1+math.sqrt((xg-n[1])**2+(yg-n[0])**2),list(p)+[n]])
            queue.sort()

        #print a,b
        #print len(queue)
        #pretty_print(input, p)
        #print len(queue)
        #raw_input()
    return p



digits = [c for l in input for c in l if c.isdigit()]
combinations = list(itertools.combinations(digits, 2))
shortest_paths = {}

#Find shortest path from every to every digit
for a,b in combinations:
    #shortest_paths.append(list(find_shortest_path(a,b)))
    #pretty_print(input, shortest_paths[-1])
    l = len(list(find_shortest_path(a,b)))-1
    shortest_paths[(a,b)] = l
    shortest_paths[(b,a)] = l

#Compare lengths
permutations = [['0']+list(l)+['0'] for l in itertools.permutations([d for d in digits if d != '0'])]

print 'Part 1:', min([sum([shortest_paths[(p[i],p[i+1])] for i in range(len(p)-2)]) for p in permutations])
print 'Part 2:', min([sum([shortest_paths[(p[i],p[i+1])] for i in range(len(p)-1)]) for p in permutations])
