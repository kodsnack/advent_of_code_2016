# Advent of code 2016 from http://adventofcode.com/2016
# Day 5 part 1

import hashlib

code_nr = 0
number = 0
answ = ''

file = open('5.1_input.txt', 'r')
for line in file:
    line = line.rstrip()

while code_nr < 8:
    key_string = line+str(number)
    hash = hashlib.md5(key_string).hexdigest()
    hash_check = hash[0:5]
    if hash_check == '00000':
        answ += hash[5]
        code_nr += 1
    number += 1
print answ

