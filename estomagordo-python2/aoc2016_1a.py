f = open('input_1.txt', 'r')

moves = f.readline().split(', ')
x = 0
y = 0
facing = [0,1]

def rotate(facing, direction):
	change = (direction == 'R' and facing[0] != 0) or (direction == 'L' and facing[1] != 0)
	return [facing[1] * (-1 if change else 1), facing[0] * (-1 if change else 1)]

for move in moves:
	distance = int(move[1:])	
	facing = rotate(facing, move[0])
	x += facing[0] * distance
	y += facing[1] * distance
		
print abs(x) + abs(y)