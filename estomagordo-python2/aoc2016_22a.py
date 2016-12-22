f = open('input_22.txt', 'r')

nodes = []
linecount = 0
for line in f.readlines():
	linecount += 1
	if linecount < 3:
		continue
	row = line.split()
	used = int(row[2][:-1])
	avail = int(row[3][:-1])
	nodes.append([used,avail])
	
viable_count = 0
for x in xrange(len(nodes)-1):
	for y in xrange(x+1,len(nodes)):
		a,b = nodes[x],nodes[y]
		if a[0] > 0 and a[0] <= b[1]:
			viable_count += 1
		if b[0] > 0 and b[0] <= a[1]:
			viable_count += 1
			
print viable_count