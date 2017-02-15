input = 1364

def next(x, y):
    global input
    n = [(x+i,y+j) for i,j in [(1,0),(-1,0),(0,1),(0,-1)] if x+i>=0 and y+j>=0]
    n = [p for p in n if bin(p[0]*p[0]+3*p[0]+2*p[0]*p[1]+p[1]+p[1]*p[1]+input).count('1')%2 == 0]
    #print n
    return n
    
def breadth_first(x_goal, y_goal):
    #(x,y) steps
    queue = [((1,1),0)]
    visited = []

    while True:
        q = queue.pop(0)
        #print q
        if q not in visited:
            visited.append(q[0])
            if q[0][0]==x_goal and q[0][1]==y_goal:
                return q[1]
            for n in next(q[0][0],q[0][1]):
                if not n in visited:
                    queue.append((n,q[1]+1))
                    
        if not queue:
            return -1

print 'Part 1:', breadth_first(31,39)
