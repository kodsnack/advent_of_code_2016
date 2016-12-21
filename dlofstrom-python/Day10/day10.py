import re
input = open('day10-input.txt','r')

#Part 1
#Go through input data and separate start values and logic
start = []
bots = {}
logic = {}
for l in input:
    l = l.strip('\r\n')
    match = re.search(' goes to ', l)
    if match:
        value, bot = re.split('value | goes to ', l)[1:]
        bots[bot] = []
        start.append((bot,int(value)))
    else:
        bot, low, high = re.split(' gives low to | and high to ', l)
        logic[bot] = (low, high)
        bots[low] = []
        bots[high] = []

#Recursive
def give(bot, value):
    bots[bot].append(value)
    if len(bots[bot])==2:
        if min(bots[bot]) == 17 and max(bots[bot]) == 61:
            print 'Part 1:', bot
        give(logic[bot][0], min(bots[bot]))
        give(logic[bot][1], max(bots[bot]))
        
for b,v in start:
    give(b, v)

#Part 2
print 'Part 2:', bots['output 0'][0]*bots['output 1'][0]*bots['output 2'][0]
