from heapq import heappush, heappop

def is_wall(x, y, favourite):
	big_sum = x*x + 3*x + 2*x*y + y + y*y + favourite
	ones = 0
	power = 1
	while power <= big_sum:
		if (big_sum & power) == power:
			ones += 1
		power *= 2
	return ones % 2

f = open('input_13.txt', 'r')
favourite = int(f.readline())
grid = {}
startx = 1
starty = 1
endx = 31
endy = 39
frontier = [[0,startx,starty]]
grid[(startx,starty)] = [is_wall(startx,starty,favourite),False]

while True:
	steps,x,y = heappop(frontier)
	if x == endx and y == endy:
		print steps
		break
	if grid[(x,y)][1]:
		continue
		
	grid[(x,y)][1] = True
	steps += 1
			
	if not (x+1,y) in grid:
		wall = is_wall(x+1,y,favourite)
		grid[(x+1,y)] = [wall,False]
		if not wall:
			heappush(frontier, [steps,x+1,y])
	if not (x,y+1) in grid:
		wall = is_wall(x,y+1,favourite)
		grid[(x,y+1)] = [wall,False]
		if not wall:
			heappush(frontier, [steps,x,y+1])
	if x > 0 and not (x-1,y) in grid:
		wall = is_wall(x-1,y,favourite)
		grid[(x-1,y)] = [wall,False]
		if not wall:
			heappush(frontier, [steps,x-1,y])
	if y > 0 and not (x,y-1) in grid:
		wall = is_wall(x,y-1,favourite)
		grid[(x,y-1)] = [wall,False]
		if not wall:
			heappush(frontier, [steps,x,y-1])