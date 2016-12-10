# Advent of code 2016 from http://adventofcode.com/2016
# Day 9 part 1

temp_line = ''
var = []
uncompressed_line = ''
answ = 0

file = open('9.1_input.txt', 'r')
for line in file:
    line = line.rstrip()
    counter = 0
    while counter < len(line):
        if line[counter] == '(':
            counter += 1
            while not line[counter] == ')':
                temp_line += line[counter]
                counter += 1
            var = temp_line.split('x')
            temp_line = ''
            if line[counter] == ')':
                counter += 1
                for count1 in range(0, int(var[1])):
                    for count2 in range(0, int(var[0])):
                        if counter + count2 < len(line):
                            uncompressed_line += line[counter + count2]
                counter = counter+count2
                var = []
        else:
            uncompressed_line += line[counter]
        counter += 1
    answ += len(uncompressed_line)
    print uncompressed_line
    uncompressed_line = ''
print answ