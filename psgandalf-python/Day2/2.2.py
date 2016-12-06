# Advent of code 2016 from http://adventofcode.com/2016
# Day 2 part 2

valid_moves = {1:'D', 2:'DR', 3:'UDRL', 4:'LD', 5:'R', 6:'UDRL', 7:'UDRL', 8:'UDRL', 9:'L', 'A':'UR', 'B':'UDRL', 'C':'UL', 'D':'U'}
keypad = {(2,4) : 1, (1,3) : 2, (2,3) : 3, (3,3) : 4, (0,2) : 5, (1,2) : 6, (2,2) : 7, (3,2) : 8, (4,2) : 9, (1,1):'A', (2,1):'B',(3,1):'C',(2,0):'D'}
dir = {'U' : (0,1), 'D' : (0,-1), 'R' : (1,0), 'L' : (-1,0)}
pos = (0,2)
testpos = [0,2]
answ = ""
file = open('2.1_input.txt', 'r')
for line in file:
    line = line.rstrip()
    for direction in line:
        if direction in valid_moves[keypad[pos]]:
            testpos[0] += dir[direction][0]
            testpos[1] += dir[direction][1]
            pos = tuple(testpos)
    answ += str(keypad[pos])
print answ