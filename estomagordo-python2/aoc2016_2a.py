f = open('input_2.txt', 'r')

def move(pos, direction):
	if direction == 'U' and pos > 3:
		return pos-3
	elif direction == 'R' and pos%3 > 0:
		return pos+1
	elif direction == 'D' and pos < 7:
		return pos+3
	elif direction == 'L' and pos%3 != 1:
		return pos-1
	return pos
		
pos = 5
out = []

for line in f:
	for c in line:
		pos = move(pos, c)
	out.append(str(pos))
	
print ''.join(c for c in out)