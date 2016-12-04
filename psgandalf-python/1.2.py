# Advent of code 2016 from http://adventofcode.com/2016
# Day 1 part 2

directions = ['N', 'W', 'S','E']
directionsright =['E', 'N', 'W', 'S']
directionsleft =['W', 'S', 'E', 'N']
movesright = [(1,0),(0,1),(-1,0),(0,-1)]
movesleft = [(-1,0),(0,-1),(1,0),(0,1)]
direction = directions[0]
position = [0,0]
pos = (0,0)
savedpos = []
savedpos.append(pos)
found = False
file = open('1.1_input.txt', 'r')
input = str(file.readline())
input = (input.split(', '))
for step in input:
    turn = step[0]
    steps = int(step[1:])
    if not found:
        if turn == 'R':
            for a in range(0,4):
                if direction == directions[a]:
                    for s in range(0, steps):
                        position[0] += movesright[a][0]
                        position[1] += movesright[a][1]
                        pos = position[0], position[1]
                        if pos in savedpos:
                            foundpos = pos
                            found = True
                        savedpos.append(pos)
                    direction = directionsright[a]
                    break
        elif turn == 'L':
            for a in range(0,4):
                if direction == directions[a]:
                    for s in range(0, steps):
                        position[0] += movesleft[a][0]
                        position[1] += movesleft[a][1]
                        pos = position[0], position[1]
                        if pos in savedpos:
                            foundpos = pos
                            found = True
                        savedpos.append(pos)
                    direction = directionsleft[a]
                    break
print abs(foundpos[0])+abs(foundpos[1])