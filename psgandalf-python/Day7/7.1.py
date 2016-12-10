# Advent of code 2016 from http://adventofcode.com/2016
# Day 7 part 1

sum_support_tls = 0
tls_within_brackets = False
found = False
start_bracket = False
file = open('7.1_input.txt', 'r')
for line in file:
    for counter in range(0, len(line)):
        if line[counter] == '[':
            start_bracket  = True
        if counter < len(line)-4:
            if line[counter]==line[counter+3] and line[counter+1]==line[counter+2] and line[counter]!=line[counter+1]:
                found = True
                if start_bracket:
                    tls_within_brackets= True
        if line[counter] == ']':
            start_bracket = False
    if not tls_within_brackets and found:
        sum_support_tls += 1
    tls_within_brackets = False
    found = False
print sum_support_tls