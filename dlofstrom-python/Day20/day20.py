input = open('day20-input.txt','r')
input = [[int(i) for i in l.strip('\n').split('-')] for l in input]
input.sort(key=lambda x: x[0])

#Part 1
allowed = 0
for l in input:
    if l[0] <= allowed:
        allowed = l[1]+1
    else:
        break
print 'Part 1:', allowed
