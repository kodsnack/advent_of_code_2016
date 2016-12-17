from heapq import heappush, heappop
from hashlib import md5

granted = ['b', 'c', 'd', 'e', 'f']
f = open('input_17.txt', 'r')
passcode = f.readline().rstrip()

frontier = [[0, 0, 0, passcode]]

while True:
	steps, x, y, passcode = heappop(frontier)
	
	if (x,y) == (3,3):
		print passcode[8:]
		break
	
	hash = md5(passcode).hexdigest()
	steps += 1
	
	if y > 0 and hash[0] in granted:
		heappush(frontier, [steps, x, y-1, passcode + 'U'])
	if y < 3 and hash[1] in granted:
		heappush(frontier, [steps, x, y+1, passcode + 'D'])
	if x > 0 and hash[2] in granted:
		heappush(frontier, [steps, x-1, y, passcode + 'L'])
	if x < 3 and hash[3] in granted:
		heappush(frontier, [steps, x+1, y, passcode + 'R'])