f = open('input_2.txt', 'r')

def move(pos, direction):
	if direction == 'U':
		if pos.isdigit():
			i = int(pos)
			if i == 3:
				pos = '1'
			elif 5 < i < 9:
				pos = str(i-4)
		elif pos == 'A':
			pos = '6'
		elif pos == 'B':
			pos = '7'
		elif pos == 'C':
			pos = '8'
		elif pos == 'D':
			pos = 'B'
	elif direction == 'R':
		if pos.isdigit():
			i = int(pos)
			if int(i**0.5) != i**0.5:
				pos = str(i+1)
		elif pos == 'A':
			pos = 'B'
		elif pos == 'B':
			pos = 'C'
	elif direction == 'D':
		if pos.isdigit():
			if pos == '1':
				pos = '3'
			elif int(pos) < 5:
				pos = str(int(pos)+4)
			elif pos == '6':
				pos = 'A'
			elif pos == '7':
				pos = 'B'
			elif pos == '8':
				pos = 'C'
		elif pos == 'B':
			pos = 'D'
	elif direction == 'L':
		if pos.isdigit():
			i = int(pos)
			if not i in [1,2,5]:
				pos = str(i-1)
		elif pos == 'B':
			pos = 'A'
		elif pos == 'C':
			pos = 'B'
	return pos
		
pos = '5'
out = []

for line in f:
	for c in line:
		pos = move(pos, c)
	out.append(pos)
	
print ''.join(c for c in out)