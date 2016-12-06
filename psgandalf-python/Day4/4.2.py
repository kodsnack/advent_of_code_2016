# Advent of code 2016 from http://adventofcode.com/2016
# Day 4 part 2
import operator
import re
counter = {}
test = {}
real = False
answ = ""
file = open('4.1_input.txt', 'r')
for line in file:
    line = line.rstrip()
    line = line.split('[')
    text = " ".join(re.findall("[a-zA-Z]+", line[0]))
    number = int(" ".join(re.findall("[0-9]+", line[0])))
    t = 1
    for char in text:
        if not char == ' ':
            val = ord(char)
            for steps in range(0, number):
                if val == 122:
                    val = 97
                else:
                    val += 1
            answ += chr(val)
        else:
            answ += ' '
    if 'north' in answ:
        print answ + ' ' + str(number)
    answ = ''
