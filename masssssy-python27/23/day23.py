def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    instructions = inputdata.split("\n")
    instructionLength = len(instructions)
    instructions.append(" ")
    print instructions

    registers = [12, 0, 0, 0]

    currentInstruction = 0
    while instructions[currentInstruction] != " ":
        inst = instructions[currentInstruction]
        if inst[0:3] == "cpy":
            split = inst.split(" ")
            if split[2].lstrip("-").isdigit() == False:
                toReg = strToReg(split[2])
                if split[1].lstrip("-").isdigit():
                    if split[1][0] == "-":
                        fromReg = int(split[1].lstrip("-")) * (-1)
                    else:
                        fromReg = int(split[1])
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



        elif inst[0:3] == "tgl":
            split = inst.split(" ")
            if split[1].lstrip("-").isdigit():
                if split[1][0] == "-":
                    loopReg = int(split[1]) *(-1)
                else:
                    loopReg = int(split[1])
            else:
                loopReg = registers[strToReg(split[1])]
            #loopreg contains integer value
            #modify instruction that is loopreg positions away
            if (currentInstruction + loopReg) < instructionLength:
                instToModify = instructions[currentInstruction + loopReg].split()
                if len(instToModify) == 3:
                    if instToModify[0] == "jnz":
                        instructions[currentInstruction + loopReg] = "cpy " + instToModify[1] + " " + instToModify[2]
                    else:
                        instructions[currentInstruction + loopReg] = "jnz " + instToModify[1] + " " + instToModify[2]
                else:
                    #1 arg part
                    if instToModify[0] == "inc":
                        instructions[currentInstruction + loopReg] = "dec " + instToModify[1]
                    else:
                        instructions[currentInstruction + loopReg] = "inc " + instToModify[1]
            currentInstruction+=1

    	elif inst[0:3] == "jnz":
            split = inst.split(" ")
            if split[1].lstrip("-").isdigit():
    			loopReg = int(split[1])
            else:
                loopReg = registers[strToReg(split[1])]
            if loopReg != 0:
    			#jump
                if split[2].lstrip("-").isdigit():
                    if split[2][0] == "-":
                        distance = int(split[2].lstrip("-")) * (-1)
                    else:
                        distance = int(split[2])
                    currentInstruction+=distance
                else:
                    #isregister
                    distance = int(registers[strToReg(split[2])])
                    currentInstruction += distance
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