import networkx
from itertools import permutations

inputPath = "d24_input.txt"

rows = []
for line in open (inputPath, "r"):
    row = line.strip()
    rows.append(row)

maxX = len(rows[0])
maxY = len(rows)
goals = dict()
distances = dict()
G = networkx.generators.classic.grid_2d_graph(maxY, maxX)

for y, row in enumerate(rows):
    for x, pos in enumerate(row):
        if pos == "#":
            G.remove_node((y,x))
        if pos.isdigit():
            goals[int(pos)] = (y,x)

for y in range(8):
    for x in range(8):
        distances[y,x] = networkx.shortest_path_length(G, goals[y], goals[x])
        distances[x,y] = distances[y,x]

shortest = -1
for path in permutations(range(1,8)):
    l = [0] + list(path)
    pathDist = 0
    for i in range(len(l)-1):
        pathDist += distances[l[i+1], l[i]]
    if shortest > 0:
        shortest = min(pathDist, shortest)
    else:
        shortest = pathDist

print "Part one: " + str(shortest)

shortest = -1
for path in permutations(range(1,8)):
    l = [0] + list(path) + [0]
    pathDist = 0
    for i in range(len(l)-1):
        pathDist += distances[l[i+1], l[i]]
    if shortest > 0:
        shortest = min(pathDist, shortest)
    else:
        shortest = pathDist

print "Part two: " + str(shortest)