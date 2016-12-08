#!/usr/bin/python
# -*- coding: utf-8 -*-

print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 5/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''

import hashlib
m = hashlib.md5()


puzzleInput = 'reyedfim'


# ****************************************** challenge 1 ****************************************** 

codeString = ''

counter = 0
print 'testing strings for challenge 1.....'
while len(codeString) < 8:
	puzzleInputWithNumbers = puzzleInput + str(counter)
	mdFiveString= hashlib.md5(puzzleInputWithNumbers).hexdigest()
	if mdFiveString[0:5] == '00000':
		codeString += mdFiveString[5]
		print ('Identified a valid code character: %s') % (mdFiveString[5])
		
	counter += 1

print ('Identified code (challenge 1): %s') % codeString


# ****************************************** challenge 2 ****************************************** 
print ''
codeString = '********'

counter = 0
print 'testing strings for challenge 2.....'
while codeString.find('*') > -1:
	puzzleInputWithNumbers = puzzleInput + str(counter)
	#print puzzleInputWithNumbers
	#m.update(puzzleInputWithNumbers)
	#mdFiveString = m.hexdigest()
	mdFiveString= hashlib.md5(puzzleInputWithNumbers).hexdigest()
	if mdFiveString[0:5] == '00000':
		if ord(mdFiveString[5]) in range(ord('0'),ord('8')):
			position = int(mdFiveString[5])
			if codeString[position] == '*':
				codeString = codeString[:position] + mdFiveString[6] + codeString[position+1:]
				print ('Found a valid code character. Code string updated: %s') % codeString
		
	counter += 1

print ('Identified code (challgenge 2): %s') % codeString

print ''
print '***************************************************************************************'
print ''

