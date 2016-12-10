# Advent of code 2016 from http://adventofcode.com/2016
# Day 7 part 2
sum=0
bab_temp = []
aba_temp = []
start_bracket = False
file = open('7.1_input.txt', 'r')
for line in file:
    for counter in range(0, len(line)):
        if line[counter] == '[':
            start_bracket  = True
        if counter < len(line)-3:
            if not start_bracket:
                if line[counter] == line[counter + 2] and line[counter+1] != line[counter]:
                    bab_temp.append(line[counter] + line[counter + 1] + line[counter+2])
            else:
                if line[counter] == line[counter + 2] and line[counter+1] != line[counter]:
                    aba_temp.append(line[counter+1]+line[counter]+line[counter+1])
        if line[counter] == ']':
            start_bracket = False
    if set(bab_temp) & set(aba_temp)!=set([]):
        sum += 1
    bab_temp=[]
    aba_temp=[]
print sum