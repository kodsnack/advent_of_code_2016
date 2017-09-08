import sys

memory = [0 for i in range(100)]
ptr = 0

#Define variables
variables = {'c':0, 'b':1, 's':2, 'd':3, 'N':4, 'S':5, 'E':6, 'W':7, 'L':8, 'R':9, 'C':10, 'T':11, 'q':12, 'z':13, 'u':14, 'v':15, 'w':16, 'x':17, 'a':18, 'e':19}
defaults = {'c':0, 'b':0, 's':0, 'd':0, 'N':0, 'S':0, 'E':0, 'W':0, 'L':ord('L'), 'R':ord('R'), 'C':ord(','), 'T':10, 'q':0, 'z':0, 'u':0, 'v':0, 'w':0, 'x':0, 'a':0, 'e':0}

#Define funcitons
def read(x): # x = input
    return x+'[-],'

def clear(x): # x = 0
    return x+'[-]'

def integer(x): # x = integer value of character x
    return x+'------------------------------------------------'

def setreg(x,y): # x = y
    if isinstance(y,int):
        return x+'[-]'+'+'*y
    else:
        return 'q[-]'+x+'[-]'+y+'['+x+'+q+'+y+'-]q['+y+'+q-]'
    
def add(x,y): # x = x + y
    if isinstance(y,int):
        return x+'+'*y
    else:
        return 'q[-]'+y+'['+x+'+q+'+y+'-]q['+y+'+q-]'

def sub(x,y): # x = x - y
    if isinstance(y,int):
        return x+'-'*y
    else:
        return 'q[-]'+y+'['+x+'-q+'+y+'-]q['+y+'+q-]'

def mul(x,y): # x = x * y
    return 'q[-]z[-]'+x+'[z+'+x+'-]z['+y+'['+x+'+q+'+y+'-]q['+y+'+q-]z-]'

def divmod(x,y): # x = x / y
    return 

def isequal(x,y): # x = x == y
    return 'q[-]z[-]'+x+'[z+'+x+'-]+'+y+'[z-q+'+y+'-]q['+y+'+q-]z['+x+'-z[-]]'

def isnotequal(x,y): # x = x != y
    return 'q[-]z[-]'+x+'[z+'+x+'-]'+y+'[z-q+'+y+'-]q['+y+'+q-]z['+x+'+z[-]]'

def islessthan(x,y): # x = x < y
    return 'q[-]z[-]>[-]+>[-]<<'+y+'[q+z+'+y+'-]z['+y+'+z-]'+x+'[z+'+x+'-]z[>-]>[<'+x+'+q[-]z>->]<+<q[z-[>-]>[<'+x+'+q[-]+z>->]<+<q-]'

def ifxelse(x, code1, code2): # if(x){code1}else{code2}
    return 'u[-]+v[-]'+x+'['+code1+'u-'+x+'[v+'+x+'-]]v['+x+'+v-]u['+code2+'u-]'

def ifx(x, code): # if(x){code}
    return 'w[-]x[-]'+x+'[w+x+'+x+'-]w['+x+'+w-]x['+code+'x[-]]'


def display(x):
    return x+'[>>+>+<<<-]>>>[<<<+>>>-]<<+>[<->[>++++++++++<[->-[>+>>]>[+[-<+>]>+>>]<<<<<]>[-]++++++++[<++++++>-]>[<<+>>-]>[<<+>>-]<<]>]<[->>++++++++[<++++++>-]]<[.[-]<]<'

def start_loop(x):
    return x+'['
def end_loop(x):
    return x+']'



#Move to memory position
def goto(c):
    global ptr
    if variables.has_key(c):
        if ptr-variables[c] > 0:
            for i in range(ptr-variables[c]):
                sys.stdout.write("<")
        elif ptr-variables[c] < 0:
            for i in range(variables[c]-ptr):
                sys.stdout.write(">")
        ptr = variables[c]

#Set default values
for k in variables.keys():
    goto(k)
    for i in range(defaults[k]):
        sys.stdout.write("+")
goto(0)
        
#Assemble code
code = read('c')+\
       start_loop('c')+\
        setreg('b','c')+\
        isequal('b','L')+\
        ifx('b',\
            clear('s')+\
            read('c')+\
            setreg('b','c')+\
            ifxelse('b',isnotequal('b','C'),'')+\
            start_loop('b')+\
             mul('s','T')+\
             integer('c')+\
             add('s','c')+\
             read('c')+\
             setreg('b','c')+\
             ifxelse('b',isnotequal('b','C'),'')+\
            end_loop('b')+\
            ifxelse('d',sub('d',1),setreg('d',3))+\
            setreg('b','d')+\
            clear('a')+\
            isequal('b','a')+\
            ifxelse('b',add('N','s'),'')+\
            setreg('b','d')+\
            'a+'+\
            isequal('b','a')+\
            ifxelse('b',add('E','s'),'')+\
            setreg('b','d')+\
            'a+'+\
            isequal('b','a')+\
            ifxelse('b',add('S','s'),'')+\
            setreg('b','d')+\
            'a+'+\
            isequal('b','a')+\
            ifxelse('b',add('W','s'),'') )+\
        setreg('b','c')+\
        isequal('b','R')+\
        ifx('b',\
            clear('s')+\
            read('c')+\
            setreg('b','c')+\
            ifxelse('b',isnotequal('b','C'),'')+\
            start_loop('b')+\
             mul('s','T')+\
             integer('c')+\
             add('s','c')+\
             read('c')+\
             setreg('b','c')+\
             ifxelse('b',isnotequal('b','C'),'')+\
            end_loop('b')+\
            setreg('a',3)+\
            isequal('a','d')+\
            ifxelse('a',clear('d'),add('d',1))+\
            setreg('b','d')+\
            clear('a')+\
            isequal('b','a')+\
            ifxelse('b',add('N','s'),'')+\
            setreg('b','d')+\
            'a+'+\
            isequal('b','a')+\
            ifxelse('b',add('E','s'),'')+\
            setreg('b','d')+\
            'a+'+\
            isequal('b','a')+\
            ifxelse('b',add('S','s'),'')+\
            setreg('b','d')+\
            'a+'+\
            isequal('b','a')+\
            ifxelse('b',add('W','s'),'') )+\
        read('c')+\
       end_loop('c')+\
       setreg('a','N')+\
       islessthan('a','S')+\
       ifxelse('a',sub('S','N')+setreg('N','S'),sub('N','S'))+\
       setreg('a','E')+\
       islessthan('a','W')+\
       ifxelse('a',sub('W','E')+setreg('E','W'),sub('E','W'))+\
       setreg('e','E')+\
       add('e','N')+\
       display('e')
       

#Parse code
for c in code:
    if c.isalpha():
        goto(c)            
    else:
        sys.stdout.write(c)
