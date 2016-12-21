from hashlib import md5

granted = ['b', 'c', 'd', 'e', 'f']
f = open('input_17.txt', 'r')
passcode = f.readline().rstrip()

frontier = [[0, 0, 0, passcode]]
longest = 0

while len(frontier) > 0:
	steps, x, y, passcode = frontier.pop()
	
	if (x,y) == (3,3):
		longest = max(longest, steps)
		continue
	
	hash = md5(passcode).hexdigest()
	steps += 1
	
	if y > 0 and hash[0] in granted:
		frontier.append([steps, x, y-1, passcode + 'U'])
	if y < 3 and hash[1] in granted:
		frontier.append([steps, x, y+1, passcode + 'D'])
	if x > 0 and hash[2] in granted:
		frontier.append([steps, x-1, y, passcode + 'L'])
	if x < 3 and hash[3] in granted:
		frontier.append([steps, x+1, y, passcode + 'R'])
		
print longest