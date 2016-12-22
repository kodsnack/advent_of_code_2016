from heapq import heappush, heappop

def adjacent(a,b):
	return a in [[b[0]+1,b[1]],[b[0]-1,b[1]],[b[0],b[1]+1],[b[0],b[1]-1]]

f = open('input_22.txt', 'r')

linecount = -3
width = 35
height = 29
full = set()
empty = []	
for line in f.readlines():
	linecount += 1
	if linecount < 0:
		continue
	row = line.split()
	used = int(row[2][:-1])
	avail = int(row[3][:-1])
	if used > 100:
		full.add((linecount/height,linecount%height))
	if used < 10:
		empty = [linecount/height,linecount%height]

origin = [0,0]
seen = set()
state = (empty[0],empty[1],34,0)
frontier = [[0,state]]

while True:
	steps, state = heappop(frontier)
	if state in seen:
		continue
		
	seen.add(state)
	empty_x, empty_y, data_x, data_y = state
	empty = [empty_x, empty_y]
	data = [data_x, data_y]	
	steps += 1
	
	if adjacent(empty, data):
		if empty == origin:
			print steps
			break
		tup = (data_x, data_y, empty_x, empty_y)
		if not tup in seen:
			heappush(frontier, [steps, tup])
		
	if empty_x > 0 and not (empty_x-1, empty_y) in full and not [empty_x-1, empty_y] == data:
		tup = (empty_x-1, empty_y, data_x, data_y)
		if not tup in seen:
			heappush(frontier, [steps, tup])
	if empty_x < width-1 and not (empty_x+1, empty_y) in full and not [empty_x+1, empty_y] == data:
		tup = (empty_x+1, empty_y, data_x, data_y)
		if not tup in seen:
			heappush(frontier, [steps, tup])
	if empty_y > 0 and not (empty_x, empty_y-1) in full and not [empty_x, empty_y-1] == data:
		tup = (empty_x, empty_y-1, data_x, data_y)
		if not tup in seen:
			heappush(frontier, [steps, tup])
	if empty_y < height-1 and not (empty_x, empty_y+1) in full and not [empty_x, empty_y+1] == data:
		tup = (empty_x, empty_y+1, data_x, data_y)
		if not tup in seen:
			heappush(frontier, [steps, tup])