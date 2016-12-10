#!/usr/bin/python
# -*- coding: utf-8 -*-

print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 4/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''

print "Decoding ...."

# Open input data file and read it into a string
data=[]


fo = open('04.data','r')
for line in fo:
	line = line.replace('\n','').strip(' ')
	checksum = line[line.rfind('['):].strip('[').strip(']')
	lineWihtoutChecksum = line[0:line.rfind('[')]
	sectorID = int(lineWihtoutChecksum[lineWihtoutChecksum.rfind('-')+1:])
	ecnryptedName=lineWihtoutChecksum[0:lineWihtoutChecksum.rfind('-')]
	#print ('%s : Name: %s | Checksum: %s | SectorID: %s') % (line, ecnryptedName, checksum, sectorID)
	#print ecnryptedName
	data.append([ecnryptedName,sectorID, checksum])
	#lines.append(line.replace('\n','').strip(' '))
fo.close()

sumOfSectorID = 0


for room in data:
	name=room[0].replace('-','')
	nameWithDashes = room[0]
	sectorID = room[1]
	checksum = room[2]
	checkSumOK = 1
	decodedName = ''
	for n in range(5):
		#create a sorted list of character from the name
		namelist = sorted(name)
		
		#find the most common character
		checksumChar = max(namelist,key=namelist.count)
		#print ('%s:%s:%s') % (name, checksumChar,checksum[n])
		
		#strip the first character from the name
		name = name.replace(checksumChar,'')
		
		#compare the identified character to the corresponding checksum character
		if checksumChar != checksum[n]: 
			checkSumOK = 0
	

	for decodingChar in nameWithDashes:
		# If the character is a dash, replace it with a space
		if decodingChar == '-': 
			decodedName += ' '
		else:
			# Repeate a specied numer of times, defines by the sector ID
			for sectorCount in range(sectorID):
				# If we ended up at the end of the alphabet, the restart
				if decodingChar == 'z': 
					decodingChar = 'a'
				else:
					# Change to the next letter in the alphabet
					decodingChar = chr(ord(decodingChar)+1)
			decodedName += decodingChar

	# Have we found a correct room, the increase the count
	if checkSumOK == 1:
		sumOfSectorID += sectorID
		# Have we found the north pole?
		if decodedName.find('northpole') > -1:
			print ('Challenge 2: Sector ID for Northpole storage room: %s') % (sectorID)


print ('Challenge 1: The sum of sectorID:s for correct rooms is: %s') % sumOfSectorID

print ''
print '***************************************************************************************'
print ''