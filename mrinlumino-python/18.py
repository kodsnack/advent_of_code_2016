#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 18/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''


# ****************************************** challenge 1 ****************************************** 
print '********** Challenge 1 ************'

fo = open('18.data','r')
rawinput = fo.read()
fo.close()

# Create a string array with all safe tiles and with one char added 
# at the beginning and end of the string
strings = []
strings.append('.' + rawinput + '.')
for n in range(39):
	strings.append('.' + rawinput.replace('^','.') + '.')


# Iterate over all strings
for rowID in range(len(strings)):
	# Skip first row
	if rowID > 0:
		for charID in range(len(strings[rowID])):
			# Skip the first and last char
			if charID > 0 and charID < len(strings[rowID])-1:
				newChar = '.'
				# Check against the criterias for the current char to be a trap
				if strings[rowID-1][charID-1:charID+2] == '^^.': newChar = '^'
				if strings[rowID-1][charID-1:charID+2] == '.^^': newChar = '^'
				if strings[rowID-1][charID-1:charID+2] == '^..': newChar = '^'
				if strings[rowID-1][charID-1:charID+2] == '..^': newChar = '^'

				# Replace the character in the string
				strings[rowID] = strings[rowID][:charID] + newChar + strings[rowID][charID+1:]


# Count the safe tiles
NoOfSafeTiles = 0
for string in strings:
	# Remove the added first and last character
	string = string[1:len(string)-1]
	for char in string:
		if char == '.' : NoOfSafeTiles += 1


print 'Challenge 1: Number of safe tiles are: %s' % NoOfSafeTiles






# ****************************************** challenge 2 ****************************************** 
print '\n********** Challenge 2 ************'

fo = open('18.data','r')
rawinput = fo.read()
fo.close()

def CountSafeTiles(inString):
	NoOfSafeTiles = 0
	string = inString[1:len(inString)-1]	
	for char in string:
		if char == '.' : NoOfSafeTiles += 1
	return NoOfSafeTiles

# Create a string array with two strings, the first holding the starting string and
# the second hodling a safe string
strings = []
safeString = '.' + rawinput.replace('^','.') + '.'
strings.append('.' + rawinput + '.')
strings.append(safeString)

# Counter for number of safe tiles
totalNoOfSafeTiles = 0

# Add the number of safe tiles in the starting string
totalNoOfSafeTiles += CountSafeTiles(strings[0])

# Iterate the number of total rows minus one
for n in range(400000-1):

	# Construct the second string based on the first string and the given criterias
	for charID in range(len(safeString)):
		
		# Skip the first and last char
		if charID > 0 and charID < len(safeString)-1:
			newChar = '.'
			# Check against the criterias for the current char to be a trap
			if strings[0][charID-1:charID+2] == '^^.': newChar = '^'
			if strings[0][charID-1:charID+2] == '.^^': newChar = '^'
			if strings[0][charID-1:charID+2] == '^..': newChar = '^'
			if strings[0][charID-1:charID+2] == '..^': newChar = '^'

			# Replace the character in the string
			strings[1] = strings[1][:charID] + newChar + strings[1][charID+1:]

	# Add the number of safe tiles in the newly created string
	totalNoOfSafeTiles += CountSafeTiles(strings[1])

	# Move string 1 to string 0 and reset string 1
	strings[0] = strings[1]
	strings[1] = safeString


print 'Challenge 2: Number of safe tiles are: %s' % totalNoOfSafeTiles


#19999535

