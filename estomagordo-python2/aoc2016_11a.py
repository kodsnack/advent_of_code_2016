from heapq import heappush, heappop
from itertools import combinations
	
def number_element(elements, element):
	if element in elements:
		return elements[element]
	score = 2**(len(elements))
	elements[element] = score
	return score
	
def illegal(state):
	for x in xrange(4):
		if state[2*x+1] > 0:
			chips = [exp for exp in exponents if (state[2*x] & exp) == exp]
			generators = [exp for exp in exponents if (state[2*x+1] & exp) == exp]
			if any(chip not in generators for chip in chips):
				return True
	return False
	
f = open('input_11.txt', 'r')

state = []
elements = {}
for line in f:
	floor_chip_value = floor_generator_value = 0
	row = []
	rowparts = line[:-2].split(',')
	
	for part in rowparts:
		partsplit = part.split()
		row += partsplit
		
	floorlen = len(row)
	for x in xrange(floorlen):
		word = row[x]	
		if word == 'microchip':
			element = row[x-1].split('-')[0]
			floor_chip_value += number_element(elements, element)
		if word == 'generator':
			element = row[x-1]
			floor_generator_value += number_element(elements, element)
			
	state.append(floor_chip_value)
	state.append(floor_generator_value)
			
seen = set()
state.append(0)
clear_bottom = [0 for x in xrange(6)]
exponents = [2**x for x in xrange(12)]
frontier = [[0, state, tuple(state)]]
while True:
	steps, state, tupstate = heappop(frontier)
	elevator = state[-1]
	
	if tupstate in seen:
		continue
		
	seen.add(tupstate)
	
	if illegal(state):
		continue
	
	if state[:6] == clear_bottom:
		print steps
		break
		
	steps += 1
	
	directions = [1] if elevator == 0 else [-1] if elevator == 3 else [1,-1]
	for direction in directions:
		pos = elevator+direction
		chips = [exp for exp in exponents if (state[2*elevator] & exp) == exp]
		generators = [exp for exp in exponents if (state[2*elevator+1] & exp) == exp]
		if direction > 0 and len(chips) > 1:
			for c in combinations(chips, 2):
				newstate = list(state)
				newstate[-1] = pos
				for chip in c:
					newstate[2*elevator] -= chip
					newstate[2*pos] += chip				
				tupstate = tuple(newstate)
				if not tupstate in seen:
					heappush(frontier, [steps, newstate, tupstate])
		if len(chips) > 0:
			for chip in chips:
				newstate = list(state)
				newstate[-1] = pos
				newstate[2*elevator] -= chip
				newstate[2*pos] += chip				
				tupstate = tuple(newstate)
				if not tupstate in seen:
					heappush(frontier, [steps, newstate, tupstate])
		if direction > 0 and len(generators) > 1:
			for c in combinations(generators, 2):
				newstate = list(state)
				newstate[-1] = pos
				for generator in c:
					newstate[2*elevator+1] -= generator
					newstate[2*pos+1] += generator				
				tupstate = tuple(newstate)
				if not tupstate in seen:
					heappush(frontier, [steps, newstate, tupstate])
		if len(generators) > 0:
			for generator in generators:
				newstate = list(state)
				newstate[-1] = pos
				newstate[2*elevator+1] -= generator
				newstate[2*pos+1] += generator				
				tupstate = tuple(newstate)
				if not tupstate in seen:
					heappush(frontier, [steps, newstate, tupstate])
		if direction > 0 and len(chips) > 0 and len(generators) > 0:
			for value in chips:
				if not value in generators:
					continue
				newstate = list(state)
				newstate[-1] = pos
				newstate[2*elevator] -= value
				newstate[2*pos] += value	
				newstate[2*elevator+1] -= value
				newstate[2*pos+1] += value				
				tupstate = tuple(newstate)
				if not tupstate in seen:
					heappush(frontier, [steps, newstate, tupstate])