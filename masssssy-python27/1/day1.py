class Direction(object):
  	north = 1
   	west = 2
   	east= 3
   	south = 4
 

def main():
    currentPos = (0,0)
    currentDir = Direction.north
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()
    instructions = []
    visited = dict()
    
    splitdata = inputdata.split(", ")

    for command in splitdata:
        if command[0] == "L": 
            distance = command.replace("L", "")
            instructions.append(("L", distance))
        else:
            distance = command.replace("R", "")
            instructions.append(("R", distance))

    #print instructions
    #List of instructions now exist
    for step in instructions:
        turnDir = step[0]
        if turnDir == "L":
            if currentDir == Direction.north:
                currentDir = Direction.west
            elif currentDir == Direction.west:
                currentDir = Direction.south
            elif currentDir == Direction.east:
                currentDir = Direction.north
            elif currentDir == Direction.south:
                currentDir = Direction.east

        elif turnDir == "R":
            if currentDir == Direction.north:
                currentDir = Direction.east
            elif currentDir == Direction.west:
                currentDir = Direction.north
            elif currentDir == Direction.east:
                currentDir = Direction.south
            elif currentDir == Direction.south:
                currentDir = Direction.west

        #NOW WALK!
        oldPos = currentPos
        if currentDir == Direction.north:
            for x in range(0, int(step[1])):
                if (currentPos[0], currentPos[1]+x) in visited:
                    print (currentPos[0], currentPos[1]+x)
                else:
                    visited[(currentPos[0], currentPos[1]+x)] = True
            currentPos = (currentPos[0], currentPos[1]+int(step[1]))

            
        if currentDir == Direction.west:
            for x in range(0, int(step[1])):
                if (currentPos[0]-x, currentPos[1]) in visited:
                    print (currentPos[0]-x, currentPos[1])
                else:
                    visited[(currentPos[0]-x, currentPos[1])] = True
            currentPos = (currentPos[0]-int(step[1]), currentPos[1])

        if currentDir == Direction.east:
            for x in range(0, int(step[1])):
                if (currentPos[0]+x, currentPos[1]) in visited:
                    print (currentPos[0]+x, currentPos[1])
                else:
                    visited[(currentPos[0]+x, currentPos[1])] = True
            currentPos = (currentPos[0]+int(step[1]), currentPos[1])

        if currentDir == Direction.south:
            for x in range(0, int(step[1])):
                if (currentPos[0], currentPos[1]-x) in visited:
                    print (currentPos[0], currentPos[1]-x)
                else:
                    visited[(currentPos[0], currentPos[1]-x)] = True
            currentPos = (currentPos[0], currentPos[1]-int(step[1]))

        #print visited


    print abs(currentPos[0]) + abs(currentPos[1])


if __name__ == "__main__":
    main()