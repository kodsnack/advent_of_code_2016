#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 20/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''


# ****************************************** challenge 1 ****************************************** 
print '********** Challenge 1 ************'

adresses=[]
fo = open('20.data','r')
for line in fo:
	adresses.append( map(int,line.replace('\n','').split('-')))
fo.close()


ipAdress = 0
ipAdressOK = 0

while ipAdressOK == 0:
	# Assume that the ip adress is ok
	ipAdressOK = 1
	
	#test the ip adress against all adressess in the block list
	for adress in adresses:
		if ipAdress >= adress[0] and ipAdress <= adress[1]: 
			ipAdressOK = 0
			ipAdress = adress[1]

	if ipAdressOK == 0: ipAdress += 1


print 'Challenge 1: First allowed ip adress is: %s' % ipAdress



# ****************************************** challenge 2 ****************************************** 
print '\n********** Challenge 2 ************'

adresses=[]
fo = open('20.data','r')
for line in fo:
	adresses.append( map(int,line.replace('\n','').split('-')))
fo.close()


ipAdressOK = 0
ipAdress = 0
NoOfipAdressOK = 0

while ipAdress <= 4294967295:
	# Assume that the ip adress is ok
	ipAdressOK = 1
	
	#test the ip adress against all adressess in the block list
	for adress in adresses:
		if ipAdress >= adress[0] and ipAdress <= adress[1]: 
			ipAdressOK = 0
			# Move to the last ip adress in the blocked range
			ipAdress = adress[1]

	# If the ipAdress was ok, then increase the counter
	if ipAdressOK == 1: NoOfipAdressOK += 1
	
	# Move to the next ip adress
	ipAdress += 1


print 'Challenge 2: Number of allowed ip adresses are: %s' % NoOfipAdressOK

