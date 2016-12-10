def isReal(letters, idNum, checksum):
    lst = []
    for c in letters:
        lst.append((letters.count(c), c))
    lst = list(set(lst))
    lst.sort(key=lambda tup: tup[1])
    lst.sort(key=lambda tup: tup[0], reverse=True)
    candidate = []
    for i in range(0, 5):
        candidate.append(lst[i][1])

    returnID = 0
    if "".join(candidate) == checksum:
        returnID = idNum

    return returnID

def decrypt(s, idNum):
    decrypted = ""
    for w in s:
        for c in w:
            decrypted = decrypted + myShift(c, idNum)
        decrypted = decrypted + " "
    return decrypted[:-1]

def myShift(c, idNum):
    x = ord(c) - 97
    x = (x + idNum) % 26
    x = x + 97
    return chr(x)

sumOfRealID = 0

for line in open ("d4_input.txt", "r"):
    s = line.rstrip()
    s = s.split('-')
    letters = "".join(s[0:(len(s) - 1)])
    tail = s[-1].split('[')
    realID = isReal(letters, int(tail[0]), tail[1][:-1])
    sumOfRealID += realID

    if realID > 0:
        decrypted = decrypt(s[0:(len(s) - 1)], realID)
        if "northpole object" in decrypted:
            print "Part two: " + str(realID)

print "Part one: " + str(sumOfRealID)
