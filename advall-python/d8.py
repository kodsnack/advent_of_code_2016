screen = [[False for x in range(50)] for y in range(6)]

def printScreen():
    for row in screen:
        rowStr = ""
        for pixel in row:
            if pixel:
                rowStr += '#'
            else:
                rowStr += '.'
        print rowStr

def rect(a,b):
    for y in range(b):
        for x in range(a):
            screen[y][x] = True

def rotateRow(a,b):
    screen[a] = screen[a][(-b):(len(screen[a]))] + screen[a][0:(-b)]

def rotateColumn(a,b):
    column = []
    for row in screen:
        column.append(row[a])
    column = column[(-b):(len(column))] + column[0:(-b)]
    for i, row in enumerate(screen):
        row[a] = column[i]

def operate(s):
    if s[0:5] == "rect ":
        args = s[5:len(s)].split('x')
        rect(int(args[0]), int(args[1]))
    elif s[0:13] == "rotate row y=":
        args = s[13:len(s)].split(" by ")
        rotateRow(int(args[0]), int(args[1]))
    elif s[0:16] == "rotate column x=":
        args = s[16:len(s)].split(" by ")
        rotateColumn(int(args[0]), int(args[1]))
    else:
        print "UNKNOWN INSTRUCTION: " + s


def getVoltage():
    noOfLit = 0
    for row in screen:
        noOfLit += sum(row)
    return noOfLit

for line in open ("d8_input.txt", "r"):
    s = line.rstrip()
    operate(s)

printScreen()
partTwoAnswer = raw_input("Type the letters you see on the tiny screen above: ")
print "Part one: " + str(getVoltage())
print "Part two: " + partTwoAnswer
