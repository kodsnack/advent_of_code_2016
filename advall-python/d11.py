import copy
import itertools

test = False
part2 = False # This one gets changed in runtime after step1 is solved.

if test:
    inputFileSrc = "d11_testinput.txt"
else:
    inputFileSrc = "d11_input.txt"

allConsideredStates = set()

def parseInput():
    state = (0, []) # =: (elevatorposition, list of pairs (generator, chip))
    with open (inputFileSrc, "r") as inputfile:
        input = inputfile.read()
    objects = []
    subStrs = input.split(" a ")
    for s in subStrs:
        if (s[0:3] != "The") and (not "-" in s):
            element = s.split(" ")[0]
            elemPair = ((element + " generator"), (element + "-compatible microchip"))
            objects.append(elemPair)

    input = input.split('\n')
    for (g,m) in objects:
        for floor, line in enumerate(input):
            if g in line:
                gPos = floor
            if m in line:
                mPos = floor
        state[1].append((gPos, mPos))
    return state

def finalState(state):
    goalstate = ([(3,3)] * len(state[1]))
    return state[1] == goalstate

def allMoves(state):
    nextStates = []
    e = state[0]
    gensOnThisFloor = []
    chipsOnThisFloor = []
    if e < 3:
        # Elevator can go up
        for index, (g,m) in enumerate(state[1]):
            if g == e:
                gensOnThisFloor.append(index)
            if m == e:
                chipsOnThisFloor.append(index)
            if  (g == e) and (m == e): 
                nextState = copy.deepcopy(state)
                nextState = ((e + 1), nextState[1])
                nextState[1][index] = ((g + 1), (m + 1))
                nextStates.append(nextState)
            if g == e:
                nextState = copy.deepcopy(state)
                nextState = ((e + 1), nextState[1])
                nextState[1][index] = ((g + 1), m)
                nextStates.append(nextState)
            if m == e:
                nextState = copy.deepcopy(state)
                nextState = ((e + 1), nextState[1])
                nextState[1][index] = (g, (m + 1))
                nextStates.append(nextState)
        for i, lst in enumerate([gensOnThisFloor, chipsOnThisFloor]):
            if len(lst) > 1:
                combs = itertools.combinations(lst, 2)
                for comb in combs:
                    nextState = copy.deepcopy(state)
                    nextState = ((e + 1), nextState[1])
                    comb1 = nextState[1][comb[0]]
                    comb1lst = list(comb1)
                    comb1lst[i] = comb1lst[i] + 1
                    comb1 = tuple(comb1lst)
                    comb2 = nextState[1][comb[1]]
                    comb2lst = list(comb2)
                    comb2lst[i] = comb2lst[i] + 1
                    comb2 = tuple(comb2lst)
                    nextState[1][comb[0]] = comb1
                    nextState[1][comb[1]] = comb2
                    nextStates.append(nextState)
    if e > 0:
        # Elevator can go down
        for index, (g,m) in enumerate(state[1]):
            if  (g == e) and (m == e): 
                nextState = copy.deepcopy(state)
                nextState = ((e - 1), nextState[1])
                nextState[1][index] = ((g - 1), (m - 1))
                nextStates.append(nextState)
            if g == e:
                nextState = copy.deepcopy(state)
                nextState = ((e - 1), nextState[1])
                nextState[1][index] = ((g - 1), m)
                nextStates.append(nextState)
            if m == e:
                nextState = copy.deepcopy(state)
                nextState = ((e - 1), nextState[1])
                nextState[1][index] = (g, (m - 1))
                nextStates.append(nextState)
        for i, lst in enumerate([gensOnThisFloor, chipsOnThisFloor]):
            if len(lst) > 1:
                combs = itertools.combinations(lst, 2)
                for comb in combs:
                    nextState = copy.deepcopy(state)
                    nextState = ((e - 1), nextState[1])
                    comb1 = nextState[1][comb[0]]
                    comb1lst = list(comb1)
                    comb1lst[i] = comb1lst[i] - 1
                    comb1 = tuple(comb1lst)
                    comb2 = nextState[1][comb[1]]
                    comb2lst = list(comb2)
                    comb2lst[i] = comb2lst[i] - 1
                    comb2 = tuple(comb2lst)
                    nextState[1][comb[0]] = comb1
                    nextState[1][comb[1]] = comb2
                    nextStates.append(nextState)

    return nextStates

def genInFloor(floor, state):
    for (g,m) in state[1]:
        if g == floor:
            return True
    return False
            
def validState(state):
    if not finalState(state):
        for (g,m) in state[1]:
            if g != m:
                if genInFloor(m, state):
                    return False # m is fried
    return True # no chip was fried

def solveStep(states):
    candidates = []
    for s in states:
        if finalState(s):
            return (True, states)
        else:
            candidates = candidates + allMoves(s)
    nextStates = []
    for (e, lst) in candidates:
        if validState((e, lst)):
            lst.sort()
            positions = tuple(lst)
            if (e, positions) not in allConsideredStates:
                nextStates.append((e, lst))
                allConsideredStates.add((e, positions))
    return (False, nextStates)

def solve():
    notSolved = True
    stepStates = []
    input = parseInput()
    firstState = input
    if part2:
        firstState[1].append((0, 0))
        firstState[1].append((0, 0))
    stepStates.append(firstState)
    i = 0
    while notSolved:
        if i > 1000:
             print "Aborted! Not solvable in 1000 steps. Something is wrong!"
             break
        #print "Not solvable in " + str(i) + " steps. Now considering " + str(len(stepStates)) + " states."
        candidate = solveStep(stepStates)
        if candidate[0]:
            notSolved = False
        else:
            stepStates = candidate[1]
        i += 1
    return i - 1 # not sure why -1 is needed, but it certainly is.

print "Part one: " + str(solve())
if not test:
    part2 = True
    allConsideredStates = set()
    print "Part two: " + str(solve())


