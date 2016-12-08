#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 8/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''


# ****************************************** challenge 1 ****************************************** 

noOfColumns = 50
noOfRows = 6

# Open input data file and read it into a list of strings
lines=[]
fo = open('08.data','r')
for line in fo:
	lines.append(line.replace('\n',''))
fo.close()

# create a pixel representation in an array with 6*50 position, filled witn a 0 identifying unlit pixels
pixels = []
for row in range(noOfRows):
	column = []
	for cols in range (noOfColumns):
		column.append(0)
	pixels.append(column)


# Iterate over all the instructions and execute the commands
for instruction in lines:
	# Is the instruction to light a rectangle of pixels?
	if instruction[0:4] == 'rect':
		# Create a rectangle of lit lights
		size = map(int,instruction[5:].split('x'))
		for y in range(size[1]):
			for x in range(size[0]):
				pixels[y][x]=1

	# Is the instruction to rotate a specified column down?
	if instruction[:13] == 'rotate column':
		col = int(instruction[14:].split(' ')[0][2:])
		moves = int(instruction[14:].split(' ')[2])
		for counter in range(moves):
			#Shifts the lights one row down
			replacedPixel = pixels[5][col]
			for y in range(6):
				tempPixel = pixels[y][col]
				pixels[y][col] = replacedPixel
				replacedPixel = tempPixel


	# Is the instruction to rotate a specified row to the right??
	if instruction[0:10] == 'rotate row':
		# Extract the row number and number of moves
		row = int(instruction[13:14])
		moves = int(instruction[18:])
		# Execute all moves, one at a time
		for counter in range(moves):
			# Shift the lights one column to the right
			replacedPixel = pixels[row][49]
			for x in range(50):
				tempPixel = pixels[row][x]
				pixels[row][x] = replacedPixel
				replacedPixel = tempPixel

# count the lit pixels
noOfLitPixels = 0 
for y in range(6): 
	for x in range(50): 
		noOfLitPixels += pixels[y][x]

print ('Challenge 1 - Total number of lit pixels: %s') % noOfLitPixels
print ''

# ****************************************** challenge 2 ****************************************** 

# Prepare for printing
printStrings = ['','','','','','']
for y in range(6):
	for x in range(50):
		# Add a space after each char
		if x % 5 == 0:
			printStrings[y] += '  '
		if pixels[y][x] == 0: 
			printStrings[y] += ' '
		else:
			printStrings[y] += '*'


# Print the resulting word
print 'Challenge 2 resulted in the follwing word:'
print ''
for y in range(6): print printStrings[y]

print ''
print '***************************************************************************************'
print ''


