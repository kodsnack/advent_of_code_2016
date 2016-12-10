with open ("d9_input.txt", "r") as inputfile:
    input = inputfile.read()

def repeatS(s, times):
    newS = ""
    for i in range(times):
        newS += s
    return newS

def isInt(s):
    try: 
        int(s)
        return True
    except ValueError:
        return False

def isMarker(s):
    candidate = s.split("x", 1)
    return isInt(candidate[0]) and isInt(candidate[1])

def findMarkers(s, recursive):
    i = 0
    dLenght = 0
    while i < len(s):
        if s[i] == '(':
            endParanthesis = s.find(")", i, len(s))
            markerCandidate = s[(i+1):endParanthesis]
            if isMarker(markerCandidate):
                marker = markerCandidate.split("x", 1)
                marker = (int(marker[0]), int(marker[1]))
                if recursive:
                    dLenght += findMarkers(s[(endParanthesis+1):(endParanthesis+1+marker[0])], True) * marker[1]
                else:
                    dLenght += marker[0] * marker[1]


                i = endParanthesis+1+int(marker[0])
            else:
                dLenght += 1
                i += 1
        else:
                dLenght += 1
                i += 1
    return dLenght


print "Part one: " + str(findMarkers(input, False))
print "Part two: " + str(findMarkers(input, True))