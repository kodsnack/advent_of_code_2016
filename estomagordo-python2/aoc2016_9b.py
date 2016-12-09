f = open('input_9.txt', 'r')

def get_len(s, pos, end):
	slen = 0
	while pos < end:
		if s[pos] == '(':
			inparen = s[pos+1:pos+s[pos+1:].find(')')+1]
			complen, factor = map(int, inparen.split('x'))
			nextstart = pos + len(inparen) + 2
			nextend = nextstart + complen
			slen += get_len(s, nextstart, nextend) * factor
			pos = nextend
		else:
			pos += 1
			slen += 1
	return slen
	
input = f.readline().rstrip()
inplen = len(input)
			
print get_len(input, 0, inplen)