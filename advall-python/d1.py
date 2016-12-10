with open ("d1_input.txt", "r") as inputfile:
    input = inputfile.read().split(", ")

x = 0
y = 0
direction = 0

visited = []
foundFstRevisited = False

for instr in input:
    if instr[0] == 'R':
        direction = (direction + 1) % 4
    elif instr[0] == 'L':
        direction = (direction - 1) % 4

    distance = int(instr[1:(len(instr))])

    for i in range(distance):
        if direction == 0:
            y = y + 1
        elif direction == 1:
            x = x + 1
        elif direction == 2:
            y = y - 1
        elif direction == 3:
            x = x - 1
        if ((x,y) in visited) and not foundFstRevisited:
            print "Part two: " + str(abs(x) + abs(y))
            foundFstRevisited = True
        else:
            visited.append((x,y))

dist = abs(x) + abs(y)
print "Part one: " + str(dist)