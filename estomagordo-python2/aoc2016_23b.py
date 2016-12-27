f = open('input_23.txt', 'r')

registers = { 'a': 12, 'b': 0, 'c': 0, 'd': 0}

def get_val(argument):
	if argument in registers:
		return registers[argument]
	else:
		return int(argument)

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
		if not recipient in registers:
			pointer += 1
			continue
		if instruction[1] in registers:
			registers[recipient] = registers[instruction[1]]
		else:
			registers[recipient] = int(instruction[1])
	elif command == 'jnz':
		a = instruction[1]
		comparison = get_val(a)
		b = instruction[2]
		steps = get_val(b) - 1		
		if comparison != 0:
			pointer += steps
	else:
		argument = instruction[1]
		val = get_val(argument)
		if pointer+val < 0 or pointer+val >= instruction_count:
			pointer += 1
			continue
		toggled_instruction = instructions[pointer+val]
		if len(toggled_instruction) == 2:
			toggled_instruction[0] = 'dec' if toggled_instruction[0] == 'inc' else 'inc'
		elif len(toggled_instruction) == 3:
			toggled_instruction[0] = 'cpy' if toggled_instruction[0] == 'jnz' else 'jnz'
			
	pointer += 1
	
print registers['a']