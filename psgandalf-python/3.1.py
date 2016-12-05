# Advent of code 2016 from http://adventofcode.com/2016
# Day 3 part 1

valid = 0
file = open('3.1_input.txt', 'r')
for line in file:
    line = line.rstrip()
    nums = [int(n) for n in line.split()]
    nums = sorted(nums)
    if nums[0] + nums[1] > nums[2]:
        valid += 1
print valid