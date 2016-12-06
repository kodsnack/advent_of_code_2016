# Advent of code 2016 from http://adventofcode.com/2016
# Day 2 part 1

keypad = {(2,0) : 1, (2,1) : 2, (2,2) : 3, (1,0) : 4, (1,1) : 5, (1,2) : 6, (0,0) : 7, (0,1) : 8, (0,2) : 9}
dir = {'U' : (1,0), 'D' : (-1,0), 'R' : (0,1), 'L' : (0,-1)}
pos = (1,1)
testpos = [1,1]
answ = ''
file = open('2.1_input.txt', 'r')
for line in file:
    line = line.rstrip()
    for direction in line:
        testpos[0] = pos[0] + dir[direction][0]
        testpos[1] = pos[1] + dir[direction][1]
        if not (testpos[0] < 0 or testpos[0] > 2 or testpos[1] < 0 or testpos[1] > 2):
            pos = tuple(testpos)
    answ += str(keypad[pos])
print answ