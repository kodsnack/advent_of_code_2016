from collections import deque

fileSrc = "d13_input.txt"

def getLuckyNumber(src):
    with open (src, "r") as inputfile:
        input = inputfile.read()
    return int(input)

def isWall(x, y, luckyNumber):
    s = (x*x + 3*x + 2*x*y + y + y*y + luckyNumber)
    binS = "{0:b}".format(s)
    return ((binS.count("1")) % 2) == 1

def move(state, delta, luckyNumber):
    nX = state[1][0] + delta[0]
    nY = state[1][1] + delta[1]
    nMoves = state[0] + 1
    if (nX < 0) or (nY < 0) or isWall(nX, nY, luckyNumber):
        return []
    else:
        return[(nMoves, (nX, nY))]

def solve(luckyNumber, start, goal):
    states = deque()
    startState = (0, start)
    states.append(startState)
    visited = set()
    visited.add(startState)
    while len(states) > 0:
        state = states.popleft()
        if state[1] == goal:
            return state[0]
        nextStates = move(state, (1, 0), luckyNumber) + move(state, (0, -1), luckyNumber) + move(state, (-1, 0), luckyNumber) + move(state, (0, 1), luckyNumber)
        for s in nextStates:
            if s[1] not in visited:
                states.append(s)
                visited.add(s[1])
    print "Could not find the goal!"
    return -1

def solve2(luckyNumber, start):
    states = deque()
    startState = (0, start)
    states.append(startState)
    visited = set()
    visited.add(start)
    while (len(states) > 0):
        state = states.popleft()
        if state[0] == 50:
            break
        nextStates = move(state, (1, 0), luckyNumber) + move(state, (0, -1), luckyNumber) + move(state, (-1, 0), luckyNumber) + move(state, (0, 1), luckyNumber)
        for s in nextStates:
            if s[1] not in visited:
                states.append(s)
                visited.add(s[1])
    return len(visited)

print "Part one: " + str(solve(getLuckyNumber(fileSrc), (1, 1), (31,39)))
print "Part two: " + str(solve2(getLuckyNumber(fileSrc), (1, 1)))

