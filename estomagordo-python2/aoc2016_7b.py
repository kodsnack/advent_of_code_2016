f = open('input_7.txt', 'r')

ssl_count = 0

def is_bab(abas, trigraph):
	bab_candidate = trigraph[1] + trigraph[0] + trigraph[1]
	return any(aba == bab_candidate for aba in list(abas))

for line in f:
	l = len(line.rstrip())
	abas_found = set()
	bab_found = False
	
	for repeats in xrange(2):		
		in_brackets = False
		for x in xrange(l-2):
			trigraph = line[x:x+3]
			if trigraph[0] != trigraph[1] and trigraph[0] == trigraph[2]:
				if in_brackets:
					if is_bab(abas_found, trigraph):
						bab_found = True
						break				
				else:
					abas_found.add(trigraph)
			if line[x] == '[':
				in_brackets = True
			elif line[x] == ']':
				in_brackets = False
	
	if bab_found:
		ssl_count += 1
		
print ssl_count