from itertools import permutations

inputPath = "d21_input.txt"

def swap(s, x, y):
    xVal = s[x]
    yVal = s[y]
    s = s.replace(xVal, "x")
    s = s.replace(yVal, "y")
    s = s.replace("x", yVal)
    s = s.replace("y", xVal)
    return s

def rotate(s, x):
    steps = abs(x) % len(s)
    if x >= 0:
        steps = steps * (-1)
    return (s[(steps):]) + (s[0:steps])

def revT(s, x, y):
    reversedPart = s[x:(y+1)]
    reversedPart = reversedPart[::-1]
    return s[0:x] + reversedPart + s[(y+1):]

def mv(s, x, y):
    if x == y:
        return s
    xVal = s[x]
    yVal = s[y]
    s = s.replace(xVal, "")
    if y < x:
        s = s.replace(yVal, (xVal + yVal))
    else: 
        s = s.replace(yVal, (yVal + xVal))
    return s

def scramble(s, inss):
    pwd = s
    for ins in inss:
        if (ins[0] == "swap") and (ins[1] == "position"):
            pwd = swap(pwd, int(ins[2]), int(ins[5]))
        elif (ins[0] == "swap") and (ins[1] == "letter"):
            pwd = swap(pwd, pwd.index(ins[2]), pwd.index(ins[5]))
        elif (ins[0] == "rotate") and (ins[1] == "right"):
            pwd = rotate(pwd, int(ins[2]))
        elif (ins[0] == "rotate") and (ins[1] == "left"):
            pwd = rotate(pwd, (int(ins[2]) * (-1)))
        elif (ins[0] == "rotate") and (ins[1] == "based"):
            steps = pwd.index(ins[6]) + 1
            if steps > 4:
                steps += 1
            pwd = rotate(pwd, steps)
        elif ins[0] == "reverse":
            pwd = revT(pwd, int(ins[2]), int(ins[4]))
        elif ins[0] == "move":
            pwd = mv(pwd, int(ins[2]), int(ins[5]))
    return pwd

def parseInput(path):
    with open (path, "r") as inputfile:
        input = inputfile.readlines()
    lines = []
    for line in input:
        lines.append(line.split())
    return lines

def unscramble(s, inss):
    candidates = ["".join(p) for p in permutations(s)]
    for cand in candidates:
        if s == scramble(cand, inss):
            return cand
    print "No solution to part 2 was found!"

print "Part one: " + scramble("abcdefgh", parseInput(inputPath))
print "Part two: " + unscramble("fbgdceah", parseInput(inputPath))
