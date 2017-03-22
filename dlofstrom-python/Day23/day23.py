
input = open('day23-input.txt','r')
input = [l.strip('\r\n').split(' ',1) for l in input]

registers = {'a':7, 'b':0, 'c':0, 'd':0}

def cpy(xy,i):
    #print 'cpy', xy
    x, y = xy.split(' ')
    if y not in registers:
        return 1
    if x in registers:
        registers[y] = registers[x]
    else:
        registers[y] = int(x)
    return 1

def inc(x,i):
    #print 'inc', x
    registers[x] += 1
    return 1

def dec(x,i):
    #print 'dec', x
    registers[x] -= 1
    return 1

def jnz(xy,i):
    #print 'jnz', xy
    x, y = xy.split(' ')
    if x in registers:
        c = registers[x]
    else:
        c = int(x)
    if not c==0:
        if y in registers:
            return registers[y]
        else:
            return int(y)
    return 1

toggle_table = {'inc':'dec','dec':'inc','tgl':'inc','jnz':'cpy','cpy':'jnz'}

def tgl(x,i):
    #print 'tgl', x
    global input
    global toggle_table
    toggle = i + registers[x]
    if toggle >= len(input):
        return 1
    input[toggle][0] = toggle_table[input[toggle][0]]
    return 1

def assembunny_eval(reg):
    i = 0
    while True:
        #print i,registers
        i += eval(input[i][0]+'(\''+input[i][1]+'\',i)')
        if not i in range(len(input)):
            break
    return registers[reg]
print 'Part 1:', assembunny_eval('a')

