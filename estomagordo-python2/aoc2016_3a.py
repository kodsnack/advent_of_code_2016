f = open('input_3.txt', 'r')
valid = 0

for line in f:
	points = sorted(map(int, line.split()))
	if points[0] + points[1] > points[2]:
		valid += 1
		
print valid