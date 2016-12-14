
# AOC Day #4 Solution
# </> nils måsen, piksel bitworks

import sys, re

def solution_one(lines):
    id_sum = 0
    for line in lines:
        _, id_code, valid = parse_line(line)

        if valid:
            id_sum += id_code

    return id_sum

def solution_two(lines):
    for line in lines:
        letters, id_code, valid = parse_line(line)

        if valid and "north" in decrypt_name(letters, id_code):
            return id_code

def count_letters(letters):
    letter_count = {}
    for letter in letters:
        if letter == '-':
            continue
        if not letter in letter_count:
            letter_count[letter] = 1
        else:
            letter_count[letter] += 1
    return letter_count

def parse_line(line):
    matches = re.search(r'([a-z|-]+)(\d+)\[([a-z]+)\]', line)
    letters = matches.group(1)
    id_code = int(matches.group(2))
    checksum = matches.group(3)
    counts = count_letters(letters)
    valid_checksum = get_valid_checksum(counts)

    return letters, id_code, valid_checksum == checksum

def get_valid_checksum(counts):
    valid_letters = ['', '', '', '', '']
    previous_highest = None
    for pos in range(0, 5):
        highest = 0
        for letter in counts:
            count = counts[letter]
            if letter in valid_letters:
                continue
            if previous_highest and count > previous_highest:

                continue
            if count > highest or (count == highest and ord(letter) < ord(valid_letters[pos])):
                valid_letters[pos] = letter
                highest = counts[letter]

        previous_highest = highest
    return ''.join(valid_letters)

def validate_checksum(checksum, valid_letters):
    for pos in range(0, 5):
        if not checksum[pos] in valid_letters[pos]:
            return False
    return True

CHR_BASE = ord('a')
CHR_COUNT = (ord('z')-CHR_BASE) + 1

def decrypt_name(letters, id_code):
    decrypted = ''
    for letter in letters:
        if letter == '-':
            decrypted += ' '
        else:
            decrypted += chr(((ord(letter) - CHR_BASE + id_code) % CHR_COUNT) + CHR_BASE)
    return decrypted

def load_instructions(input_file):
    file = open(input_file, mode='r')
    return file.readlines()

def main():
    lines = load_instructions(sys.argv[1])

    print("Part 1:", solution_one(lines))
    print("Part 2:", solution_two(lines))

if __name__ == '__main__':
    main()
