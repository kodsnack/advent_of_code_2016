# Advent of code 2016 from http://adventofcode.com/2016
# Day 4 part 1
import operator
import re
counter = {}
test = {}
real = False
answ = 0
file = open('4.1_input.txt', 'r')
for line in file:
    line = line.rstrip()
    line = line.split('[')
    text = " ".join(re.findall("[a-zA-Z]+", line[0]))
    number = int(" ".join(re.findall("[0-9]+", line[0])))
    checksum = line[1][:-1]
    for char in text:
        if char != ' ':
            if not char in counter:
                counter[char] = text.count(char)
    sorted_counter = sorted(counter.items(), key=operator.itemgetter(1), reverse=True)
    step = 0
    for check_char in checksum:
        if check_char in text:
            if check_char == sorted_counter[step][0] or counter[check_char] == sorted_counter[step][1]:
                real = True
            else:
                real = False
                break
        else:
            real = False
            break
        step += 1
    if real:
        answ += number
    counter = {}
print answ