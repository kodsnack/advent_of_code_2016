from hashlib import md5

f = open('input_5.txt', 'r')
id = f.next().rstrip()
password = ['' for x in xrange(8)]
filled = 0
i = 0

while filled < 8:
	hash = md5(id+str(i)).hexdigest()
	if hash[:5] == '00000' and hash[5].isdigit():
		pos = int(hash[5])
		if pos < 8 and password[pos] == '':
			password[pos] = hash[6]
			filled += 1
	i += 1
	
print ''.join(c for c in password)