from hashlib import md5

input = 'gdjjyniy'

def get_next_paths(cp):
    ch = list(md5(input+cp).hexdigest()[0:4])
    np = [cp+['U','D','L','R'][i] for i,e in enumerate(ch) if e in 'bcdef']
    return [n for n in np if (sum([-1 if x=='L' else 1 if x=='R' else 0 for x in n]) in range(4) and sum([-1 if x=='U' else 1 if x=='D' else 0 for x in n]) in range(4))]

def is_goal(p):
    return [sum(a) for a in zip(*[(-1,0) if x=='L' else (1,0) if x=='R' else (0,-1) if x=='U' else (0,1) if x=='D' else (0,0) for x in p])] == [3,3]

#Part 1
path_queue = ['']
while path_queue:
    current_path = path_queue.pop(0)
    if is_goal(current_path):
        print 'Part 1:', current_path
        break
    path_queue += get_next_paths(current_path)


#Part 2
path_queue = ['']
path_lengths = []
while path_queue:
    current_path = path_queue.pop(0)
    if is_goal(current_path):
        path_lengths.append(len(current_path))
    else:
        path_queue += get_next_paths(current_path)
print 'Part 2:', max(path_lengths)


