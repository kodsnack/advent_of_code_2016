padOne = [[1,2,3],[4,5,6],[7,8,9]]
padTwo = [[0,0,1,0,0], [0,2,3,4,0], [5,6,7,8,9], [0, 'A', 'B', 'C', 0], [0, 0, 'D', 0, 0]]
codeOne = ""
codeTwo = ""

x1 = 1
y1 = 1
x2 = 0
y2 = 2

for line in open ("d2_input.txt", "r"):
    s = line.rstrip()
    for instr in s:

        if instr == 'U':
            if y1 > 0:
                y1 = y1 - 1
            if y2 > 0:
                if padTwo[(y2 - 1)][x2] > 0:
                    y2 = y2 - 1
                
        elif instr == 'R':
            if x1 < 2:
                x1 = x1 + 1
            if (x2 < 4) and (padTwo[y2][(x2 + 1)] > 0):
                x2 = x2 + 1

        elif instr == 'D':
            if y1 < 2:
                y1 = y1 + 1
            if y2 < 4:
                if padTwo[(y2 + 1)][x2] > 0:
                    y2 = y2 + 1

        elif instr == 'L':
            if x1 > 0:
                x1 = x1 - 1
            if (x2 > 0) and (padTwo[y2][(x2 - 1)] > 0):
                x2 = x2 - 1

    codeOne = codeOne + str(padOne[y1][x1])
    codeTwo = codeTwo + str(padTwo[y2][x2])

print "Part one: " + codeOne
print "Part two: " + codeTwo