import re, string

def solve(file):
    lines = file.readlines()
    lines = list(zip(*lines[::-1]))
    message = ''
    message2 = ''

    for line in lines:
        count = [(i, line.count(i)) for i in set(line)]
        count.sort(key = lambda x: x[1], reverse=True)
        message += count[0][0]
        message2 += count[-1][0]

    print(message)
    print(message2)

with open('data/06.txt', 'r') as file:
    solve(file)
