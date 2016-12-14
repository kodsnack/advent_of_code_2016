import re, string

def solve(file):
    sector_sum = 0

    for line in file:
        m = re.search('([a-z-]+)([0-9]+)\[([a-z]+)\]', line)

        encrypted_name = m.group(1).replace('-', '')
        sector = m.group(2)
        checksum = m.group(3)

        test = [[x, 0] for x in list(string.ascii_lowercase)]

        for letter in encrypted_name:
            x = next(x for x in test if x[0] == letter)
            x[1] += 1

        test = [x for x in test if x[1] != 0]

        test.sort(key = lambda x: x[0], reverse=True)
        test.sort(key = lambda x: x[1])
        test = [test[0] for test in test[-5:]]
        test = ''.join(reversed(test))

        if test == checksum:
            sector_sum += int(sector)

        clearname = ''

        for letter in encrypted_name:
            clearname += chr((ord(letter) - 97 + int(sector)) % 26 + 97)

        if clearname == 'northpoleobjectstorage':
            print(sector)

    print(sector_sum)

with open('data/04.txt', 'r') as file:
    solve(file)
