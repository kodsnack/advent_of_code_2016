f = open('input_21.txt', 'r')

password = list('abcdefgh')
passlen = len(password)

for line in f.readlines():
	instructions = line.split()
	command = instructions[0]
	
	if command == 'swap':
		if instructions[1] == 'position':
			a,b = int(instructions[2]), int(instructions[-1])
			password[a], password[b] = password[b], password[a]
		else:
			a,b = instructions[2], instructions[-1]
			apos, bpos = password.index(a), password.index(b)
			password[apos], password[bpos] = password[bpos], password[apos]
	elif command == 'reverse':
		a,b = int(instructions[2]), int(instructions[-1])
		password = password[:a] + password[a:b+1][::-1] + password[b+1:]
	elif command == 'rotate':
		direction = -1
		steps = 1
		if instructions[1] == 'based':
			base = instructions[-1]
			basepos = password.index(base)
			steps += basepos + (1 if basepos > 3 else 0)
		elif instructions[1] == 'right':
			steps = int(instructions[2])
		else:
			direction = 1
			steps = int(instructions[2])
		steps = steps%passlen
		password = password[direction*steps:] + password[:direction*steps]
	else:
		a,b = int(instructions[2]), int(instructions[-1])
		if a < b:
			password = password[:a] + password[a+1:b+1] + [password[a]] + password[b+1:]
		else:
			password = password[:b] + [password[a]] + password[b:a] + password[a+1:]
		
print ''.join(c for c in password)