from hashlib import md5

f = open('input_5.txt', 'r')
id = f.next().rstrip()
password = ['' for x in xrange(8)]
pos = 0
i = 0

while pos < 8:
	hash = md5(id+str(i)).hexdigest()
	if hash[:5] == '00000':
		password[pos] = hash[5]
		pos += 1
	i += 1
	
print ''.join(c for c in password)