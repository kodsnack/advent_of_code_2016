import re
import itertools
input = open('day11-input.txt','r')
input = [re.split(' contains ', l.strip('\r\n')) for l in input]

#Part 1
input = [re.findall(r'((?<=a )\w+(?= generator))|((?<=a )\w+(?=-compatible microchip))',l[1]) for l in input]
input = ' '.join(['e1'] + sorted([x[0][0]+'g'+str(i+1) if x[1]=='' else x[1][0]+'m'+str(i+1) for i,l in enumerate(input) for x in l]))

def is_valid(state):
    state_list = state.split(' ')
    if int(state_list[0][-1]) not in range(1,5):
        return False
    gs = [int(x[-1]) for x in state_list[1::2]]
    for i,m in enumerate([int(x[-1]) for x in state_list[2::2]]):
        if not gs[i]==m and m in gs:
            return False
    return True
            
def get_possible(state):
    state_list = state.split(' ')
    return [(state_list[0],)+x for x in list(itertools.combinations(['empty']+[x for x in state_list[1:] if x[-1]==state_list[0][-1]],2))]

def next_state(state, items, dir):
    state_list = state.split(' ')
    return ' '.join([x[:-1]+str(int(x[-1])+dir) if x in items else x for x in list(state_list)])

def get_valid_next_states(state):
    return [next_state(state, p, d) for d in [-1,1] for p in get_possible(state) if is_valid(next_state(state, p, d))]
    

goal = ''.join(['4' if c.isdigit() else c for c in input])

def evaluate_all(input_state, goal_state):
    distance = {input_state:0}
    queue = [input_state]
    
    while queue:
        state = queue.pop(0)
        #print state, distance[state], get_valid_next_states(state)
        for s in get_valid_next_states(state):
            if s not in distance and s not in queue:
                distance[s] = distance[state]+1
                queue.append(s)
                #print queue
    return distance[goal_state]
                
print 'Part 1:', evaluate_all(input, goal)
