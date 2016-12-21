f = open('input_20.txt', 'r')

ranges = []

for line in f.readlines():
	start, stop = map(int,line.split('-'))
	ranges.append([start,1])
	ranges.append([stop,-1])
	
ranges.sort()

status = 0
found = False
latest_end = -1
for value in ranges:
	status += value[1]
	if status == 0:
		latest_end = value[0]
	if status == value[1] == 1 and value[0] - latest_end > 1:
		found = True
		print latest_end + 1
		break
		
if not found:
	print value[0] + 1