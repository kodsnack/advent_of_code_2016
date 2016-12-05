# Advent of code 2016 from http://adventofcode.com/2016
# Day 1 part 1

direction = 'N'
position = [0,0]
file = open('1.1_input.txt', 'r')
input = str(file.readline())
input = (input.split(', '))
for step in input:
    turn = step[0]
    steps = int(step[1:])
    if turn == 'R':
        if direction == 'N':
            position[0] += steps
            direction = 'E'
        elif direction == 'W':
            position[1] += steps
            direction = 'N'
        elif direction == 'S':
            position[0] -= steps
            direction = 'W'
        elif direction == 'E':
            position[1] -= steps
            direction = 'S'
    elif turn == 'L':
        if direction == 'N':
            position[0] -= steps
            direction = 'W'
        elif direction == 'W':
            position[1] -= steps
            direction = 'S'
        elif direction == 'S':
            position[0] += steps
            direction = 'E'
        elif direction == 'E':
            position[1] += steps
            direction = 'N'
print abs(position[0])+abs(position[1])
