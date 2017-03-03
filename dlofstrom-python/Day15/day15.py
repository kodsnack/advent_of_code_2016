import re

input = open('day15-input.txt','r')
#Filter wheel number, number of positions, time and position
input = [re.findall('[0-9]{1,}',l.strip('\r\n')) for l in input]
#Offset wheels based on when it is reached
position = [[int(w[1]), int(w[3])+int(w[0])-int(w[2])] for w in input]

print position

time = 0
plist = [1,1]
while plist.count(1) > 0:
    plist = [0 if p[1]+time % p[0] == p[0] else 1 for p in position]#.count(1) > 0:
    print plist
    time += 1

print time

print input




print [0,0,0].count(0) == len([0,0,0])
