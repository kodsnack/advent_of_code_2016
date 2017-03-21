import re

input = open('day21-input.txt','r')
input = [l.strip('\n') for l in input]

patterns = ['(?<=swap position )[0-9]|(?<= with position )[0-9]', 
            '(?<=swap letter )[a-z]|(?<= with letter )[a-z]', 
            '(?<=rotate )right|(?<=rotate )left|(?<= )[0-9](?= step)',
            '(?<=rotate based on position of letter )[a-z]', 
            '(?<=reverse positions )[0-9]|(?<= through )[0-9]', 
            '(?<=move position )[0-9]|(?<= to position )[0-9]']

functions = ['swap_pos','swap_let','rotate_dir','rotate_pos','reverse_pos','move_pos']

#Swap position a with position b
def swap_pos(a,b,p):
    #print p
    #global password
    letter_a = p[int(a)]
    letter_b = p[int(b)]
    p[int(a)] = letter_b
    p[int(b)] = letter_a
    #print p
    
#Swap letter a with letter b
def swap_let(a,b,p):
    #print p
    #global password
    position_a = p.index(a)
    position_b = p.index(b)
    letter_a = p[position_a]
    letter_b = p[position_b]
    p[position_a] = letter_b
    p[position_b] = letter_a
    #print p

#Rotate direction a b steps
def rotate_dir(a,b,p):
    #print p
    p_old = list(p)
    #global password
    for i in range(len(p)):
        if a == 'left':
            p[i] = p_old[(i+int(b))%len(p)]
        else:
            p[(i+int(b))%len(p)] = p_old[i]
    #print p
        
#Rotate based on pos a
def rotate_pos(a,p):
    #print p
    #global password
    p_old = list(p)
    position = p.index(a)
    if position >= 4:
        position += 2
    else:
        position += 1
    for i in range(len(p)):
        p[(i+position)%len(p)] = p_old[i]
    #print p
        
#Reverse position a through b
def reverse_pos(a,b,p):
    #print p
    #global password
    p_old = list(p)
    for i in range(int(b)-int(a)+1):
        p[i+int(a)] = p_old[int(b)-i]
        #print p
    #print p
    
#Move position a to position b
def move_pos(a,b,p):
    #print p
    #global password
    letter = p[int(a)]
    p_new = list(p)
    p_new = p_new[:int(a)] + p_new[int(a)+1:]
    p_new = p_new[:int(b)] + [letter] + p_new[int(b):]
    for i in range(len(p)):
        p[i] = p_new[i]
    #print p

def scramble(password,  patterns, input):
    password = list(password)
    for line in input:
        #print line
        m = [re.findall(p, line) for p in patterns]
        i = next(i for i,j in enumerate(m) if j)
        eval(functions[i]+'(\''+'\',\''.join(m[i])+'\', password)')
    return ''.join(password)


print 'Part 1:', scramble('abcdefgh',patterns,input)

