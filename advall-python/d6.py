import collections

with open ("d6_input.txt", "r") as inputfile:
    input = inputfile.readlines()

columns = []

for i in range(8):
    column = ""
    for line in input:
        column += line[i]
    columns.append(column)

msg = ""
for col in columns:
    msg += (collections.Counter(col).most_common(1)[0][0])

print "Part one: " + msg

msg = ""
for col in columns:
    msg += (collections.Counter(col).most_common(len(col))[-1][0])

print "Part two: " + msg