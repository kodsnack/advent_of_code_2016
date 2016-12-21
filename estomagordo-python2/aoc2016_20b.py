f = open('input_20.txt', 'r')

ranges = []

for line in f.readlines():
	start, stop = map(int,line.split('-'))
	ranges.append([start,1])
	ranges.append([stop,-1])
	
ranges.sort()

status = 0
allowed_count = 0
latest_end = -1
for value in ranges:
	status += value[1]
	if status == 0:
		latest_end = value[0]
	if status == value[1] == 1:
		allowed_count += value[0] - latest_end - 1
		
print allowed_count + 2**32 - 1 - value[0]