
input = open('day25-input.txt','r')
input = [l.strip('\r\n').split(' ',1) for l in input]

registers = {'a':0, 'b':0, 'c':0, 'd':0}

def cpy(xy,i):
    x, y = xy.split(' ')

    #Detect multiply case
    if i+5 < len(input):
        if input[i+1][0] == 'inc' and input[i+2][0] == 'dec' and input[i+3][0] == 'jnz' and input[i+4][0] == 'dec' and input[i+5][0] == 'jnz':
            if input[i+2][1] == input[i+3][1][0] and input[i+4][1] == input[i+5][1][0]:
                if x.isdigit():
                    registers[input[i+1][1]] += int(x)*registers[input[i+4][1]]
                else:
                    registers[input[i+1][1]] += registers[x]*registers[input[i+4][1]]
                registers[input[i+2][1]] = 0
                registers[input[i+4][1]] = 0
                return 6

    #print 'cpy', xy    
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

toggle_table = {'inc':'dec','dec':'inc','tgl':'inc','jnz':'cpy','cpy':'jnz','out':'inc'}

def tgl(x,i):
    #print 'tgl', x
    toggle = i + registers[x]
    if toggle >= len(input):
        return 1
    input[toggle][0] = toggle_table[input[toggle][0]]
    return 1

#clock signal if count is high (assume 1000)
count = 0
valid = True
o_last = ''
def out(x, i):
    global count
    global valid
    global o_last
    o = 0
    if x in registers:
        o = registers[x]
    else:
        o = int(x)
    if o_last == '':
        pass
    elif (o_last == 0 and o == 1) or (o == 0 and o_last == 1):
        pass
    else:
        valid = False
    #print o,count
    count += 1
    o_last = o
    if count > 1000:
        return 100
    elif not valid:
        return 100
    else:
        return 1

def assembunny_eval(reg):
    global count
    global o_last
    global valid
    count = 0
    o_last = ''
    valid = True
    i = 0
    while True:
        #print i, input[i],registers
        i += eval(input[i][0]+'(\''+input[i][1]+'\',i)')
        if count > 1000 and valid:
            return True
        if not i in range(len(input)):
            break
    return False#registers[reg]

integer = 1
while not assembunny_eval(registers):
    integer += 1
    print integer
    input = open('day25-input.txt','r')
    input = [l.strip('\r\n').split(' ',1) for l in input]
    registers = {'a':integer, 'b':0, 'c':0, 'd':0}
print 'Part 1:', integer


