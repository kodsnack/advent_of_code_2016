f = open('input_7.txt', 'r')

tls_count = 0

for line in f:
	l = len(line.rstrip())
	in_brackets = False
	abba_found = False
	abba_in_brackets_found = False
	
	for x in xrange(l-3):
		if line[x] != line[x+1] and line[x] == line[x+3] and line[x+1] == line[x+2]:
			if in_brackets:
				abba_in_brackets_found = True
				break
			abba_found = True
		if line[x] == '[':
			in_brackets = True
		elif line[x] == ']':
			in_brackets = False
	
	if abba_found and not abba_in_brackets_found:
		tls_count += 1
		
print tls_count