import re

input = open('day15-input.txt','r')
#Filter wheel number, number of positions, time and position
input = [re.findall('[0-9]{1,}',l.strip('\r\n')) for l in input]
#Offset wheels based on when it is reached
position = [[int(w[1]), int(w[3])+int(w[0])-int(w[2])] for w in input]

time = 0
while [0 if (p[1]+time) % p[0] == 0 else 1 for p in position].count(1) > 0:
    time += 1
    
print 'Part 1:', time
