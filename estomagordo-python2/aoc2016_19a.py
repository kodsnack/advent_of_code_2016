def do_round(elves):
	l = len(elves)
	r = xrange(0,l,2) if l%2 == 0 else xrange(2,l,2)
	return [elves[x] for x in r]

f = open('input_19.txt', 'r')
n = int(f.readline())
elves = [x for x in xrange(1,n+1)]

while len(elves) > 1:
	elves = do_round(elves)
	
print elves[0]