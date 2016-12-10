input = open('day6-input.txt','r')
input = zip(*[l.strip('\n') for l in input])

#Part 1
message = ''.join([max(set(col), key=col.count) for col in input])
print 'Part 1:', message

#Part 2
message = ''.join([min(set(col), key=col.count) for col in input])
print 'Part 2:', message
