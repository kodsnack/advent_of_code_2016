import os

# read in the data
dir_path = os.path.dirname(os.path.realpath(__file__))
filename = dir_path + "/data_day3.txt"
file = open(filename, "r")

num_of_false_triangle = 0
num_total = 0

num_of_false_triangle_part_two = 0
num_total_part_two = 0
triangle_list_part_two = []


def invalid_triangle(numbers_list):
    highest_number = max(numbers_list)
    if sum(numbers_list) - highest_number <= (sum(numbers_list) / 2):
        return True
    else:
        return False


# part one
for row in file:
    numbers = row.split()
    numbers = list(map(int,numbers))
    if invalid_triangle(numbers):
        num_of_false_triangle +=1
    num_total +=1

# part two
file.seek(0)
for row in file:
    triangle_list_part_two.append(list(map(int,row.split()))[0])

file.seek(0)
for row in file:
    triangle_list_part_two.append(list(map(int,row.split()))[1])

file.seek(0)
for row in file:
    triangle_list_part_two.append(list(map(int,row.split()))[2])


for one, two, three in zip(*[iter(triangle_list_part_two)] * 3):
        triangle_list = [one, two, three]
        if invalid_triangle(triangle_list):
            num_of_false_triangle_part_two += 1
        num_total_part_two += 1


# answer one
print(num_total - num_of_false_triangle)

# answer two
print(num_total_part_two - num_of_false_triangle_part_two)