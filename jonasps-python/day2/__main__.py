import os

# read in the data
dir_path = os.path.dirname(os.path.realpath(__file__))
filename = dir_path + "/data_day2.txt"
file = open(filename, "r")
instructions = {}
answer = ""
answer2 = ""


def find_button_on_keypad_one(current_number, letter):
    if current_number == 1:
        if letter == "U":
            return 1
        if letter == "D":
            return 4
        if letter == "L":
            return 1
        if letter == "R":
            return 2

    if current_number == 2:
        if letter == "U":
            return 2
        if letter == "D":
            return 5
        if letter == "L":
            return 1
        if letter == "R":
            return 3

    if current_number == 3:
        if letter == "U":
            return 3
        if letter == "D":
            return 6
        if letter == "L":
            return 2
        if letter == "R":
            return 3

    if current_number == 4:
        if letter == "U":
            return 1
        if letter == "D":
            return 7
        if letter == "L":
            return 4
        if letter == "R":
            return 5

    if current_number == 5:
        if letter == "U":
            return 2
        if letter == "D":
            return 8
        if letter == "L":
            return 4
        if letter == "R":
            return 6

    if current_number == 6:
        if letter == "U":
            return 3
        if letter == "D":
            return 9
        if letter == "L":
            return 5
        if letter == "R":
            return 6

    if current_number == 7:
        if letter == "U":
            return 4
        if letter == "D":
            return 7
        if letter == "L":
            return 7
        if letter == "R":
            return 8

    if current_number == 8:
        if letter == "U":
            return 5
        if letter == "D":
            return 8
        if letter == "L":
            return 7
        if letter == "R":
            return 9

    if current_number == 9:
        if letter == "U":
            return 6
        if letter == "D":
            return 9
        if letter == "L":
            return 8
        if letter == "R":
            return 9


def find_button_on_keypad_two(current_number, letter):

    if current_number == "1":
        if letter == "U":
            return "1"
        if letter == "D":
            return "3"
        if letter == "L":
            return "1"
        if letter == "R":
            return "1"

    if current_number == "2":
        if letter == "U":
            return "2"
        if letter == "D":
            return "6"
        if letter == "L":
            return "2"
        if letter == "R":
            return "3"

    if current_number == "3":
        if letter == "U":
            return "1"
        if letter == "D":
            return "7"
        if letter == "L":
            return "2"
        if letter == "R":
            return "4"

    if current_number == "4":
        if letter == "U":
            return "4"
        if letter == "D":
            return "8"
        if letter == "L":
            return "3"
        if letter == "R":
            return "4"

    if current_number == "5":
        if letter == "U":
            return "5"
        if letter == "D":
            return "5"
        if letter == "L":
            return "5"
        if letter == "R":
            return "6"

    if current_number == "6":
        if letter == "U":
            return "2"
        if letter == "D":
            return "A"
        if letter == "L":
            return "5"
        if letter == "R":
            return "7"

    if current_number == "7":
        if letter == "U":
            return "3"
        if letter == "D":
            return "B"
        if letter == "L":
            return "6"
        if letter == "R":
            return "8"

    if current_number == "8":
        if letter == "U":
            return "4"
        if letter == "D":
            return "C"
        if letter == "L":
            return "7"
        if letter == "R":
            return "9"

    if current_number == "9":
        if letter == "U":
            return "9"
        if letter == "D":
            return "9"
        if letter == "L":
            return "8"
        if letter == "R":
            return "9"

    if current_number == "A":
        if letter == "U":
            return "6"
        if letter == "D":
            return "A"
        if letter == "L":
            return "A"
        if letter == "R":
            return "B"

    if current_number == "B":
        if letter == "U":
            return "7"
        if letter == "D":
            return "D"
        if letter == "L":
            return "A"
        if letter == "R":
            return "C"

    if current_number == "C":
        if letter == "U":
            return "8"
        if letter == "D":
            return "C"
        if letter == "L":
            return "B"
        if letter == "R":
            return "C"

    if current_number == "D":
        if letter == "U":
            return "B"
        if letter == "D":
            return "D"
        if letter == "L":
            return "D"
        if letter == "R":
            return "D"

counter = 0
for row in file:
    instructions[counter] = str(row).replace("\n","")
    counter += 1

key = 5
key2 = "5"

for number in instructions:
    for letter in instructions[number]:
        key = find_button_on_keypad_one(key,letter)
        key2 = find_button_on_keypad_two(key2, letter)
    answer += str(key)
    answer2 += str(key2)

#first answer
print(answer)

#second anser
print(answer2)
