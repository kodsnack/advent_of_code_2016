import re

input = open('day22-input.txt','r')
input = ''.join([i for i in input])
input = re.findall('(?<=/dev/grid/node-x)[0-9]{1,}-y[0-9]{1,}\s{1,}[0-9]{1,}T\s{1,}[0-9]{1,}',input)
input = [[int(j) for j in re.split('-y|\s{1,}|T\s{1,}',i)] for i in input if i]

start_node = input[-1]
A = 0
viable_pairs = 0
while A != start_node:
    #Pop node from list
    A = input.pop(0)
    #Check if empty
    if A[3] != 0:
        #Check with other nodes (A not in list)
        for B in input:
            if A[3] <= B[2] - B[3]:
                viable_pairs += 1            
    #Insert at end of list
    input.append(A)

print 'Part 1:', viable_pairs
