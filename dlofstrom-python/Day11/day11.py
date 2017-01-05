import re
import itertools
input = open('day11-input.txt','r')
input = [re.split(' contains ', l.strip('\r\n')) for l in input]

#Part 1
input = [re.findall(r'((?<=a )\w+(?= generator))|((?<=a )\w+(?=-compatible microchip))',l[1]) for l in input]

input = ''.join(['1'] + sorted([str(i+1) for i,l in enumerate(input) for x in l]))

def is_valid(state):
    if int(state[0]) not in range(1,5):
        return False
    gs = [int(x) for x in state[1::2]]
    for i,m in enumerate([int(x) for x in state[2::2]]):
        if not gs[i]==m and m in gs:
            return False
    return True

def get_possible_next_states(state):
    #remember 1 item only
    [(0,)+c for c in list(itertools.combinations(range(1,len(state)),2))]
    ''.join([str(int(c)+1) if i in x else c for i,c in enumerate(s)])
    return [(state_[0],)+x for x in list(itertools.combinations(['empty']+[x for x in state_list[1:] if x[-1]==state_list[0][-1]],2))]

def get_valid_next_states(state):
    return [s for s in get_possible_next_states(state) if is_valid(s)]
    

goal = ''.join(['4' if c.isdigit() else c for c in input])

def breadth_first(input_state, goal_state):
    distance = {input_state:0}
    queue = [input_state]
    current_depth = 0
    while queue:
        state = queue.pop(0)
        if distance[state] > current_depth:
            print 'Purge all distances less than', distance[state]-2
            print 'Distance length Before:', len(distance),
            distance = {k:distance[k] for k in distance if distance[k]>distance[state]-2}
            print 'Distance length After:', len(distance)
            print 'Queue length:', len(queue)
            current_depth = distance[state]
        for s in get_valid_next_states(state):
            if s == goal_state:
                return distance[state]+1
            if s not in distance and s not in queue:
                distance[s] = distance[state]+1
                queue.append(s)


print 'Part 1:', breadth_first(input, goal)

#Part 2, New parts
#An elerium generator.
#An elerium-compatible microchip.
#A dilithium generator.
#A dilithium-compatible microchip.
input += '1111'
goal += '4444'
#print 'Part 2:', breadth_first(input, goal)
