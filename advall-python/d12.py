src = "d12_input.txt"

def parseInstr(s):
    instr = []
    for index, val in enumerate(s):
        if index == 0:
            instr.append(val)
        elif val == 'a':
            instr.append(0)
        elif val == 'b':
            instr.append(1)
        elif val == 'c':
            instr.append(2)
        elif val == 'd':
            instr.append(3)
        else:
            instr.append("#" + val) # val is a hard-coded integer
    return instr


def loadInstrs(src):
    instrs = []
    for line in open (src, "r"):
        s = line.rstrip().split(" ")
        instr = parseInstr(s)
        instrs.append(instr)
    return instrs


def execProgram(instrs, initRegs):
    pc = 0
    regs = initRegs# registers [a,b,c,d]
    while pc in range(len(instrs)):
        instr = instrs[pc]
        if instr[0] == "cpy":
            # cpy x y copies x (either an integer or the value of a register) 
                # into register y.
            x = instr[1]
            y = instr[2]
            if type(x) is int:
                valX = regs[x]
            else:
                valX = int(x[1:len(x)])
            regs[y] = valX
            pc += 1
        elif instr[0] == "inc":
            # inc x increases the value of register x by one.
            x = instr[1]
            regs[x] = regs[x] + 1
            pc += 1
        elif instr[0] == "dec":
            # dec x decreases the value of register x by one.
            x = instr[1]
            regs[x] = regs[x] - 1
            pc += 1
        elif instr[0] == "jnz":
            # jnz x y jumps to an instruction y away (positive means forward; 
                # negative means backward), but only if x is not zero.
            x = instr[1]
            y = instr[2]
            if type(x) is int:
                valX = regs[x]
            else:
                valX = int(x[1:len(x)])
            if type(y) is int:
                valY = regs[y]
            else:
                valY = int(y[1:len(y)])
            if valX != 0:
                pc += valY
            else:
                pc += 1
        else:
            print "Aborted! This instruction is not valid: " + str(instr)
            break
    return regs

print "Part one: " + str(execProgram(loadInstrs(src), [0,0,0,0])[0])
print "Part two: " + str(execProgram(loadInstrs(src), [0,0,1,0])[0])
