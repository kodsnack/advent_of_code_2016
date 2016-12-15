class Direction:

    def __init__(self, direction, length):
        self.direction = direction
        self.length = int(length)
    def __str__(self, arg):
        return self.direction + str(self.length)

class Grid:

    def __init__(self):
        self.__posX = 0
        self.__posY = 0
        self.__direction = 0
        self.__visited = []
        self.firstLoop = ""

    def __step(self, x, y, length):
        for step in range(length):
            self.__posX += x
            self.__posY += y
            if [self.__posX, self.__posY] in self.__visited:
                if self.firstLoop == "":
                    self.firstLoop = self.getDistanceWalked()
            else:
                self.__visited.append([self.__posX, self.__posY])
    def walk(self, direction):
        if direction.direction == 'R':
            self.__direction += 1
            if self.__direction > 3:
                self.__direction = 0
        else:
            self.__direction -= 1
            if self.__direction < 0:
                self.__direction = 3
        if self.__direction == 0:
            self.__step(0,1,direction.length)
        elif self.__direction == 1:
            self.__step(1,0,direction.length)
        elif self.__direction == 2:
            self.__step(0,-1,direction.length)
        elif self.__direction == 3:
            self.__step(-1,0,direction.length)

    def getDistanceWalked(self):
        return abs(self.__posX) + abs(self.__posY)

def fileRead(inFile):

    fileData = ""
    try:
        inFile = open(inFile)
        for line in inFile:
            fileData += line
        fileData = fileData.split()
        directions = []
        for instruction in fileData:
            instruction = instruction.strip(',')
            direction = Direction(instruction[0],instruction[1:])
            directions.append(direction)
        return directions
    except Exception as e:
        raise e

def walkTheWalk(directions, grid):

    for direction in directions:
        grid.walk(direction)
    return grid

def main():

    grid = Grid()
    directions = fileRead('input.txt')
    grid = walkTheWalk(directions, grid)
    print(grid.firstLoop)
    print(grid.getDistanceWalked())

if __name__ == '__main__':

    main()
