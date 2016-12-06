# Advent of code 2016 from http://adventofcode.com/2016
# Day 6 part 2

import operator

char_counter = {}
repeat = 0
answ = ''
file = open('6.1_input.txt', 'r')
while True:
    for line in file:
        line = line.rstrip()
        if line[repeat] in char_counter:
            char_counter[line[repeat]] += 1
        else:
            char_counter[line[repeat]] = 1
    answ += min(char_counter.iteritems(), key=operator.itemgetter(1))[0]
    char_counter={}
    file.seek(0)
    repeat += 1
    if repeat == len(line):
        break
file.close()
print answ