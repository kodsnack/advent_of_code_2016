holdings = dict()
moves = dict()

def giveTo(chip, bot):
    if bot not in holdings:
            holdings[bot] = [chip]
    else:
        holdings[bot] = holdings[bot] + [chip]

for line in open ("d10_input.txt", "r"):
    s = line.rstrip()
    if s[0:5] == "value":
        ass = s[6:len(s)].split(" goes to ")
        chip = int(ass[0])
        bot = ass[1]
        giveTo(chip, bot)
    else:
        instr = s[0:len(s)]
        instr = instr.split(" gives low to ")
        instrr = instr[1].split(" and high to ")
        bot = instr[0]
        lowTo = instrr[0]
        highTo = instrr[1]
        moves[bot] = (lowTo, highTo)

solutionBot = -1
somethingChanged = True
while somethingChanged:
    bots = holdings.keys()
    somethingChanged = False
    for bot in bots:
        if len(holdings[bot]) == 2:
            low = min(holdings[bot])
            high = max(holdings[bot])
            if ((low, high) == (17, 61)) and (solutionBot < 0):
                solutionBot = int(bot[4:len(bot)])
            (lowTo, highTo) = moves[bot]
            giveTo(low, lowTo)
            giveTo(high, highTo)
            holdings[bot] = []
            somethingChanged = True

print "Part one: " + str(solutionBot)
print "Part two: " + str(holdings['output 0'][0] * holdings['output 1'][0] * holdings['output 2'][0])