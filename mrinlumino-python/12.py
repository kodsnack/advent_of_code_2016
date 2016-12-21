#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 12/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''




# ****************************************** challenge 1 ****************************************** 
print '********** Challenge 1 ************'

# Registry variables
a = 0
b = 0
c = 0
d = 0

# Open input data file and read it into a string
instructions=[]
fo = open('12.data','r')
for line in fo:
	instructions.append(line.replace('\n',''))
fo.close()

executionPointer = 0
while executionPointer < len(instructions):
	instruction = instructions[executionPointer].split(' ')

	# Handle the copy instruction
	if instruction[0] == 'cpy':
		# Copy the coreesponding value into the right registry
		try:
   			value = int(instruction[1])
		except ValueError:
   			if instruction[1] == 'a': value = a
   			if instruction[1] == 'b': value = b
   			if instruction[1] == 'c': value = c
   			if instruction[1] == 'd': value = d

		if instruction[2] == 'a': a = value
		if instruction[2] == 'b': b = value
		if instruction[2] == 'c': c = value
		if instruction[2] == 'd': d = value

	# Handle the Jump if not zero intruction
	increaseExecutionPointer = 1
	if instruction[0] == 'jnz':
		if instruction[1] == 'a':
			if a != 0: 
				executionPointer += int(instruction[2])
				increaseExecutionPointer = 0
		elif instruction[1] == 'b':
			if b != 0: 
				executionPointer += int(instruction[2])
				increaseExecutionPointer = 0
		elif instruction[1] == 'c':
			if c != 0: 
				executionPointer += int(instruction[2])
				increaseExecutionPointer = 0
		elif instruction[1] == 'd':
			if d != 0: 
				executionPointer += int(instruction[2])
				increaseExecutionPointer = 0
		else:
			if instruction[1] != '0': 
				executionPointer += int(instruction[2])
				increaseExecutionPointer = 0
	
	if increaseExecutionPointer == 1:
		executionPointer += 1

	# Handle the increase instruction
	if instruction[0] == 'inc':
		if instruction[1] == 'a': a += 1
		if instruction[1] == 'b': b += 1
		if instruction[1] == 'c': c += 1
		if instruction[1] == 'd': d += 1

	# Handle the decrese instruction
	if instruction[0] == 'dec':
		if instruction[1] == 'a': a += -1
		if instruction[1] == 'b': b += -1
		if instruction[1] == 'c': c += -1
		if instruction[1] == 'd': d += -1

print 'Challenge 1: Resulting value in registry A: %s' % a


# ****************************************** challenge 2 ****************************************** 
print '********** Challenge 2 ************'

# Registry variables
a = 0
b = 0
c = 1
d = 0

# Open input data file and read it into a string
instructions=[]
fo = open('12.data','r')
for line in fo:
	instructions.append(line.replace('\n',''))
fo.close()

executionPointer = 0
while executionPointer < len(instructions):
	instruction = instructions[executionPointer].split(' ')

	# Handle the copy instruction
	if instruction[0] == 'cpy':
		# Copy the coreesponding value into the right registry
		try:
   			value = int(instruction[1])
		except ValueError:
   			if instruction[1] == 'a': value = a
   			if instruction[1] == 'b': value = b
   			if instruction[1] == 'c': value = c
   			if instruction[1] == 'd': value = d

		if instruction[2] == 'a': a = value
		if instruction[2] == 'b': b = value
		if instruction[2] == 'c': c = value
		if instruction[2] == 'd': d = value

	# Handle the Jump if not zero intruction
	increaseExecutionPointer = 1
	if instruction[0] == 'jnz':
		if instruction[1] == 'a':
			if a != 0: 
				executionPointer += int(instruction[2])
				increaseExecutionPointer = 0
		elif instruction[1] == 'b':
			if b != 0: 
				executionPointer += int(instruction[2])
				increaseExecutionPointer = 0
		elif instruction[1] == 'c':
			if c != 0: 
				executionPointer += int(instruction[2])
				increaseExecutionPointer = 0
		elif instruction[1] == 'd':
			if d != 0: 
				executionPointer += int(instruction[2])
				increaseExecutionPointer = 0
		else:
			if instruction[1] != '0': 
				executionPointer += int(instruction[2])
				increaseExecutionPointer = 0
	
	if increaseExecutionPointer == 1:
		executionPointer += 1

	# Handle the increase instruction
	if instruction[0] == 'inc':
		if instruction[1] == 'a': a += 1
		if instruction[1] == 'b': b += 1
		if instruction[1] == 'c': c += 1
		if instruction[1] == 'd': d += 1

	# Handle the decrese instruction
	if instruction[0] == 'dec':
		if instruction[1] == 'a': a += -1
		if instruction[1] == 'b': b += -1
		if instruction[1] == 'c': c += -1
		if instruction[1] == 'd': d += -1

print 'Challenge 2: Resulting value in registry A: %s' % a

