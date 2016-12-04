import re
import sys
from collections import Counter


def get_valid_rooms(puzzle):
    def only_valid_rooms(l):
        code, id, checksum = re.match(r'^(\D+)(\d+)\[(\D+?)\]$', l.translate({ord('-'): None})).groups()
        most_common = ''.join(map(lambda x: x[0], sorted(Counter(code).most_common(), key=lambda e: (-e[1], e[0]))))
        return most_common.startswith(checksum)

    return filter(only_valid_rooms, puzzle.splitlines())


def sum_sector_ids(puzzle):
    return sum(map(int, map(lambda l: re.match(r'^(\D+)(\d+)\[(\D+?)\]$', l.translate({ord('-'): None})).group(2),
                            get_valid_rooms(puzzle))))


def decrypt_name(ciphered, id):
    v = ''
    for c in ciphered:
        dec = ord(c) + (id % 26)
        if dec > 122:
            dec -= 26
        v += ' ' if c == '-' else chr(dec)
    return v


def find_np_room(puzzle):
    rooms = get_valid_rooms(puzzle)
    for r in rooms:
        code, id, checksum = re.match(r'^(\D+)-(\d+)\[(\D+?)\]$', r).groups()
        decrypted = decrypt_name(code, int(id))
        if decrypted == 'northpole object storage':
            return id


def run(puzzle):
    """Day 4: Security Through Obscurity"""
    s = sum_sector_ids(puzzle)
    np = find_np_room(puzzle)

    print('Sum of sector IDs, real rooms:          %s' % s)
    print('Section ID for North Pole storage:      %s' % np)


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
