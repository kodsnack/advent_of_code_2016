def expand(s):
	return s + '0' + ''.join('0' if s[x] == '1' else '1' for x in xrange(len(s)-1,-1,-1))

def get_checksum(s):
	checksum = ''.join('1' if s[x] == s[x+1] else '0' for x in xrange(0,len(s),2))
	if len(checksum) % 2 == 1:
		return checksum
	return get_checksum(checksum)
	
f = open('input_16.txt', 'r')

input = f.readline().rstrip()
disk_length = 35651584

while len(input) < disk_length:
	input = expand(input)

print get_checksum(input[:disk_length])