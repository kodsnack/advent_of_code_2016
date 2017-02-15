
input = open('day12-input.txt','r')
input = [l.strip('\r\n').split(' ',1) for l in input]

registers = {'a':0, 'b':0, 'c':0, 'd':0}

def cpy(xy):
    #print 'cpy', xy
    x, y = xy.split(' ')
    if x in registers:
        registers[y] = registers[x]
    else:
        registers[y] = int(x)
    return 1

def inc(x):
    #print 'inc', x
    registers[x] += 1
    return 1

def dec(x):
    #print 'dec', x
    registers[x] -= 1
    return 1

def jnz(xy):
    #print 'jnz', xy
    x, y = xy.split(' ')
    if x in registers:
        c = registers[x]
    else:
        c = int(x)
    if not c==0:
        return int(y)
    return 1

def assembunny_eval(reg):
    i = 0
    while True:
        #print i,registers
        i += eval(input[i][0]+'(\''+input[i][1]+'\')')
        if not i in range(len(input)):
            break
    return registers[reg]
print 'Part 1:', assembunny_eval('a')

registers = {'a':0, 'b':0, 'c':1, 'd':0}
print 'Part 2:', assembunny_eval('a')
