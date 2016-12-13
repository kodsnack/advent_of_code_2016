def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    instructions = inputdata.split("\n")
    instructions.append(" ")
    print instructions

    registers = [0, 0, 1, 0]

    currentInstruction = 0
    while instructions[currentInstruction] != " ":
    	inst = instructions[currentInstruction]
    	if inst[0:3] == "cpy":
    		split = inst.split(" ")
    		toReg = strToReg(split[2])
    		if split[1].isdigit():
    			registers[toReg] = int(split[1])
    		else:
    			#reg to reg
    			fromReg = strToReg(split[1])
    			toReg = strToReg(split[2])
    			registers[toReg] = registers[fromReg]
    		currentInstruction+=1

    	elif inst[0:3] == "inc":
    		reg = strToReg(inst[4])
    		registers[reg] = registers[reg]+1
    		currentInstruction+=1

    	elif inst[0:3] == "dec":
    		reg = strToReg(inst[4])
    		registers[reg] = registers[reg]-1
    		currentInstruction+=1

    	elif inst[0:3] == "jnz":
    		split = inst.split(" ")
    		#print "jnz"
    		if split[1].isdigit():
    			loopReg = int(split[1])
    		else:	
    			loopReg = registers[strToReg(split[1])]
    		if loopReg != 0:
    			#jump
    			distance = int(split[2].replace("-",""))
    			#print currentInstruction
    			if split[2][0] == "-":
    				#negative
    				currentInstruction-=distance
    			else:
    				currentInstruction+=distance
    		else:
    			currentInstruction+=1

    print "Registers"
    print registers[0]
    print registers[1]
    print registers[2]
    print registers[3]

def strToReg(register):
	if register == "a":
		return 0
	if register == "b":
		return 1
	if register == "c":
		return 2
	if  register == "d":
		return 3



if __name__ == "__main__":
    main()