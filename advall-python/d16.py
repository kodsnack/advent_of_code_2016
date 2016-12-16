from itertools import izip

def same(pair):
    return pair[0] == pair[1]

def pairwise(l):
    il = iter(l)
    return izip(il,il)

def toBools(s):
    b = []
    for c in s:
        b.append(c == "1")
    return b

def fromBools(b):
    s = []
    for i in b:
        if i:
            s.append("1")
        else:
            s.append("0")
    return "".join(s)

def generateData(s, diskSpace):
    a = toBools(s)
    while len(a) < diskSpace:
        b = a[::-1]
        invB = [not i for i in b]
        a.append(False)
        a.extend(invB)
    return a

def computeChecksum(a, diskSpace):
    s = a[0:diskSpace]
    while (len(s) % 2) == 0:
        pairs = pairwise(s)
        s = map(same, pairs)
    return s

def makeCheckSum(s, diskSpace):
    a = generateData(s, diskSpace)
    return fromBools(computeChecksum(a, diskSpace))

with open ("d16_input.txt", "r") as inputfile:
    input = inputfile.read()

print "Part one: " + makeCheckSum(input, 272)
print "Part two: " + makeCheckSum(input, 35651584)