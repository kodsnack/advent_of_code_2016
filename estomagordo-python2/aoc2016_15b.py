f = open('input_15.txt', 'r')

discs = []

for line in f:
	row = line.split()
	a = int(row[3])
	b = int(row[-1][0:row[-1].find('.')])
	discs.append([a,b])

discs.append([11,0])
	
t = 0
while True:
	success = True
	
	for x in xrange(len(discs)):
		disc = discs[x]
		if (disc[1] + x + 1 + t) % disc[0] > 0:
			success = False
			break
	
	if success:
		print t
		break
		
	t += 1