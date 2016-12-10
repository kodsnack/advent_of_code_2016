#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 1/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''


# Open input data file and read it into a string
fo = open('01.data','r')
rawinput = fo.read()
fo.close()

# Remove all spaces
inputWIthoutSpaces = rawinput.replace(' ','')

# Split the string into an array
route = inputWIthoutSpaces.split(',')

# Starting position
lat = 0 #N-S
long = 0 #E-W
direction = 'N'
visitedLocations = []
currentPositionInText = ('%s : %s') % (lat,long)
visitedLocations.append(currentPositionInText)
IHaveReturned = 0

# Identify and execute each move
for move in route:
	turn = move[0]
	steps = int(move[1:])
	# Execute turn
	if (turn == 'R' and direction == 'N') or (turn == 'L' and direction == 'S'): 
		direction = 'E'
	elif (turn == 'R' and direction == 'E') or (turn == 'L' and direction == 'W'): 
		direction = 'S'
	elif (turn == 'R' and direction == 'S') or (turn == 'L' and direction == 'N'): 
		direction = 'W'
	elif (turn == 'R' and direction == 'W') or (turn == 'L' and direction == 'E'): 
		direction = 'N'
	# Do the walking
	for step in range(steps):
		if (direction == 'N'): lat = lat + 1
		if (direction == 'S'): lat = lat - 1
		if (direction == 'E'): long = long + 1
		if (direction == 'W'): long = long - 1
	
		# Have we been here before? (Challenge 2)
		currentPositionInText = ('%s : %s') % (lat,long)
		if (IHaveReturned == 0) and (currentPositionInText in visitedLocations):
			print ('Challenge 2: Hey, I have been here before! It is %s blocks away') % (abs(lat) + abs(long))
			IHaveReturned = 1
		visitedLocations.append(currentPositionInText)




print('Challenge 1: I am done walking and ended up %s blocks away') % (abs(lat) + abs(long))
	
print ''
print '***************************************************************************************'
print ''
