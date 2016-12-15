# slot model: (int noOfPositions, int startPosition)

def openWhenReached(slotNum, slot, timeOfPush):
    posWhenReached = (slot[1] + slotNum + timeOfPush) % slot[0]
    return posWhenReached == 0

def allOpen(slots, timeOfPush):
    opens = []
    for i, slot in enumerate(slots):
        opens.append(openWhenReached((i+1), slot, timeOfPush))
    return all(opens)

def whenToPush(slots):
    i = 0
    while True:
        if allOpen(slots, i):
            return i
        i += 1

def parseInput(lines):
    slots = []
    for line in lines:
        words = line.split()
        noOfPos = int(words[3])
        atPos = int(words[-1][0:-1])
        slot = (noOfPos, atPos)
        slots.append(slot)
    return slots

with open ("d15_input.txt", "r") as inputfile:
    input = inputfile.readlines()

slots = parseInput(input)
print "Part one: " + str(whenToPush(slots))
slots.append((11,0))
print "Part two: " + str(whenToPush(slots))