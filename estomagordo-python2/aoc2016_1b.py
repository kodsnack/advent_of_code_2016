f = open('input.txt', 'r')

moves = f.readline().split(', ')
x = 0
y = 0
facing = [0,1]
seen = set()
done = False

def rotate(facing, direction):
	change = (direction == 'R' and facing[0] != 0) or (direction == 'L' and facing[1] != 0)
	return [facing[1] * (-1 if change else 1), facing[0] * (-1 if change else 1)]

for move in moves:
	distance = int(move[1:])	
	facing = rotate(facing, move[0])	
	x_change = facing[0] * distance
	y_change = facing[1] * distance
	
	for step in xrange(1,distance+1):
		x += facing[0]
		y += facing[1]
		if (x,y) in seen:
			print abs(x) + abs(y)
			done = True
			break
		seen.add((x,y))
	
	if done:
		break