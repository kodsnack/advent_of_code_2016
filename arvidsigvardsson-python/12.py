# register initialization
# part 1
regs = {'a': 0, 'b': 0, 'c': 0, 'd': 0}

# part 2
# regs = {'a': 0, 'b': 0, 'c': 1, 'd': 0}

# program memory and counter
prg_mem = []
prg_cnt = 0

# help function that evaluates either a register or a literal to an int value
def evaluate(x):
    if x in 'abcd':
        return regs[x]
    else:
        return int(x)
        
# instruction functions
def inc(params):
    reg = params[0]
    old_value = regs[reg]
    regs[reg] = old_value + 1
    
def dec(params):
    reg = params[0]
    old_value = regs[reg]
    regs[reg] = old_value - 1
    
def cpy(params):
    value = evaluate(params[0])
    regs[params[1]] = value
    
def jnz(params):
    global prg_cnt
    if evaluate(params[0]) != 0:
        prg_cnt = prg_cnt + int(params[1]) - 1 # minus 1 because program counter is increased by 1 after every executed line

# dictionary for the instructions
instructions = {'inc': inc, 'dec': dec, 'cpy': cpy, 'jnz': jnz}

# read file and create a tuple for every line to be stored in the program memory, where the first entry is a string key for the instruction, and the second is a list of the parameters
filename = 'input12.txt'
with open(filename) as file:
    for line in file:
        line = line.strip()
        words = line.split(' ')
        instr = words[0]
        params = words[1:]
        prg_mem.append((instr, params))

# run program
while prg_cnt < len(prg_mem):
    (instr, params) = prg_mem[prg_cnt]    
    instructions[instr](params)
    
    # increase program counter by 1 for every line executed
    prg_cnt += 1
    
print 'Contents of registers:'
print regs