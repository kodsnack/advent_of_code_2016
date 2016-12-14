#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 9/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''


# Open input data file and read it into a string
fo = open('09.data','r')
inputData = fo.read()
fo.close()

# ****************************************** challenge 1 ****************************************** 
rawinput = inputData
output = ''
loop = 0

# Identify the first instruction
startMarker = rawinput.find('(')


while startMarker > -1:
	# Are there any characters before the next start marker, then add these to the output and remove them from the input
	if startMarker > 0:
		output += rawinput[:startMarker]
		rawinput = rawinput[startMarker:]

	endMarker = rawinput.find(')')
	instruction = map(int,rawinput[1:endMarker].split('x'))
	if loop > 3: print instruction 

	rawinput = rawinput[endMarker+1:]
	

	for iteration in range(instruction[1]):
		output += rawinput[:instruction[0]]


	rawinput = rawinput[instruction[0]:]

	startMarker = rawinput.find('(')

# Add last remaining part of the string
output += rawinput

print 'Resulting string length (Challenge 1): % s' % len(output)



# ****************************************** challenge 2 ****************************************** 
rawinput = inputData
totalLenght = 0


def CalculateDecodedStringLengh(inString):
	lengthOfString = 0
	

	# Find any instructions
	while inString.find('(') > -1:

		# Remove any starting characters
		if inString.find('(')>0:
			lengthOfString += inString.find('(')
			inString = inString[inString.find('('):]

		endMarker = inString.find(')')
		instruction = map(int,inString[1:endMarker].split('x'))


		# Remove instruction string
		inString = inString[endMarker+1:]		

		# Extract the string to be repeated
		repeatString = inString[:instruction[0]]

		# Iterate the instructed amount of times
		for i in range(instruction[1]):
			lengthOfString += CalculateDecodedStringLengh(repeatString)

		# Remove the repeated string
		inString = inString[instruction[0]:]	
	
	# Add possible remaining characters
	lengthOfString += len(inString)

	# Return the calculated string length
	return lengthOfString


# Identify the first instruction
startMarker = rawinput.find('(')

while startMarker > -1:

	# Are there any characters before the next start marker, then count these and remove them from the string
	if startMarker > 0:
		totalLenght += startMarker
		rawinput = rawinput[startMarker:]

	# Find the end paranthesis
	endMarker = rawinput.find(')')

	# Extract the instruction
	instruction = map(int,rawinput[1:endMarker].split('x'))

	# Remove the instruction from the string
	rawinput = rawinput[endMarker+1:]

	for iteration in range(instruction[1]):
		totalLenght += CalculateDecodedStringLengh(rawinput[:instruction[0]])

	# Remove the substring
	rawinput = rawinput[instruction[0]:]

	# Find any more start paranthesis
	startMarker = rawinput.find('(')


# Add last remaining part of the string
totalLenght += len(rawinput)

#print ''
print ('Total lenght of decoded string (Challenge 2): %s') % totalLenght

