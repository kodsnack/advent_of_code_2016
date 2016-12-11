from itertools import permutations, combinations
input = open('day3-input.txt','r')
#Split into list with three numbers in each element
input = [[int(n) for n in r.strip('\n').split(' ') if not n==''] for r in input]

#Part 1
possible = sum([1 if [p[0]+p[1]>p[2] for p in permutations(i)].count(False)==0 else 0 for i in input])

print 'Part 1:', possible


#Part 2
possible = 0
for column in zip(*input):
    for set in zip(*[column[i::3] for i in range(3)]):
        if [p[0]+p[1]>p[2] for p in permutations(set)].count(False)==0:
            possible += 1

print 'Part 2:', possible
