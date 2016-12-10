from collections import defaultdict

f = open('input_10.txt', 'r')

bots = defaultdict(list)
outputs = defaultdict(list)
givings = []

for line in f:
	row = line.split()
	if row[0] == 'bot':
		giver = int(row[1])
		lowee = int(row[6])
		highee = int(row[-1])
		givings.append([giver, row[5] == 'bot', lowee, row[-2] == 'bot', highee])
	else:
		val = int(row[1])
		bot = int(row[-1])
		bots[bot].append(val)
	
pos = 0
	
while True:
	giver,loweebot,lowee,higheebot,highee = givings[pos]
	
	if len(bots[giver]) < 2:
		pos += 1
		if pos == len(givings):
			break
		continue
		
	little,big = min(bots[giver]), max(bots[giver])
	bots[giver] = []
	if loweebot:
		bots[lowee].append(little)		
	else:		
		outputs[lowee].append(little)
	if higheebot:
		bots[highee].append(big)		
	else:
		outputs[highee].append(big)
		
	if len(bots[lowee]) == 2 or len(bots[highee]) == 2:
		pos = 0
		continue
	
	pos += 1
	if pos == len(givings):
		break
	
print outputs[0][0] * outputs[1][0] * outputs[2][0]