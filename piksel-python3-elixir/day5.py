
# AOC Day #5 Solution
# </> nils måsen, piksel bitworks

import sys
from hashlib import md5

PASSWORD_LENGTH = 8
SPINNER = list('0123456789abcdef')
#SPINNER = list('-/|\\')
SPINNER_COUNT = len(SPINNER)

def solution_one(door_id):
    counter = 0
    password = ''
    spinner_step = 0
    base_hash = md5(door_id.encode('utf8'))
    while len(password) < PASSWORD_LENGTH:
        hasher = base_hash.copy()
        hasher.update(str(counter).encode('utf8'))
        hashed = hasher.hexdigest()
        if hashed[:5] == '00000':
            password += hashed[5]

        if counter % 10000 == 0:
            spinner_step = (spinner_step + 1) % SPINNER_COUNT
            print('\r Part 1:', ''.join(password) + SPINNER[spinner_step], end=' ')

        counter += 1
    print('\r Part 1:', ''.join(password), ' ')

def solution_two(door_id):
    counter = 0
    password = list('--------')
    spinner_step = 0
    found = [False, False, False, False, False, False, False, False]
    base_hash = md5(door_id.encode('utf8'))
    while False in found:
        hasher = base_hash.copy()
        hasher.update(str(counter).encode('utf8'))
        hashed = hasher.hexdigest()
        if hashed[:5] == '00000':
            pos = int(hashed[5], 16)
            if pos < PASSWORD_LENGTH and not found[pos]:
                password[pos] = hashed[6]
                found[pos] = True
        if counter % 10000 == 0 or False not in found:
            spinner_step = (spinner_step + 1) % SPINNER_COUNT
            print('\r Part 2:', ''.join(password).replace('-', SPINNER[spinner_step]), end=' ')

        oldcounter = counter
        counter += 1
        if counter == oldcounter:
            print(counter)
            break
    print("")

def main():
    door_id = sys.argv[1]

    solution_one(door_id)
    solution_two(door_id)

if __name__ == '__main__':
    main()
