import re
import sys
from collections import Counter


def get_valid_rooms(pinput):
    def only_valid_rooms(l):
        code, id, checksum = re.match(r'^(\D+)(\d+)\[(\D+?)\]$', l.translate({ord('-'): None})).groups()
        mc = Counter(code).most_common()
        mc_sorted = sorted(mc, key=lambda e: (-e[1], e[0]))  # because FU, Counter default sort ...
        return ''.join(map(lambda x: x[0], mc_sorted)).startswith(checksum)

    return filter(only_valid_rooms, pinput.splitlines())


def sum_sector_ids(puzzle):
    return sum(map(int, map(lambda l: re.match(r'.+-(\d+)\[', l).group(1),
                            get_valid_rooms(puzzle))))


def decrypt_name(ciphered, id):
    v = ''
    for c in ciphered:
        dec = ord(c) + (id % 26)
        if dec > 122:
            dec -= 26
        v += ' ' if c == '-' else chr(dec)
    return v


def find_np_room(pinput):
    rooms = get_valid_rooms(pinput)
    for r in rooms:
        code, sid = re.match(r'^(\D+)-(\d+)\[', r).groups()
        decrypted = decrypt_name(code, int(sid))
        if decrypted == 'northpole object storage':
            return sid


def run(pinput):
    """Day 4: Security Through Obscurity"""
    s = sum_sector_ids(pinput)
    np = find_np_room(pinput)

    print('Sum of sector IDs, real rooms:          %s' % s)
    print('Section ID for North Pole storage:      %s' % np)


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
    except IndexError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
