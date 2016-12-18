import array

src = "d18_input.txt"

def nextRow(row):
    nRow = []
    nRow.append(True == row[1])
    for i in range(1, (len(row) - 1)):
        nRow.append(row[i-1] == row[i+1])
    nRow.append(row[-2] == True)
    return nRow

def toBools(s):
    b = []
    for c in s:
        b.append(c == ".")
    return b

def numOfSafe(fstRow, numOfRows):
    currentRow = fstRow
    safeCount = 0
    for i in range(numOfRows):
        safeCount += sum(currentRow)
        currentRow = nextRow(currentRow)
    return safeCount

with open (src, "r") as inputfile:
    input = inputfile.read().strip()

fstRow = toBools(input)
print "Part one: " + str(numOfSafe(fstRow, 40))
print "Part two: " + str(numOfSafe(fstRow, 400000))