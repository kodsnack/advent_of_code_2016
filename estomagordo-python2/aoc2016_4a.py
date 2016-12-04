f = open('input_4.txt', 'r')
idsum = 0

for line in f:
	letters = {}
	parts = line.split('-')
	last = parts[-1].split('[')
	id = int(last[0])
	checksum = last[1][:last[1].find(']')]
	
	for x in xrange(len(parts)-1):
		for c in parts[x]:
			if c in letters:
				letters[c] += 1
			else:
				letters[c] = 1
				
	rank = sorted([-letters[c],c] for c in letters.keys())
	rankstr = ''.join(rank[x][1] for x in xrange(min(5,len(rank))))
	
	if rankstr == checksum:
		idsum += id
		
print idsum