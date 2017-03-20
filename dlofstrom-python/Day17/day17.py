from hashlib import md5
import re

input = 'gdjjyniy'

path_queue = ['']

count = 0

while path_queue:
    #Pop path from bfs queue
    current_path = path_queue.pop(0)

    #Hash current path to get reachable rooms
    current_hash = list(md5(input+current_path).hexdigest()[0:4])

    #Add open doors to queue if position in room is valid
    next_paths = [current_path+['U','D','L','R'][i] for i,e in enumerate(current_hash) if e in 'bcdef']
    for n in next_paths:
        n_position = (sum([-1 if x=='L' else 1 if x=='R' else 0 for x in n]), sum([-1 if x=='U' else 1 if x=='D' else 0 for x in n]))
        if n_position == (3,3):
            print 'Part 1:', n
            path_queue = []
            break
        elif n_position[0] in range(4) and n_position[1] in range(4):
            path_queue.append(n)
    
        
    

