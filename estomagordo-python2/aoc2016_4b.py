f = open('input_4.txt', 'r')
a = ord('a')

for line in f:
	parts = line.split('-')
	last = parts[-1].split('[')
	id = int(last[0])
	
	message = ' '.join(''.join(chr(((ord(c)-a+id)%26)+a) for c in word) for word in parts[:-1])
	if message == 'northpole object storage':
		print id
		break