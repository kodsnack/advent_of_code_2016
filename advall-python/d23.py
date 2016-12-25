src = "d23_input.txt"

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
            if type(y) is int:
                if type(x) is int:
                    valX = regs[x]
                else:
                    valX = int(x[1:len(x)])
                regs[y] = valX
            pc += 1
        elif instr[0] == "inc":
            # inc x increases the value of register x by one.
            if ((pc > 0) and ((pc+4) < len(instrs)) 
                and (instrs[pc+1][0] == "dec") 
                and (instrs[pc+2][0] == "jnz") 
                and (instrs[pc+1][1] == instrs[pc+2][1]) 
                and (instrs[pc+2][2] == "#-2") 
                and (instrs[pc+3][0] == "dec") 
                and (instrs[pc+4][0] == "jnz") 
                and (instrs[pc+3][1] == instrs[pc+4][1]) 
                and (instrs[pc+4][2] == "#-5")
                and (instrs[pc-1][0] == "cpy")
                and (instrs[pc-1][2] == instrs[pc+1][1])):
                # this set of 5 instrs can be optimized by multiplication!
                x = instr[1]
                z = instrs[pc+1][1]
                w = instrs[pc+3][1]
                if (type(x) is int) and (type(z) is int) and (type(w) is int):
                    regs[x] += (regs[z] * regs[w])
                    regs[z] = 0
                    regs[w] = 0
                else:
                    # this inc was not the start of an optimizable set of instrs
                    x = instr[1]
                    if type(x) is int:
                        regs[x] = regs[x] + 1
                    pc += 1
                pc += 5
            else:
                # this inc was not the start of an optimizable set of instrs
                x = instr[1]
                if type(x) is int:
                    regs[x] = regs[x] + 1
                pc += 1
        elif instr[0] == "dec":
            # dec x decreases the value of register x by one.
            x = instr[1]
            if type(x) is int:
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
            if (valX != 0) and ((pc + valY) >= 0) and ((pc + valY) < len(instrs)):
                pc += valY
            else:
                pc += 1
        elif instr[0] == "tgl":
            # tgl x toggles the instruction x away (pointing at instructions 
                # like jnz does: positive means forward; negative means backward)
            x = instr[1]
            if type(x) is int:
                valX = regs[x]
            else:
                valX = int(x[1:len(x)])
            if ((pc + valX) >= 0) and ((pc + valX) < len(instrs)):
                instrToTgl = instrs[pc + valX]
                if instrToTgl[0] == "inc":
                    # inc becomes dec
                    instrToTgl[0] = "dec"
                elif (instrToTgl[0] == "dec") or (instrToTgl[0] == "tgl"):
                    # all other one-argument instructions become inc
                    instrToTgl[0] = "inc"
                elif instrToTgl[0] == "jnz":
                    # jnz becomes cpy
                    instrToTgl[0] = "cpy"
                elif instrToTgl[0] == "cpy":
                    # all other two-instructions become jnz
                    instrToTgl[0] = "jnz"
                instrs[pc + valX] = instrToTgl
            pc += 1
        else:
            print "Aborted! This instruction is not valid: " + str(instr)
            break
    return regs

print "Part one: " + str(execProgram(loadInstrs(src), [7,0,0,0])[0])
print "Part two: " + str(execProgram(loadInstrs(src), [12,0,0,0])[0])