import copy
from collections import deque

inputPath = "d22_input.txt"

def parseInput(path):
    with open (path, "r") as inputfile:
        input = inputfile.readlines()
    grid = []
    for line in input[2:]:
        words = line.split()
        size = int(words[1][0:-1])
        used = int(words[2][0:-1])
        pos = words[0]
        pos = pos.split("-")
        x = int(pos[1][1:])
        y = int(pos[2][1:])
        l = ["."]
        if (x == 0) and (y == 0):
            sizeOfVisible = size
        elif used > sizeOfVisible:
            l = ["#"]
        elif used == 0:
            l = ["_"]
            blankPos = (x,y)
        if (x == 0):
            grid.append([])
        grid[y] = grid[y] + l
    grid[0][-1] = "G"
    return (grid, blankPos)

startState = parseInput(inputPath)
grid = startState[0]
bP = startState[1]
steps = 0

def printGrid():
    for row in grid:
        print "".join(row)
    print "Step count : " + str(steps)

def mv(dx, dy):
    bX = bP[0]
    bY = bP[1]
    destVal = grid[bY+dy][bX+dx]
    if destVal != "#":
        grid[bY][bX] = destVal
        grid[bY+dy][bX+dx] = "_"
        return True
    else:
        return False

def viablePairs():
    count = 0
    for row in grid:
        for c in row:
            if (c == ".") or (c == "G"):
                count += 1
    return count

answer1 = viablePairs()
print "Part one: " + str(answer1)

while grid[0][0] != "G":
    printGrid()
    ms = raw_input("Your move (use [wasd])(you may enter multiple chars before pressing enter): ")
    for m in ms:
        if m == "w":
            if mv(0, -1):
                bP = (bP[0], (bP[1] - 1))
                steps += 1
        elif m == "a":
            if mv(-1, 0):
                bP = ((bP[0] - 1), bP[1])
                steps += 1
        elif m == "s":
            if mv(0, 1):
                bP = (bP[0], (bP[1] + 1))
                steps += 1
        elif m == "d":
            if mv(1, 0):
                bP = ((bP[0] + 1), bP[1])
                steps += 1
print "You solved Part two in " + str(steps) + " steps!"
print "Part one: " + str(answer1)