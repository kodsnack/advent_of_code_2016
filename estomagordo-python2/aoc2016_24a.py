from heapq import heappush, heappop
from itertools import permutations

f = open('input_24.txt', 'r')

superbig = 100000000
numbers = [[] for x in xrange(8)]
grid = []
line_count = 0
for line in f:
    for x in xrange(len(line)):
        c = line[x]
        if c.isdigit():
            num = int(c)
            numbers[num] = [(line_count, x), {}]
    grid.append(line.rstrip())
    line_count += 1

height = line_count
width = x+1

def get_neighbours(pos):
    y,x = pos
    neighbours = []
    if x > 0 and not grid[y][x-1] == '#':
        neighbours.append((y,x-1))
    if x < width-1 and not grid[y][x+1] == '#':
        neighbours.append((y,x+1))
    if y > 0 and not grid[y-1][x] == '#':
        neighbours.append((y-1,x))
    if y < height-1 and not grid[y+1][x] == '#':
        neighbours.append((y+1,x))
    return neighbours

for i in xrange(7):
    seen = set()
    frontier = [[0,numbers[i][0]]]
    while True:
        steps, pos = heappop(frontier)
        if pos in seen:
            continue
        seen.add(pos)

        for j in xrange(i+1,8):
            if numbers[j][0] == pos:
                numbers[i][1][j] = steps
                numbers[j][1][i] = steps
                
        if len(numbers[i][1]) == 7:
            break

        steps += 1
        
        for neighbour in get_neighbours(pos):
            heappush(frontier, [steps, neighbour])

def score(path):
    return sum(numbers[path[x]][1][path[x+1]] for x in xrange(7))

best = superbig
for p in permutations(xrange(8)):
    if p[0] == 0:
        best = min(best, score(p))

print best