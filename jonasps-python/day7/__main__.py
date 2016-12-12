import os
import re

dir_path = os.path.dirname(os.path.realpath(__file__))
filename = dir_path + "/data_day7.txt"
file = open(filename, "r")

result_part_one = 0
result_part_two = 0


def format_string_to_lists(a_string):
    result = re.findall('\[(.*?)\]', str(a_string))
    if result:
        return result
    else:
        return None


def ip_has_abba(string):
    for letter in range(len(string)):
        if letter + 1 < len(string):
            first = string[letter]
            second = string[letter+1]
            if first+second+second+first in string and (first is not second):
                return True
    return False


def ip_has_aba_and_bab(string, brackets_list):
    for letter in range(len(string)):
        if letter + 1 < len(string):
            first = string[letter]
            second = string[letter+1]
            if first+second+first in string and (first is not second):
                for element in brackets_list:
                    if second+first+second in element:
                        return True
    return False


def check_if_ip_support_tls(ip):
    between_square_brackets = format_string_to_lists(ip)
    if between_square_brackets:
        for e in between_square_brackets:
            if ip_has_abba(e):
                return False

    if ip_has_abba(ip):
        return True


def check_if_ip_support_ssl(ip):
    between_square_brackets = format_string_to_lists(ip)
    ip_without_brackets = ip
    for element in between_square_brackets:
        ip_without_brackets = ip_without_brackets.replace(element, "")
    return ip_has_aba_and_bab(ip_without_brackets, between_square_brackets)


for row in file:
    if check_if_ip_support_tls(row) == True:
        result_part_one +=1
    if check_if_ip_support_ssl(row) == True:
        result_part_two += 1

# answer part one
print(result_part_one)

# answer part two
print(result_part_two)