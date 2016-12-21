from hashlib import md5

f = open('input_14.txt', 'r')

salt = f.readline().rstrip()
keys = []
key_target = 64
very_big = 1000000000
last = {'a': [-1001], 'b': [-1001], 'c': [-1001], 'd': [-1001], 'e': [-1001], 'f': [-1001]}
for i in xrange(10):
	last[str(i)] = [-1001]

index = 0
while True:
	hash = md5(salt+str(index)).hexdigest()
	for x in xrange(2016):
		hash = md5(hash).hexdigest()
	l = len(hash)
	triplet = ''
	quintuplet = ''
	
	for x in xrange(l-2):
		if not triplet and hash[x] == hash[x+1] == hash[x+2]:
			triplet = hash[x]
		if x < l-4 and len(set(hash[x:x+5])) == 1:
			quintuplet = hash[x]
			break
			
	if quintuplet:
		triplets = last[quintuplet]
		very_big_candidate = triplets[-1]
		while len(triplets) > 0:			
			candidate = triplets.pop()
			if index - candidate <= 1000:
				keys.append(candidate)
				if len(keys) == key_target:
					very_big = very_big_candidate + 999
					
	if index > very_big:
		break
		
	if triplet:
		last[triplet].append(index)
		
	index += 1
	
print sorted(keys)[63]