import hashlib


def generate_password(door_id):
    password = ''
    number = 0
    while len(password) < 8:
        hash_rep = hashlib.md5((door_id + str(number)).encode('utf-8')).hexdigest()
        if hash_rep.startswith('00000'):
            password += hash_rep[5]
        number += 1
    return password


def generate_scrambled_password(door_id):
    password = 8 * [None]
    number = 0
    while None in password:
        hash_rep = hashlib.md5((door_id + str(number)).encode('utf-8')).hexdigest()
        if hash_rep.startswith('00000') and hash_rep[5].isdigit() and \
                int(hash_rep[5]) < len(password) and password[int(hash_rep[5])] is None:
            password[int(hash_rep[5])] = hash_rep[6]
        number += 1
    return "".join(password)

if __name__ == '__main__':
    print('Password: %s' % generate_password('reyedfim'))
    print('Scrambled password: %s' % generate_scrambled_password('reyedfim'))
