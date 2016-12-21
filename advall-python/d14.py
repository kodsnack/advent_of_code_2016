import hashlib

def parseInput(src):
    with open (src, "r") as inputfile:
        input = inputfile.read()
    return input

def computeHash(salt, index):
    g = hashlib.md5()
    g.update(salt + str(index))
    return g.hexdigest()

def computeStretchedHash(salt, index):
    h = computeHash(salt, index)
    for i in range(2016):
        g = hashlib.md5()
        g.update(h)
        h = g.hexdigest()
    return h

def findTriple(hash):
    for i, c in enumerate(hash[0:(len(hash) - 2)]):
        if (c == hash[i+1]) and (c == hash[i+2]):
            return c
    return "none"

def fivelingIn(fiveling, lst):
    for h in lst:
        if fiveling in h:
            return True
    return False

salt = parseInput("d14_input.txt")

hashes = [] # A queue would be faster, but hashing is the bottleneck anyway.
for i in range(1001):
    hashes.append(computeHash(salt, i))
keys = []
i = 0
while len(keys) < 64:
    h = hashes.pop(0)
    triple = findTriple(h)
    if triple != "none":
        fiveling = triple * 5
        if fivelingIn(fiveling, hashes):
            keys.append(h)
    i += 1
    hashes.append(computeHash(salt, (i + 1000)))
print "Part one: " + str(i - 1)

hashes = []
for i in range(1001):
    hashes.append(computeStretchedHash(salt, i))
keys = []
i = 0
while len(keys) < 64:
    h = hashes.pop(0)
    triple = findTriple(h)
    if triple != "none":
        fiveling = triple * 5
        if fivelingIn(fiveling, hashes):
            keys.append(h)
    i += 1
    hashes.append(computeStretchedHash(salt, (i + 1000)))
print "Part two: " + str(i - 1)