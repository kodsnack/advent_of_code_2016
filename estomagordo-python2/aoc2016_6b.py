f = open('input_6.txt', 'r')

dicts = [{} for x in xrange(8)]
for line in f:
	for x in xrange(8):
		c = line[x]
		if c in dicts[x]:
			dicts[x][c] += 1
		else:
			dicts[x][c] = 1
			
out = []
for x in xrange(8):
	lowest = 100000000
	rarest = ''
	for char in dicts[x].keys():
		val = dicts[x][char]
		if val < lowest:
			lowest = val
			rarest = char
	out.append(rarest)
	
print ''.join(c for c in out)