import re

input = open('day4-input.txt','r')
input = [l.strip(']\n').split('[') for l in input]

#Part 1
sum = 0
for line in input:
    #Get a list of the letters
    letters = [l for l in list(set(line[0])) if l.isalpha()]
    #Sort based on most common and aphabetica
    letters = sorted([(l,-line[0].count(l)) for l in letters], key=lambda tup: (tup[1],tup[0]))    
    #Add to sum if checksum is correct
    if ''.join([c[0] for c in letters[0:5]]) == line[1]:
        sum += int(line[0].split('-')[-1])

print 'Part 1:', sum
