f = open('input_9.txt', 'r')

outlen = 0
input = f.readline().rstrip()
inplen = len(input)
pos = 0

while pos < inplen:
	if input[pos] == '(':
		inparen = input[pos+1:pos+input[pos+1:].find(')')+1]
		complen, factor = map(int, inparen.split('x'))
		outlen += complen*factor
		pos += len(inparen) + complen + 2
	else:
		pos += 1
		outlen += 1
			
print outlen