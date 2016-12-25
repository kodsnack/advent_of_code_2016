import sys


class Machine():
    def __init__(self, a, b, c, d, pc):
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.pc = pc
        self.signal = []


def step1(inp):
    i = 0
    while True:
        copied_list = inp[:]
        m = Machine(i, 0, 0, 0, 0)
        if execute(m, copied_list):
            return i
        i += 1


def execute(m, instructions):
    while m.pc < len(instructions):
        xs = instructions[m.pc].strip().split()
        if try_mul(m, instructions[m.pc:]):
            continue
        if xs[0] == 'cpy':
            cpy(m, xs[1], xs[2])
        elif xs[0] == 'inc':
            inc(m, xs[1])
        elif xs[0] == 'dec':
            dec(m, xs[1])
        elif xs[0] == 'jnz':
            jnz(m, xs[1], xs[2])
        elif xs[0] == 'tgl':
            tgl(m, xs[1], instructions)
        elif xs[0] == 'out':
            out(m, xs[1])
            if not valid_signal(m):
                return False
            if len(m.signal) > 50:
                # We need a heuristic here since there is no way for a program to solve 
                # this without being able to solve the halting problem which is impossible.
                return True
        else:
            raise ValueError('Unexpected instruction [%s]' % inp[0])


def valid_signal(m):
    if not m.signal:
        return True
    a = m.signal[0]
    if a != 0 and a != 1:
        return False
    for b in m.signal[1:]:
        if b != (a + 1) % 2:
            return False
        a = b
    return True


def out(m, unknown):
    v = register_or_constant(m, unknown)
    m.signal += [v]
    m.pc += 1


def try_mul(m, instructions):
    if len(instructions) < 6:
        return False
    inst0 = instructions[0].strip().split()
    inst1 = instructions[1].strip().split()
    inst2 = instructions[2].strip().split()
    inst3 = instructions[3].strip().split()
    inst4 = instructions[4].strip().split()
    inst5 = instructions[5].strip().split()
    if inst0[0] == 'cpy' and \
            inst1[0] == 'inc' and \
            inst2[0] == 'dec' and \
            inst3[0] == 'jnz' and \
            inst4[0] == 'dec' and \
            inst5[0] == 'jnz' and \
            register_or_constant(m, inst3[2]) == -2 and \
            register_or_constant(m, inst5[2]) == -5 and \
            inst0[2] == inst3[1] and \
            inst2[1] == inst3[1] and \
            inst4[1] == inst5[1] and \
            len({inst1[1],  inst2[1], inst4[1]}) == 3 and \
            get_register(m, inst0[2]) >= 0 and \
            get_register(m, inst4[1]) >= 0:
        m.pc += 5
        set_register(m, inst1[1], get_register(m, inst1[1]) + (register_or_constant(m, inst0[1]) * get_register(m, inst4[1])))
        set_register(m, inst2[1], 0)
        set_register(m, inst4[1], 0)
        return True
        
    return False


def register_or_constant(machine, unknown):
    if is_constant(unknown):
        return int(unknown)
    else:
        return get_register(machine, unknown)


def is_constant(unknown):
    return unknown not in ('a', 'b', 'c', 'd')


def cpy(m, value, register):
    v = register_or_constant(m, value)
    if not is_constant(register):
        set_register(m, register, v)
    m.pc += 1


def inc(m, register):
    if not is_constant(register):
        v = get_register(m, register)
        set_register(m, register, v + 1)
    m.pc += 1


def dec(m, register):
    if not is_constant(register):
        v = get_register(m, register)
        set_register(m, register, v - 1)
    m.pc += 1


def jnz(m, value, delta):
    v = register_or_constant(m, value)
    d = register_or_constant(m, delta)
    if v == 0:
        m.pc += 1
    else:
        m.pc += int(d)


def tgl(m, unknown, instructions):
    v = register_or_constant(m, unknown)
    if m.pc + v >= 0 and m.pc + v < len(instructions):
        instruction = instructions[m.pc + v].strip().split()
        if len(instruction) == 2:
            if instruction[0] == 'inc':
                instructions[m.pc + v] = 'dec %s' % (instruction[1])
            else:
                instructions[m.pc + v] = 'inc %s' % (instruction[1])
        else:
            assert(len(instruction) == 3)
            if instruction[0] == 'jnz':
                instructions[m.pc + v] = 'cpy %s %s' % (instruction[1], instruction[2])
            else:
                instructions[m.pc + v] = 'jnz %s %s' % (instruction[1], instruction[2])
    m.pc += 1



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
print(step1(inp))
