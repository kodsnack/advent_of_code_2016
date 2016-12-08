import re

def calcDistance(instructionString):

    # Set starting state for distance calculation
    currentDir    = 0 # 0-north, 1-east, 2-south, 3-west
    xPos          = 0
    yPos          = 0
    visitedPoints = [(0,0)]
    distToHq      = float('nan') # HQ not found

    # Loop through and carry out all instructions
    instructionList = re.findall('(R|L)(\d+)', instructionString)
    hqFound = False
    for instruction in instructionList:

        # Update current direction
        rotation = instruction[0]
        if rotation == 'R':
            currentDir = (currentDir + 1) % 4
        elif rotation == 'L':
            currentDir = (currentDir - 1) % 4

        # Update position each step
        nSteps = int(instruction[1])
        for step in range(0, nSteps):
            if currentDir == 0: # North
                yPos += 1
            elif currentDir == 1: # East
                xPos += 1
            elif currentDir == 2: # South
                yPos -= 1
            elif currentDir == 3: # West
                xPos -= 1

            # Check if we have been here before and therefor found the HQ!
            if((xPos, yPos) in visitedPoints) and not hqFound:
                distToHq = abs(xPos) + abs(yPos)
                hqFound  = True
            else:
                visitedPoints.append((xPos, yPos))

    # Total distance is sum of absolute horizontal and vertical distances
    return {'total': abs(xPos) + abs(yPos), 'toHq': distToHq}

if __name__ == '__main__':
    with open('Day1-input.txt') as f:
        instructions = f.read()
    distance = calcDistance(instructions)
    print('Distance: %d' % distance['total'])
    print('Distance to HQ: %d' % distance['toHq'])
