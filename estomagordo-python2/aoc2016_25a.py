f = open('input_25.txt', 'r')

registers = { 'a': 0, 'b': 0, 'c': 0, 'd': 0}

def get_val(argument):
	if argument in registers:
		return registers[argument]
	else:
		return int(argument)

instructions = []
for line in f:
	instructions.append(line.split())
	
instruction_count = len(instructions)
a_start = 0
really_big = 1000000000

while True:
    pointer = 0
    prev = 1
    success = True
    registers = registers = { 'a': a_start, 'b': 0, 'c': 0, 'd': 0}
    loop_count = 0
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
            val = get_val(instruction[1])
            if prev == 1:
                if val == 0:
                    prev = 0
                else:
                    success = False
                    break
            else:
                if val == 1:
                    prev = 1
                else:
                    success = False
                    break
        pointer += 1
        loop_count += 1
        if loop_count > really_big and success:
            print a_start
            break
        
    a_start += 1