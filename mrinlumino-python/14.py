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
		# Check the next 1000 hash strings for a sequal of five consecutive chars of the found type
		for subCounter in range(1000):
			subMdFiveString = hashlib.md5(puzzleInput + str(counter+subCounter + 1)).hexdigest()
			subMatches = re.findall(r'(%s)\1{4}' % matches[0],subMdFiveString)
			if len(subMatches) > 0:
				hitcounter += 1
				print ('FOUND HIT NR: %s on key nr: %s') % (hitcounter, counter)		
	
	counter += 1

print 'Challenge 1 completed, the 64:th key found'

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
	
	# Do the stretching
	for mdCount in range(2016):
		mdFiveString = 	hashlib.md5(mdFiveString).hexdigest()

	# Look for any character repeated three times in a row
	matches = re.findall(r'(\w)\1{2}',mdFiveString)
	
	if len(matches)>0:
		now = time.time()
		# Check the next 1000 hash strings for a sequal of five consecutive chars of the found type
		for subCounter in range(1000):
		
			# Create a MD5 hash from the seed
			subMdFiveString = hashlib.md5(puzzleInput + str(counter+subCounter + 1)).hexdigest()
			
			# Do the stretching
			for mdCount in range(2016):
			 	subMdFiveString = 	hashlib.md5(subMdFiveString).hexdigest()
			
			# Look for any character repeated five times in a row
			subMatches = re.findall(r'(%s)\1{4}' % matches[0],subMdFiveString)
			if len(subMatches) > 0:
				hitcounter += 1
				print ('FOUND HIT NR: %s on key nr: %s') % (hitcounter, counter)		
	

	counter += 1

print 'Challenge 2 completed, the 64:th key found'