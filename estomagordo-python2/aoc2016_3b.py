f = open('input_3.txt', 'r')
lines = []
valid = 0
line_count = 0

for line in f:
	lines.append(map(int, line.split()))
	line_count += 1
	
for y in xrange(0, line_count-2, 3):
	for x in xrange(3):
		points = sorted([lines[y][x], lines[y+1][x], lines[y+2][x]])
		if points[0] + points[1] > points[2]:
			valid += 1
		
print valid