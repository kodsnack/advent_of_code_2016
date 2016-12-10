import re

input = open('day7-input.txt','r')
input = [re.split('\[|\]',l.strip('\n')) for l in input]

#Part 1
#Match 'abba'
def match_pattern(s):
    match = re.findall('(.)(.)\\2\\1', s)
    if match:
        #Same character not allowed
        if match[0][0] == match[0][1]:
            return False
        else:
            return True
    else:
        return False

#Count matching IPs
sum = 0
for line in input:
    if [match_pattern(s) for s in line[0::2]].count(True)>0 and [match_pattern(s) for s in line[1::2]].count(True)==0:
        sum += 1

print 'Part 1:', sum
