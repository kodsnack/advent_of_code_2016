f = open('input_8.txt', 'r')

def rect(matrix, width, height):
	for row in xrange(height):
		for col in xrange(width):
			matrix[row][col] = '#'
	return matrix
			
def rotrow(matrix, row, steps):
	matrix[row] = [matrix[row][(x-steps)%50] for x in xrange(50)]
	return matrix

def rotcol(matrix, col, steps):
	newcol = []
	for row in xrange(6):
		newcol.append(matrix[(row-steps)%6][col])
	for row in xrange(6):
		matrix[row][col] = newcol[row]
	return matrix
	
matrix = [['.' for x in xrange(50)] for y in xrange(6)]

for line in f:
	row = line.split()	
	if row[0] == 'rect':
		vals = map(int, row[1].split('x'))
		matrix = rect(matrix, vals[0], vals[1])
	else:
		id = int(row[2].split('=')[1])
		steps = int(row[-1])
		if row[1] == 'row':
			matrix = rotrow(matrix, id, steps)
		else:
			matrix = rotcol(matrix, id, steps)
	
print sum(sum(row[x] == '#' for x in xrange(50)) for row in matrix)