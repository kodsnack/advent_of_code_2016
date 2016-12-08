#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 6/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''

# Open input data file and read it into a string
lines=[]
fo = open('06.data','r')
for line in fo:
	lines.append(line)
fo.close()


charCounterArray = []
for i in range(26):
    charCounterArray.append(0)

# ****************************************** challenge 1 ****************************************** 

decrytpedMessage = ''
#iterate over each character
for charCounter in range(8):
	
	#reset charCounterArray
	for i in range(len(charCounterArray)):
		charCounterArray[i] = 0
	
	#iterate over all lines and count each character
	for line in lines:
		char = line[charCounter]
		charIndex = ord(char) - ord('a')
		charCounterArray[charIndex] = charCounterArray[charIndex] + 1

	#find the most common character
	highestCount = max(charCounterArray)
	charIndex = charCounterArray.index(highestCount)

	#add the corresponding character to the message
	decrytpedMessage = decrytpedMessage + chr(charIndex + ord('a'))

print ('Decrypted message (challenge 1): %s') % decrytpedMessage

# ****************************************** challenge 2 ****************************************** 

decrytpedMessage = ''
#iterate over each character
for charCounter in range(8):
	
	#reset charCounterArray
	for i in range(len(charCounterArray)):
		charCounterArray[i] = 0
	
	#iterate over all lines and count characters
	for line in lines:
		char = line[charCounter]
		charIndex = ord(char) - ord('a')
		#print ('Char: %s, index: %s') % (char,charIndex)
		charCounterArray[charIndex] = charCounterArray[charIndex] + 1

	#find the least common character
	lowestCount = min(charCounterArray)
	charIndex = charCounterArray.index(lowestCount)

	#add the corresponding character to the message
	decrytpedMessage = decrytpedMessage + chr(charIndex + ord('a'))

print ('Decrypted message (challenge 2): %s') % decrytpedMessage

print ''
print '***************************************************************************************'
print ''