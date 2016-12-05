import os
import re
import collections
import string

#solution only works in python 2 will fix

# read in the data
dir_path = os.path.dirname(os.path.realpath(__file__))
filename = dir_path + "/data_day4.txt"
file = open(filename, "r")

sum_of_the_sector = 0
correct_rooms = []
answer_part_two = 0

class RoomDecoder:

    def __init__(self):
        self.abc_dict = dict(zip(string.ascii_lowercase, range(1,27)))
        self.abc_list = list(string.ascii_lowercase)

    def split_into_list(self, string_value):
        sector_id = re.search('\d+', string_value ).group()
        encrypted_name_and_checksum = string_value.split(sector_id,1)
        encrypted_name_and_checksum.append(int(sector_id))
        return encrypted_name_and_checksum

    def return_sector_if_valid(self, list_of_decoded_parts):
        decoded = list_of_decoded_parts[0].replace("-","")
        sorted_decoded = "".join(sorted(decoded))
        checksum = list_of_decoded_parts[1].replace("[","")
        checksum = checksum.replace("]","").replace("\n","")

        for letter in checksum:
            sorted_decoded = "".join(sorted(sorted_decoded))
            most_common_tuple = collections.Counter(sorted_decoded).most_common(1)[0]
            if most_common_tuple[1] == 1:
                most_common_letter = sorted_decoded[0]
            else:
                most_common_letter = most_common_tuple[0]
                tuple_of_letters = collections.Counter(sorted_decoded).most_common(len(sorted_decoded))
                if tuple_of_letters[0][1] == tuple_of_letters[1][1]:
                    #two letters with more than one occurrence, sort again
                    new_string = str(tuple_of_letters[0][0]) + str(tuple_of_letters[1][0])
                    shuld_be = "".join(sorted(new_string))[0]
                    if most_common_letter != shuld_be:
                        most_common_letter = shuld_be

            if letter == most_common_letter:
                sorted_decoded = sorted_decoded.replace(letter,"")
            else:
                return 0
        # print('correct')
        return list_of_decoded_parts[2]

    def decode_message(self, list_of_decoded_parts):
        result = ''
        num = list_of_decoded_parts[2]
        for letter in list_of_decoded_parts[0]:
            if letter == "-":
                result += " "
            else:
                steps = (num % 26) + self.abc_dict[letter] -1
                if steps >= 26:
                    steps -= 26
                result += self.abc_list[steps]
        return [result, num]


room_decoder = RoomDecoder()

for row in file:
    list_of_elements = room_decoder.split_into_list(row)
    value = room_decoder.return_sector_if_valid(list_of_elements)
    sum_of_the_sector += value
    if value > 0:
        correct_rooms.append(list_of_elements)

# answer part 1
print(sum_of_the_sector)

for element in correct_rooms:
    if "north" in room_decoder.decode_message(element)[0]:
        print(room_decoder.decode_message(element)[0])
        answer_part_two = room_decoder.decode_message(element)[1]

# answer part 2
print(answer_part_two)
