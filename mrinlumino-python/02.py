#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 2/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''

# Open input data file and read it into a string
lines=[]
fo = open('02.data','r')
for line in fo:
	lines.append(line)
	#print ('>%s') % line
fo.close()

# ****************************************** challenge 1 ****************************************** 


# Initial values
activeKey = '5'
keyCode = ''

# Iterate over the input data, one line at a time
for line in lines:
	# Iterate over one line and execute the move commands
	for char in line:
		#This will make you end up at key 1
		if (char == 'U' and activeKey == '4') or (char == 'L' and activeKey == '2'): 
			activeKey = '1'
		#This will make you end up at key 2
		elif (char == 'U' and activeKey == '5') or (char == 'R' and activeKey == '1') or (char == 'L' and activeKey=='3'):
			activeKey = '2'
		#This will make you end up at key 3
		elif (char == 'U' and activeKey == '6') or (char == 'R' and activeKey == '2'):
			activeKey = '3'
		#This will make you end up at key 4
		elif (char == 'U' and activeKey == '7') or (char == 'L' and activeKey == '5') or (char == 'D' and activeKey=='1'):
			activeKey = '4'		
		#This will make you end up at key 5
		elif (char == 'U' and activeKey == '8') or (char == 'R' and activeKey == '4') or (char == 'L' and activeKey=='6')or (char == 'D' and activeKey=='2'):
			activeKey = '5'		
		#This will make you end up at key 6
		elif (char == 'U' and activeKey == '9') or (char == 'R' and activeKey == '5') or (char == 'D' and activeKey=='3'):
			activeKey = '6'	
		#This will make you end up at key 7
		elif (char == 'D' and activeKey == '4') or (char == 'L' and activeKey == '8') :
			activeKey = '7'		
		#This will make you end up at key 8
		elif (char == 'D' and activeKey == '5') or (char == 'R' and activeKey == '7') or (char == 'L' and activeKey=='9'):
			activeKey = '8'		
		#This will make you end up at key 9
		elif (char == 'D' and activeKey == '6') or (char == 'R' and activeKey == '8'):
			activeKey = '9'
	# Add the key you ended up at to the final key code
	keyCode = keyCode + str(activeKey)
	
print ('Key code (challenge 1): %s') % keyCode


# ****************************************** challenge 2 ****************************************** 

# Initial values
activeKey = '5'
keyCode = ''

# Iterate over the input data, one line at a time
for line in lines:
	for char in line:
		#This will make you end up at key 1
		if (char == 'U' and activeKey == '3'): 
			activeKey = '1'
		#This will make you end up at key 2
		elif (char == 'U' and activeKey == '6') or (char == 'L' and activeKey == '3'):
			activeKey = '2'
		#This will make you end up at key 3
		elif (char == 'D' and activeKey == '1') or (char == 'R' and activeKey == '2') or (char == 'L' and activeKey == '4'):
			activeKey = '3'
		#This will make you end up at key 4
		elif (char == 'U' and activeKey == '8') or (char == 'R' and activeKey == '3'):
			activeKey = '4'	
		#This will make you end up at key 5
		elif (char == 'L' and activeKey == '6'):
			activeKey = '5'		
		#This will make you end up at key 6
		elif (char == 'D' and activeKey == '2') or (char == 'R' and activeKey == '5') or (char == 'L' and activeKey=='7') or (char == 'U' and activeKey=='A'):
			activeKey = '6'	
		#This will make you end up at key 7
		elif (char == 'D' and activeKey == '3') or (char == 'R' and activeKey == '6') or (char == 'L' and activeKey=='8') or (char == 'U' and activeKey=='B'):
			activeKey = '7'		
		#This will make you end up at key 8
		elif (char == 'D' and activeKey == '4') or (char == 'R' and activeKey == '7') or (char == 'L' and activeKey=='9') or (char == 'U' and activeKey=='C'):
			activeKey = '8'	
		#This will make you end up at key 9
		elif (char == 'R' and activeKey == '8'):
			activeKey = '9'
		#This will make you end up at key A
		elif (char == 'D' and activeKey == '6') or (char == 'L' and activeKey == 'B'):
			activeKey = 'A'
		#This will make you end up at key B
		elif (char == 'D' and activeKey == '7') or (char == 'R' and activeKey == 'A') or (char == 'L' and activeKey == 'C') or (char == 'U' and activeKey == 'D'):
			activeKey = 'B'
		#This will make you end up at key C
		elif (char == 'R' and activeKey == 'B') or (char == 'D' and activeKey == '8'):
			activeKey = 'C'
		#This will make you end up at key D
		elif (char == 'D' and activeKey == 'B'):
			activeKey = 'D'
	# Add the key you ended up at to the final key code
	keyCode = keyCode + str(activeKey)
	
print ('Key code (challenge 2): %s') % keyCode

	
print ''
print '***************************************************************************************'
print ''
