#!/usr/bin/python
# -*- coding: utf-8 -*-

print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 3/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''

# Open input data file and read it into a string
lines=[]
fo = open('03.data','r')
for line in fo:
	lines.append(line.replace('\n','').strip(' '))
fo.close()


# ****************************************** challenge 1 ****************************************** 

noOfPossibleTriangles = 0

for line in lines:
	sides = map(int,line.split())
	if (sides[0] + sides [1] > sides[2]) and (sides[1] + sides[2] > sides[0] ) and (sides[0] + sides[2] > sides[1]):
		noOfPossibleTriangles += 1

print 'Number of possible triangles (challenge 1): %s' % str(noOfPossibleTriangles)



# ****************************************** challenge 2 ****************************************** 

#convert data to list of array of ints
intLines = []
for line in lines:
	intLines.append(map(int,line.split()))

noOfPossibleTriangles = 0

#Iterate over number of lines diveded with 3
for counter in range(len(intLines)/3):

	#Check first column for possible triangles
	if (intLines[counter*3+0][0] + intLines[counter*3+1][0] > intLines[counter*3+2][0]) and (intLines[counter*3+1][0] + intLines[counter*3+2][0] > intLines[counter*3+0][0]) and (intLines[counter*3+0][0] + intLines[counter*3+2][0] > intLines[counter*3+1][0]):
		noOfPossibleTriangles += 1

	#Check second column for possible triangles
	if (intLines[counter*3+0][1] + intLines[counter*3+1][1] > intLines[counter*3+2][1]) and (intLines[counter*3+1][1] + intLines[counter*3+2][1] > intLines[counter*3+0][1]) and (intLines[counter*3+0][1] + intLines[counter*3+2][1] > intLines[counter*3+1][1]):
		noOfPossibleTriangles += 1

	#Check third column for possible triangles
	if (intLines[counter*3+0][2] + intLines[counter*3+1][2] > intLines[counter*3+2][2]) and (intLines[counter*3+1][2] + intLines[counter*3+2][2] > intLines[counter*3+0][2]) and (intLines[counter*3+0][2] + intLines[counter*3+2][2] > intLines[counter*3+1][2]):
		noOfPossibleTriangles += 1

print 'Number of possible triangles (challenge 2): %s' % str(noOfPossibleTriangles)

print ''
print '***************************************************************************************'
print ''