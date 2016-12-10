numOfTriangles = 0
lst = []

def isTriangle(s1, s2, s3):
    return ((s1 + s2) > s3) and ((s1 + s3) > s2) and ((s2 + s3) > s1)


for line in open ("d3_input.txt", "r"):
    s = line.rstrip()
    t = [int(i) for i in s.split()]
    lst.append(t)
    if isTriangle(t[0], t[1], t[2]):
        numOfTriangles += 1

print "Part one: " + str(numOfTriangles)

numOfTriangles = 0

for i in xrange(0, len(lst), 3):
    for j in range(3):
        if isTriangle(lst[i][j], lst[i+1][j], lst[i+2][j]):
            numOfTriangles += 1

print "Part two: " + str(numOfTriangles)