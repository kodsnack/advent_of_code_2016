path = "d20_input.txt"

def parseInput(path):
    ranges = []
    for line in open (path, "r"):
        s = line.rstrip().split("-")
        s = (int(s[0]), int(s[1]))
        ranges.append(s)
    return ranges

def solve(ranges):
    i = 0
    part1Sol = -1
    part2Sol = 0
    ranges.sort()
    while i < 4294967296:
        if len(ranges) > 0:
            fstRange = ranges.pop(0)
        else:
            part2Sol += (4294967296 - i)
            break

        if (i < fstRange[0]):
            if (part1Sol < 0):
                part1Sol = i
            part2Sol += 1
            i += 1
            ranges.insert(0, fstRange)
        elif (i >= fstRange[0]) and (i <= fstRange[1]):
            i = fstRange[1] + 1

    return (part1Sol, part2Sol)


solutions = solve(parseInput(path))
print "Part one: " + str(solutions[0])
print "Part two: " + str(solutions[1])