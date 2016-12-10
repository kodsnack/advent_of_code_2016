from itertools import permutations
input = open('day3-input.txt','r')
#Split into list with three numbers in each element
input = [[int(n) for n in r.strip('\n').split(' ') if not n==''] for r in input]

possible = sum([1 if [p[0]+p[1]>p[2] for p in permutations(i)].count(False)==0 else 0 for i in input])

print 'Part 1:', possible
