input = open('day20-input.txt','r')
input = [[int(i) for i in l.strip('\n').split('-')] for l in input]
input.sort(key=lambda x: x[0])

#Generate a non overlapping list of blocked IP ranges
no = []
r = [0,0]
for l in input:
    print l
    if l[0] <= r[1]+1:
        r[1] = max(l[1],r[1])
    else:
        print 'adding', r
        no.append(r)
        r = l
no.append(r)

#Generate list of valid IPs
valid_ips = []
for i in range(len(no)-1):
    valid_ips += range(no[i][1]+1, no[i+1][0])


print 'Part 1:', valid_ips[0]
print 'Part 2:', len(valid_ips)
