# Advent of code 2016 from http://adventofcode.com/2016
# Day 9 part 2

def decompressed_sum(line):
    counter = 0
    total = 0
    while counter < len(line):
        if line[counter] == '(':
            counter += 1
            newstring = ""
            while line[counter] != ')':
                newstring += line[counter]
                counter += 1
            x = int(newstring.split('x')[0])
            y = int(newstring.split('x')[1])
            total += y*decompressed_sum(line[counter+1:counter+x+1])
            counter += x
        else:
            total += 1
        counter += 1
    return total

file = open('9.1_input.txt', 'r')
line = file.read()
file.close()
print decompressed_sum(line)


