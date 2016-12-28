import sys


class Machine():
    def __init__(self, a, b, c, d, pc):
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.pc = pc


    def __hash__(self):
        return hash((self.a, self.b, self.c, self.d, self.pc))


    def __eq__(self, other):
        return (self.a, self.b, self.c, self.d, self.pc) == (other.a, other.b, other.c, other.d, other.pc)


    def copy(self):
        return Machine(self.a, self.b, self.c, self.d, self.pc)


def solve(inp):
    i = 0
    while True:
        copied_list = inp[:]
        m = Machine(i, 0, 0, 0, 0)
        if execute(m, copied_list):
            return i
        i += 1


def execute(m, instructions):
    visited = set()
    signal = []
    while m.pc < len(instructions):
        xs = instructions[m.pc].strip().split()
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
            out(m, signal, xs[1])
            if not valid_signal(signal):
                return False
            m_copy = m.copy()
            if (m_copy, tuple(instructions)) in visited:
                return True
            visited |= {(m_copy, tuple(instructions))}
        else:
            raise ValueError('Unexpected instruction [%s]' % inp[0])


def valid_signal(signal):
    if not signal:
        return True
    a = signal[0]
    if a != 0 and a != 1:
        return False
    for b in signal[1:]:
        if b != (a + 1) % 2:
            return False
        a = b
    return True


def out(m, signal, unknown):
    v = register_or_constant(m, unknown)
    signal.append(v)
    m.pc += 1


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
print(solve(inp))
