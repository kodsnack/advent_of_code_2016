import hashlib

def solve_part1():
	id = 'ugkcyxxp'
	i = 0
	code = ''

	while len(code) < 8:
		test = (id + str(i)).encode('utf-8')
		hash = hashlib.md5(test).hexdigest()

		if hash.startswith('00000'):
			code += hash[5]

		i += 1

	print(code)

def solve_part2():
	id = 'ugkcyxxp'
	i = 0
	code = ['z'] * 8
	codelen = 0

	while codelen < 8:
		test = (id + str(i)).encode('utf-8')
		hash = hashlib.md5(test).hexdigest()

		if hash.startswith('00000'):
			position = hash[5]

			if position.isdigit():
				position = int(position)

				if position <= 7 and code[position] == 'z':
					code[position] = hash[6]
					codelen += 1
		i += 1

	print(''.join(code))

solve_part1()
solve_part2()
