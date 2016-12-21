f = open('input_12.txt', 'r')

registers = { 'a': 0, 'b': 0, 'c': 0, 'd': 0}

instructions = []
for line in f:
	instructions.append(line.split())
	
pointer = 0
instruction_count = len(instructions)

while pointer < instruction_count:
	instruction = instructions[pointer]
	command = instruction[0]
	if command == 'inc':
		registers[instruction[1]] += 1
	elif command == 'dec':
		registers[instruction[1]] -= 1
	elif command == 'cpy':
		recipient = instruction[2]
		if instruction[1] in registers:
			registers[recipient] = registers[instruction[1]]
		else:
			registers[recipient] = int(instruction[1])
	else:
		steps = int(instruction[2]) - 1
		comparison = 0
		if instruction[1] in registers:
			comparison = registers[instruction[1]]
		else:
			comparison = int(instruction[1])
		if comparison != 0:
			pointer += steps
	pointer += 1
	
print registers['a']