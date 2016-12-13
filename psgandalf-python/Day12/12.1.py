# Advent of code 2016 from http://adventofcode.com/2016
# Day 12 part 1

register = {}
commands = []
register['a'] = 0
register['b'] = 0
register['c'] = 0
register['d'] = 0

def IsInt(str):
    try:
        int(str)
        return True
    except ValueError:
        return False

file = open('12.1_input.txt', 'r')
for line in file:
    line = line.rstrip()
    line = line.split(' ')
    commands.append(line)
counter = 0
while counter < len(commands):
    if commands[counter][0] == 'cpy':
        if IsInt(commands[counter][1]):
            register[commands[counter][2]] = int(commands[counter][1])
        else:
            register[commands[counter][2]] = register[commands[counter][1]]
    if commands[counter][0] == 'inc':
        register[commands[counter][1]] += 1
    if commands[counter][0] == 'dec':
        register[commands[counter][1]] -= 1
    if commands[counter][0] == 'jnz':
        if IsInt(commands[counter][1]):
            if not int(commands[counter][1]) == 0:
                counter += int(commands[counter][2])-1
        else:
            if not register[commands[counter][1]] == 0:
                counter += (int(commands[counter][2])-1)
    counter += 1
print register['a']