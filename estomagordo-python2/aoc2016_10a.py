from collections import defaultdict

f = open('input_10.txt', 'r')

bots = defaultdict(list)
givings = []

for line in f:
	row = line.split()
	if row[0] == 'bot':
		giver = int(row[1])
		lowee = -1 if row[5] == 'output' else int(row[6])
		highee = -1 if row[-2] == 'output' else int(row[-1])
		givings.append([giver, lowee, highee])
	else:
		val = int(row[1])
		bot = int(row[-1])
		bots[bot].append(val)
	
pos = 0
	
while True:
	giver,lowee,highee = givings[pos]
	
	if len(bots[giver]) < 2:
		pos += 1
		continue
		
	little,big = min(bots[giver]), max(bots[giver])
	bots[giver] = []
	bots[lowee].append(little)
	bots[highee].append(big)
	
	if 17 in bots[lowee] and 61 in bots[lowee]:
		print lowee
		break
	if 17 in bots[highee] and 61 in bots[highee]:
		print highee
		break
		
	if len(bots[lowee]) == 2 or len(bots[highee]) == 2:
		pos = 0
		continue
	
	pos += 1