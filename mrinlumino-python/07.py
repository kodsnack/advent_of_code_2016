#!/usr/bin/python
# -*- coding: utf-8 -*-

# Advent of code 2016 7/12

print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 7/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''


# Open input data file and read it into a string
lines=[]
fo = open('07.data','r')
for line in fo:
	lines.append(line.replace('\n',''))
fo.close()


# ****************************************** challenge 1 ****************************************** 

# ABBA counter
noOfABBAs = 0

# Iterate over all lines and look for matches
for line in lines:

	#Separate the brackeded strings from the other parts
	bracketstrings = ''
	startpos = line.find('[')
	while startpos >=0:
		endpos = line.find(']')
		foundstring = line[startpos:endpos+1]
		line = line.replace(foundstring,'*')
		bracketstrings += foundstring
		startpos = line.find('[')

	# Look for ABBA matches in the supernet
	isABBA = 0
	# Iterate over the string and look for ABBA intances
	for charCount in range(len(line)-3):
		if line[charCount] == line[charCount+3] and line[charCount+1] == line[charCount+2] and line[charCount] != line[charCount+1]: 
			isABBA = 1

	# Look for ABBA matches in the hypernet
	if isABBA == 1: 
		for charCount in range(len(bracketstrings)-3):
			# Reset the isABBA flag if an ABBA is found in the hypernet
			if bracketstrings[charCount] == bracketstrings[charCount+3] and bracketstrings[charCount+1] == bracketstrings[charCount+2] and bracketstrings[charCount] != bracketstrings[charCount+1] : 
				isABBA = 0	

	# Increase the counter if a valid ABBA was found
	if isABBA == 1: 
		noOfABBAs +=1

print ('Challenge 1 - Total of TLS supported ips: %s') % noOfABBAs


# ****************************************** challenge 2 ****************************************** 

noOfSSL = 0

for orgline in lines:
	line = orgline
	bracketstrings = ''

	identifiedSSL = 0

	#Separate the brackeded strings from the other parts
	startpos = line.find('[')
	while startpos >=0:
		endpos = line.find(']')
		foundstring = line[startpos:endpos+1]
		#Remove the found brackeded part of the string, insert char to avoid erronous matches later
		line = line.replace(foundstring,'*')
		bracketstrings += foundstring
		#Any more brackets?
		startpos = line.find('[')
	
	#Iterate over the supernet sequence
	for charCount in range(len(line)-2):
		firstChar = line[charCount]
		secondChar = line[charCount+1]
		thirdChar = line[charCount+2]
		if firstChar == thirdChar and firstChar != secondChar:
			#create a ABA string
			strABA = firstChar + secondChar + firstChar
			strBAB = secondChar + firstChar + secondChar
			if bracketstrings.find(strBAB) > -1 and identifiedSSL == 0:
				noOfSSL += 1
				identifiedSSL = 1

print ('Challenge 2 - Total of SSL supported ips: %s') % noOfSSL

print ''
print '***************************************************************************************'
print ''

