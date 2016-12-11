# Advent of code 2016 from http://adventofcode.com/2016
# Day 9 part 1
# b1 = bot1, o1 = output1

inventory = {}
commands = {}
command = []

file = open('10.1_input.txt', 'r')
for line in file:
    line = line.rstrip()
    inputs = line.split(' ')
    if inputs[0] == 'value':
        key = 'b'+ str(inputs[5])
        if key in inventory:
            inventory[key].append(int(inputs[1]))
        else:
            inventory[key]=[int(inputs[1])]
    else:
        key = 'b'+ str(inputs[1])
        if inputs[5] == 'bot':
            command.append('b' + str(inputs[6]))
        else:
            command.append('o' + str(inputs[6]))
        if inputs[10] == 'bot':
            command.append('b' + str(inputs[11]))
        else:
            command.append('o' + str(inputs[11]))
        commands[key]=command
        command = []
for k, v in commands.items():
    if not k in inventory:
        inventory[k]= []
    for v1 in v:
        if not v1 in inventory:
            inventory[v1] = []
Found = False
while True:
    for k, v in inventory.items():
        if len(v) == 2:
            found = True
            if len(inventory[commands[k][0]]) < 2 and  len(inventory[commands[k][1]]) < 2:
                if v[0] < v[1]:
                    inventory[commands[k][0]].append(v[0])
                    inventory[commands[k][1]].append(v[1])
                else:
                    inventory[commands[k][0]].append(v[1])
                    inventory[commands[k][1]].append(v[0])
                inventory[k] = []
                if 61 in v and 17 in v:
                    answ = k
    if not found:
        break
    else:
        found = False
answ = inventory['o0'][0] * inventory['o1'][0] * inventory['o2'][0]
print answ