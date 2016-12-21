import re

def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

    bots = dict() #key=botId, list 1 = current chips, tuple = (lowlocation, high location)
    outputs = dict()

    importantOutputs = [[],[],[]]

    startBotId = None
    initial = [x for x in splitData if x.startswith('value')]
    for instr in initial: 
    	values = [int(s) for s in re.findall(r'\d+', instr)]
    	bot = values[1]

    	if values[1] in bots:
    		chips = bots.get(values[1])[0]
    		chips.append(values[0])
    		#print "add value only"
    		startBotId = values[1]
    	else:
    		#print "add bot and value"
    		#add bot with this value
    		bots[values[1]] = [[values[0]], []]

    #append instructions to each bot
    instructions = [x for x in splitData if not x.startswith('value')]
    #print instructions
    for instr in instructions:
    	botId = [int(b) for b in re.findall(r'\d+', [s for s in re.findall(r'bot \d+', instr)][0])][0] # <= "Easy to read level" = haskell

    	#Who should this bot give to?!
    	lowTo = [s for s in re.findall(r'low to bot \d+', instr)]
    	if lowTo == []:
    		#low going to output
    		lowTo = [s for s in re.findall(r'low to output \d+', instr)]
    		lowTo = ["output"] + [int(s) for s in re.findall(r'\d+', lowTo[0])]
    	else:
    		lowTo = ["bot"] + [int(s) for s in re.findall(r'\d+', lowTo[0])]
    	
    	highTo = [s for s in re.findall(r'high to bot \d+', instr)]
    	#high going to output
    	if highTo == []: 
    		highTo = [s for s in re.findall(r'high to output \d+', instr)]
    		highTo = ["output"] + [int(s) for s in re.findall(r'\d+', highTo[0])]
    	else:
    		#high going to bot
    		highTo = ["bot"] + [int(s) for s in re.findall(r'\d+', highTo[0])]

    	if bots.get(botId) != None:
    		#bot exists
    		bot = bots.get(botId)
    		bot[1].append(lowTo)
    		bot[1].append(highTo)
    	else:
    		#new bot
    		bots[botId] = [[], [lowTo, highTo]]

    #Bots are created, start dealing chips
    hasTwo = []
    currentBotId = startBotId
    theBot = None
    found = False
    while found == False:
    	currentBot = bots.get(currentBotId)

    	#print currentBotId
    	#print currentBot

    	#keep moving
    	chip1 = currentBot[0][0]
    	chip2 = currentBot[0][1]
    	#print currentBot

    	if chip1 == 17 and chip2 == 61 or chip1 == 61 and chip2 == 17:
    		print "FOOOUND!!!"
    		theBot = currentBotId

    	if chip1 > chip2:
    		low = chip2
    		high = chip1
    	else:
    		low = chip1
    		high = chip2

    	giveLowTo = currentBot[1][0]
    	giveHighTo = currentBot[1][1]

    	#give low
    	#giveLowBot = bots.get(giveLowTo[1])
    	if giveLowTo[0] == "bot":
    		#give to bot
    		giveLowBot = bots.get(giveLowTo[1])
    		giveLowBot[0].append(low)
    	else: 
    		#give to output
    		#giveLowBot = output.get(giveLowTo[1])
    		giveLowBot = None
    		if giveLowTo[1] == 0 or giveLowTo[1] == 1 or giveLowTo[1] == 2:
    			importantOutputs[giveLowTo[1]].append(low)



    	#give high
    	if giveHighTo[0] == "bot":
    		#give to bot
    		giveHighBot = bots.get(giveHighTo[1])
    		giveHighBot[0].append(high)
    	else:
    		#give to output
    		#giveHighBot = output.get(giveHighTo[1])
    		giveHighBot = None
    		if giveHighTo[1] == 0 or giveHighTo[1] == 1 or giveHighTo[1] == 2:
    			importantOutputs[giveHighTo[1]].append(high)

    	#print giveLowBot
    	#print giveHighBot

    	#remove chips from this bot
    	#print "current"
    	#print currentBotId
    	#print currentBot
    	#currentBot[0] = []
    	#print currentBot

    	#print "low"
    	#print giveLowBot
    	#print "high"
    	#print giveHighBot

    	#select new current bot
    	if giveLowBot != None:
    		if len(giveLowBot[0]) == 2 :
    			hasTwo.append(giveLowTo[1])
    	if giveHighBot != None:
    		if len(giveHighBot[0]) == 2:
    			hasTwo.append(giveHighTo[1])

    	#print hasTwo
    	if len(hasTwo) > 0:
    		currentBotId=hasTwo.pop(0)
    	else:
    		#done
    		found = True
    		print theBot
    		print importantOutputs[0][0] * importantOutputs[1][0] * importantOutputs[2][0]

if __name__ == "__main__":
    main()