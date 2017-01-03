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

debug = open('out.txt','w')
def evaluate_all(input_state, goal_state):
    distance = {input_state:0}
    queue = [input_state]
    
    while queue:
        state = queue.pop(0)
        debug.write(state+'\n')
        #print state, distance[state], get_valid_next_states(state)
        for s in get_valid_next_states(state):
            if s == goal_state:
                return distance[state]+1
            if s not in distance and s not in queue:
                distance[s] = distance[state]+1
                queue.append(s)
    return distance[goal_state]


def visit_level(queue, last_level, goal_state):
    #Queue, Last- and Current-level contains tuples with (state, distance)
    current_level = []
    current_depth = queue[0][1]

    while queue:
        #If the first state in queue is at a depth of one more than current, then return
        if queue[0][1] > current_depth:
            return current_level
        
        #Pop a floor state from the queue
        state = queue.pop(0)
        current_level.append(state)
        #print 'State:', state[0], 'Depth:', state[1], 'Queue length:', len(queue), 'List lenghts:', len(queue)+len(current_level)+len(last_level)
        for s in get_valid_next_states(state[0]):
            if s == goal_state:
                return s, current_depth+1
            if s not in last_level and s not in current_level and s not in queue:
                queue.append((s,current_depth+1))
    return 0



#print 'Part 1:', evaluate_all(input, goal)

queue = [(input, 0)]
current_level = []
while True:
    print len
    current_level = visit_level(queue, current_level, goal)
    if type(current_level) is not list:
        print 'Part1:', current_level
        break

#Part 2, New parts
#An elerium generator.
#An elerium-compatible microchip.
#A dilithium generator.
#A dilithium-compatible microchip.
input += ' eg1 em1 dg1 dm1'
goal += ' eg4 em4 dg4 dm4'
#print 'Part 2:', evaluate_all(input, goal)
