import re
import itertools
input = open('day11-input.txt','r')
input = [re.split(' contains ', l.strip('\r\n')) for l in input]

#Part 1
#Each floor contains a list with each item as a tuple (generator,)/(,chip)
start = [re.findall(r'((?<=a )\w+(?= generator))|((?<=a )\w+(?=-compatible microchip))',l[1]) for l in input]
elevator = 0

#State = (elevator, floor contents)
def pretty_print(state):
    str = ''
    for i,s in enumerate(state[1]):
        floor = ['e'] if state[0]==i else ['']
        floor.append('')
        
        
        


#p = re.compile('+(?<=a )[a-z]{1,}(?=( generator|-compatible microchip))')
#p = re.compile('((?<=a )[a-z]{1,}(?= generator))((?<=a )[a-z]{1,}(?=-compatible microchip))')
#for f in floors:
#    for i in f:
#        m = re.search('(?<=a )[a-z]{1,}(?=( generator|-compatible microchip))',i)
#        if m:
#            print m.group()



