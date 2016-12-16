#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 14/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''

import hashlib
import re
import time

#m = hashlib.md5()


# ****************************************** challenge 1 ****************************************** 
print '********** Challenge 1 ************'

puzzleInput = 'zpqevtbw'

#reFindThreChars = re.compile('/(.)\1{3}')
#reFindThreChars = re.compile(r'(\w)\1{2}')

counter = 0	
hitcounter = 0
while hitcounter < 64:
	
	# Create a new seed string
	puzzleInputWithNumbers = puzzleInput + str(counter)

	# Create a MD5 hash from the seed
	mdFiveString= hashlib.md5(puzzleInputWithNumbers).hexdigest()
	
	matches = re.findall(r'(\w)\1{2}',mdFiveString)
	#if len(matches) > 0: print ('String: %s, Match: %s') % (mdFiveString, matches)
	
	if len(matches)>0:
		#print ('Looking for %s') % match
		# Check the next 1000 hash strings for a sequal of five consecutive chars of the found type
		for subCounter in range(1000):
			subMdFiveString = hashlib.md5(puzzleInput + str(counter+subCounter + 1)).hexdigest()
			#print r'(%s)\1{4}' % match
			subMatches = re.findall(r'(%s)\1{4}' % matches[0],subMdFiveString)
			if len(subMatches) > 0:
				hitcounter += 1
				print ('FOUND HIT NR: %s on key nr: %s') % (hitcounter, counter)		
	
	# Iterate over all possible matches
#	for match in matches:

	counter += 1

#print ('Hitcounter = %s, Counter = %s') % (hitcounter, counter)

# matches = re.findall(r'(\w)\1{2}', 'jsdfkljsfl000kkkjsddddfhksjhdfiis')
# for match in matches:
# 	print match



# ****************************************** challenge 2 ****************************************** 

print ''
print '********** Challenge 2 ************'

puzzleInput = 'zpqevtbw'

start = time.time()

counter = 0	
hitcounter = 0
while hitcounter < 64:
	
	# Create a new seed string
	puzzleInputWithNumbers = puzzleInput + str(counter)

	# Create a MD5 hash from the seed
	mdFiveString= hashlib.md5(puzzleInputWithNumbers).hexdigest()
	for mdCount in range(2016):
		mdFiveString = 	hashlib.md5(mdFiveString).hexdigest()

	matches = re.findall(r'(\w)\1{2}',mdFiveString)
	#if len(matches) > 0: print ('String: %s, Match: %s') % (mdFiveString, matches)
	
	if len(matches)>0:
		now = time.time()
		print ('Looking for %s on key nr: %s. Total executeion time: %s') % (matches[0], counter, int(now - start))
		# Check the next 1000 hash strings for a sequal of five consecutive chars of the found type
		for subCounter in range(1000):
			subMdFiveString = hashlib.md5(puzzleInput + str(counter+subCounter + 1)).hexdigest()
			for mdCount in range(2016):
			 	subMdFiveString = 	hashlib.md5(subMdFiveString).hexdigest()
			#print r'(%s)\1{4}' % matches[0]
			subMatches = re.findall(r'(%s)\1{4}' % matches[0],subMdFiveString)
			if len(subMatches) > 0:
				hitcounter += 1
				print ('FOUND HIT NR: %s on key nr: %s') % (hitcounter, counter)		
	
	# Iterate over all possible matches
#	for match in matches:

	counter += 1

#print ('Hitcounter = %s, Counter = %s') % (hitcounter, counter)

# matches = re.findall(r'(\w)\1{2}', 'jsdfkljsfl000kkkjsddddfhksjhdfiis')
# for match in matches:
# 	print match