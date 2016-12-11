import re
import string
from itertools import permutations

input = open('day7-input.txt','r')
input = [re.split('\[|\]',l.strip('\n')) for l in input]

#Part 1
#Match 'abba'
pairs = [''.join(x) for x in permutations(string.lowercase,2)]
def match_pattern(s):
    for p in pairs:
        if p+p[::-1] in s:
            return True
    return False

#Count matching IPs
sum = 0
for line in input:
    if [match_pattern(s) for s in line[0::2]].count(True)>0 and [match_pattern(s) for s in line[1::2]].count(True)==0:
        sum += 1

print 'Part 1:', sum

#Part 2
#Match 'aba'
def match_pattern_aba(supernet, hypernet):
    match = []
    #Go through supernet strings and save aba matches
    for s in supernet:
        for p in pairs:
            if p+p[0] in s:
                match.append(p)
    #Check all bab matches in hypernet
    if match:
        for h in hypernet:
            for p in match:
                if p[-1]+p in h:
                    return True
    return False

sum = 0
for line in input:
    if match_pattern_aba(line[0::2], line[1::2]):
        sum += 1
print 'Part 2:', sum
