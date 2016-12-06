import os
import collections

dir_path = os.path.dirname(os.path.realpath(__file__))
filename = dir_path + "/data_day6.txt"
file = open(filename, "r")
lines_dict = {'0': [], '1': [], '2': [], '3': [], '4' : [], '5': [], '6': [], '7': [], }


def most_frequent(dict_thing):
    result = ""
    for i in range(8):
        s = "".join(dict_thing[str(i)])
        result += collections.Counter(s).most_common(i+1)[0][0]
    return result

def least_frequent(dict_thing):
    result = ""
    for i in range(8):
        s = "".join(dict_thing[str(i)])
        result += collections.Counter(s).most_common()[-1][0]
    return result


for row in file:
    letters = row.replace("\n", "")
    for i in range(len(letters)):
        lines_dict[str(i)].append(row[i])

# answer 1
print(most_frequent(lines_dict))

# answer 2
print(least_frequent(lines_dict))
