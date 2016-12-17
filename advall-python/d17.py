from collections import deque
import hashlib

fileSrc = "d17_input.txt"
goodChars = set(["b", "c", "d", "e", "f"])

def getPasscode(src):
    with open (src, "r") as inputfile:
        input = inputfile.read()
    return input

def getOpenDoors(x, y, path, passcode):
    g = hashlib.md5()
    g.update(passcode + path)
    s = str(g.hexdigest())[0:4]
    dirs = []
    if (s[0] in goodChars) and (y > 0):
        dir = (x, (y - 1), (path + "U"))
        dirs.append(dir)
    if (s[1] in goodChars) and (y < 3):
        dir = (x, (y + 1), (path + "D"))
        dirs.append(dir)
    if (s[2] in goodChars) and (x > 0):
        dir = ((x - 1), y, (path + "L"))
        dirs.append(dir)
    if (s[3] in goodChars) and (x < 3):
        dir = ((x + 1), y, (path + "R"))
        dirs.append(dir)
    return dirs

def solve(passcode):
    states = deque()
    startState = (0, 0, "")
    states.append(startState)
    goal = (3,3)
    goodPaths = []
    while len(states) > 0:
        state = states.popleft()
        if (state[0], state[1]) == goal:
            goodPaths.append(state[2])
        else:
            nextStates = getOpenDoors(state[0], state[1], state[2], passcode)
            states.extend(nextStates)
    shortest = min(goodPaths, key=len)
    longest = max(goodPaths, key=len)
    return (shortest, longest)

solutions = solve(getPasscode(fileSrc))
print "Part one: " + solutions[0]
print "Part two: " + str(len(solutions[1]))
