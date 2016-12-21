import re
import itertools
input = open('day11-input.txt','r')
input = [re.split(' contains ', l.strip('\r\n')) for l in input]

#Part 1
input = [re.findall(r'((?<=a )\w+(?= generator))|((?<=a )\w+(?=-compatible microchip))',l[1]) for l in input]
input = ['e0'] + sorted([x[0][0]+'g'+str(i) if x[1]=='' else x[1][0]+'m'+str(i) for i,l in enumerate(input) for x in l])

def is_valid(state):
    if int(state[0][-1]) not in range(4):
        return False
    gs = [int(x[-1]) for x in state[1::2]]
    for i,m in enumerate([int(x[-1]) for x in state[2::2]]):
        if not gs[i]==m and m in gs:
            return False
    return True
            
def get_possible(state):
    return [(state[0],)+x for x in list(itertools.combinations(['empty']+[x for x in state[1:] if x[-1]==state[0][-1]],2))]

def next_state(state, items, dir):
    return [x[:-1]+str(int(x[-1])+dir) if x in items else x for x in list(state)]


moves = {}
best = 100000000000000
def test(state, n):
    #If done
    if all([i[-1] == '3' for i in state]):
        if n < best:
            best = n
    else:
        return 1


print is_valid(next_state(input, get_possible(input)[0], 1))

