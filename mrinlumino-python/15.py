#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 15/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''




# ****************************************** challenge 1 ****************************************** 
print '********** Challenge 1 ************'


# Puzzle input
# Disc #1 has 5 positions; at time=0, it is at position 2.
# Disc #2 has 13 positions; at time=0, it is at position 7.
# Disc #3 has 17 positions; at time=0, it is at position 10.
# Disc #4 has 3 positions; at time=0, it is at position 2.
# Disc #5 has 19 positions; at time=0, it is at position 9.
# Disc #6 has 7 positions; at time=0, it is at position 0.

# Discs aligned compensated for the traveling time through the discs
discs = [2,8,12,2,13,5]



time = 0
bingo = 0
while bingo == 0 and time < 1000000000:
	# Increase time
	time += 1

	# Move discs
	for discNo in range(6):
		discs[discNo] += 1

	# Check if any disc should be reset to position 0
	if discs[0] == 5: discs[0] = 0
	if discs[1] == 13: discs[1] = 0
	if discs[2] == 17: discs[2] = 0
	if discs[3] == 3: discs[3] = 0
	if discs[4] == 19: discs[4] = 0
	if discs[5] == 7: discs[5] = 0

	# Are the discs aligned on position 0?
	if discs == [0,0,0,0,0,0]: 
		bingo = 1

print 'Challenge 1: Discs aligned at drop time=%s' % (time-1)


# ****************************************** challenge 2 ****************************************** 
print ''
print '********** Challenge 2 ************'


# Puzzle input
# Disc #1 has 5 positions; at time=0, it is at position 2.
# Disc #2 has 13 positions; at time=0, it is at position 7.
# Disc #3 has 17 positions; at time=0, it is at position 10.
# Disc #4 has 3 positions; at time=0, it is at position 2.
# Disc #5 has 19 positions; at time=0, it is at position 9.
# Disc #6 has 7 positions; at time=0, it is at position 0.
# Disc #7 has 11 positions; at time=0, it is at position 0.

# Discs aligned compensated for the traveling time through the discs
discs = [2,8,12,2,13,5,6]



time = 0
bingo = 0
while bingo == 0 and time < 1000000000:
	# Increase time
	time += 1

	# Move discs
	for discNo in range(7):
		discs[discNo] += 1

	# Check if any disc should be reset to position 0
	if discs[0] == 5: discs[0] = 0
	if discs[1] == 13: discs[1] = 0
	if discs[2] == 17: discs[2] = 0
	if discs[3] == 3: discs[3] = 0
	if discs[4] == 19: discs[4] = 0
	if discs[5] == 7: discs[5] = 0
	if discs[6] == 11: discs[6] = 0

	# Are the discs aligned on position 0?
	if discs == [0,0,0,0,0,0,0]: 
		bingo = 1

print 'Challenge 2: Discs aligned at drop time=%s' % (time-1)


