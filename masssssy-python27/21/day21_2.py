def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()
    splitData = inputdata.split("\n")

    splitData.reverse()
    scramble = list("fbgdceah")

    for instr in splitData:
        splitInstr = instr.split(" ")
        if splitInstr[0] == "swap":
            if splitInstr[1] == "position":
                fromTo=[int(s) for s in instr.split() if s.isdigit()]
                scramble = swap(scramble, fromTo[1], fromTo[0])
            else:
                index1 = scramble.index(splitInstr[2])
                index2 = scramble.index(splitInstr[5])
                scramble = swap(scramble, index2, index1)

        elif splitInstr[0] == "rotate":
            if splitInstr[1] == "based":
                letter = splitInstr[-1:]
                index = findIndex(scramble, letter[0])
                scramble = deRotate(scramble, index)
            else:
                steps =[int(s) for s in instr.split() if s.isdigit()][0]
                if splitInstr[1] == "left":
                    scramble = rotate(scramble, "R", steps)
                else:
                    scramble = rotate(scramble, "L", steps)

        elif splitInstr[0] == "move":
            fromTo =[int(s) for s in instr.split() if s.isdigit()]
            scramble = move(scramble, fromTo[1], fromTo[0])
        elif splitInstr[0] == "reverse":
            fromTo=[int(s) for s in instr.split() if s.isdigit()]
            scramble = reverse(scramble, fromTo[0], fromTo[1])
        print scramble
    print ''.join(scramble)

def reverse(string, startPos, endPos):
    before = string[0:startPos]
    after = string[endPos+1:]
    toReverse = string[startPos:endPos+1]
    reverse = toReverse[::-1]
    return  before + reverse + after

def move(string, fromIndex, toIndex):
    charToMove = string[fromIndex]
    string.remove(charToMove)
    string.insert(toIndex, charToMove)
    return string

def swap(string, index1, index2):
    in1 = string[index1]
    string[index1] = string[index2]
    string[index2] = in1
    return string

def rotate(string, direction, amount):
    if direction == "R":
        string = string[-amount:] + string[:-amount]
    else:
        string = string[amount:] + string[:amount]
    return string

def findIndex(after, char):
    rot = after
    for x in range(0,8):
        rot=rotate(rot, "L", 1)
        index = rot.index(char)

        if doRotation(rot, index) == after:
            if x >= 4:
                b = x-1
            else:
                b=x
            return b


def doRotation(string, x):
    if x >= 4:
        string = rotate(string, "R", 1)
    else:
        b=string
    string = rotate(string, "R", 1+x)
    return string

def deRotate(string, x):
    if x >= 4:
        string = rotate(string, "L", 1)
    else:
        b=string
    string = rotate(string, "L", 1+x)
    return string

#def main2():
#    str = list("acbghdef")
#    rotated = doRotation(str, 2)
#    print rotated
#
#    index = findIndex(rotated, "b")
#    print index
#
#    deRotated = deRotate(rotated, index)
#    print deRotated


#main2()
main()



