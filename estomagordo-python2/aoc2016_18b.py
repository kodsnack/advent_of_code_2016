f = open('input_18.txt', 'r')

line = f.readline().rstrip()
width = len(line)
safe_count = sum(c == '.' for c in line)

for y in xrange(399999):
	templine = []
	
	for x in xrange(width):
		safe = True
		if x == 0:
			if line[1] == '^':
				safe = False
		elif x == width-1:
			if line[width-2] == '^':
				safe = False
		elif (line[x-1] == line[x] and line[x] != line[x+1]) or (line[x-1] != line[x] and line[x] == line[x+1]):
			safe = False
			
		if safe:
			safe_count += 1
			templine.append('.')
		else:
			templine.append('^')
		
	line = ''.join(c for c in templine)
	
print safe_count