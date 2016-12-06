# Advent of code 2016 from http://adventofcode.com/2016
# Day 3 part 2

valid = 0
new_input=[]
new_input2 = []
file = open('3.1_input.txt', 'r')
for a in range(0,3):
    for line in file:
        line = line.rstrip()
        nums = [int(n) for n in line.split()]
        new_input.append(nums[a])
    file.seek(0)
file.close()
counter = 0
for number in new_input:
    if counter > 2:
        new_input2 = []
        counter = 0
    new_input2.append(number)
    if counter == 2:
        nums = sorted(new_input2)
        if nums[0] + nums[1] > nums[2]:
            valid += 1
    counter += 1
print valid