import sys

class Machine():
    def __init__(self, a, b, c, d, pc):
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.pc = pc
        
def step1(inp):
    instructions = parse_instructions(inp)
    m = execute(Machine(0, 0, 0, 0, 0), instructions)
    return m.a

def step2(inp):
    instructions = parse_instructions(inp)
    m = execute(Machine(0, 0, 1, 0, 0), instructions)
    return m.a

def parse_instructions(inp):
    if not inp:
        return []
    else:
        xs = inp[0].strip().split()
        if xs[0] == 'cpy':
            return [cpy(xs[1], xs[2])] + parse_instructions(inp[1:])
        elif xs[0] == 'inc':
            return [inc(xs[1])] + parse_instructions(inp[1:])
        elif xs[0] == 'dec':
            return [dec(xs[1])] + parse_instructions(inp[1:])
        elif xs[0] == 'jnz':
            return [jnz(xs[1], xs[2])] + parse_instructions(inp[1:])
        else:
            raise ValueError('Unexpected instruction [%s]' % s)

def execute(machine, instructions):
    while machine.pc < len(instructions):
        instruction = instructions[machine.pc]
        instruction(machine)
    return machine

def register_or_constant(machine, unknown):
    if unknown in ('a', 'b', 'c', 'd'):
        return get_register(machine, unknown)
    else:
        return int(unknown)

def cpy(value, register):
    def f(m):
        v = register_or_constant(m, value)
        set_register(m, register, v)
        m.pc += 1
    return lambda m: f(m)

def inc(register):
    def f(m):
        v = get_register(m, register)
        set_register(m, register, v + 1)
        m.pc += 1
    return lambda m: f(m)

def dec(register):
    def f(m):
        v = get_register(m, register)
        set_register(m, register, v - 1)
        m.pc += 1
    return lambda m: f(m)

def jnz(value, delta):
    def f(m):
        v = register_or_constant(m, value)
        if v == 0:
            m.pc += 1
        else:
            m.pc += int(delta)
    return lambda m: f(m)

def get_register(machine, register):
    if register == 'a':
        return machine.a
    if register == 'b':
        return machine.b
    if register == 'c':
        return machine.c
    if register == 'd':
        return machine.d
    raise ValueError('Unexpected register %s' % register)

def set_register(machine, register, value):
    if register == 'a':
        machine.a = value
    elif register == 'b':
        machine.b = value
    elif register == 'c':
        machine.c = value
    elif register == 'd':
        machine.d = value
    else:
        raise ValueError('Unexpected register %s' % register)

inp = sys.stdin.readlines()
print('Step 1')
print(step1(inp))
print('This one is slow. Wait for it...', file=sys.stderr)
print('Step 2')
print(step2(inp))
