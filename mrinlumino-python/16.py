#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 16/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''




# ****************************************** challenge 1 ****************************************** 
print '********** Challenge 1 ************'


puzzleInput = '11101000110010100'
discSize = 272

dragonString = puzzleInput
while len(dragonString) < discSize:
	# Calculate a reversed string with negated chars
	reverseString = ''
	for i in range(len(dragonString)):
		if dragonString[len(dragonString)-1-i] == '0':
			reverseString += '1'
		else:
			reverseString += '0' 

	# Calculate the dragon string
	dragonString = dragonString + '0' + reverseString


# Trim the data string if necessary
if len(dragonString)> discSize: dragonString = dragonString[:discSize]

# Calculate checksum
checkSum = ''
checkSumDone = 0
inData = dragonString
while checkSumDone == 0:
	checkSum = ''
	for index in range(len(inData)/2):
		if inData[index*2] == inData[index*2+1]:
			checkSum += '1'
		else:
			checkSum += '0'
	if len(checkSum) % 2 == 1: 
		checkSumDone = 1

	else:
		inData = checkSum


print 'Challenge 1 : Resulting checksum is: %s' % checkSum


# ****************************************** challenge 2 ****************************************** 
print '\n********** Challenge 2 ************'


puzzleInput = '11101000110010100'
discSize = 35651584

dragonString = puzzleInput
while len(dragonString) < discSize:
	# Calculate a reversed string with negated chars
	reverseString = ''
	for i in range(len(dragonString)):
		if dragonString[len(dragonString)-1-i] == '0':
			reverseString += '1'
		else:
			reverseString += '0' 

	# Calculate the dragon string
	dragonString = dragonString + '0' + reverseString


# Trim the data string if necessary
if len(dragonString)> discSize: dragonString = dragonString[:discSize]

# Calculate checksum
checkSum = ''
checkSumDone = 0
inData = dragonString
while checkSumDone == 0:
	checkSum = ''
	for index in range(len(inData)/2):
		if inData[index*2] == inData[index*2+1]:
			checkSum += '1'
		else:
			checkSum += '0'
	if len(checkSum) % 2 == 1: 
		checkSumDone = 1

	else:
		inData = checkSum


print 'Challenge 2 : Resulting checksum is: %s' % checkSum

