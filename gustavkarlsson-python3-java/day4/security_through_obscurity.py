""" Advent of Code 2016 - Day 4 - Security Through Obscurity """

import re
from collections import Counter


def get_room_name(room):
    index = room.rfind('-')
    return room[:index]


def get_serial_id(room):
    start, end = re.search(r"\d+", room).span()
    return int(room[start:end])


def get_checksum(room):
    return re.findall(r"\w{5}", room)[-1]


def is_real_room(room, checksum):
    room = room.replace('-', '')
    count = Counter(room)
    # Sort by dict value, and then by key, and then get the first 5 chars.
    correct_checksum = [v[0] for v in sorted(count.items(), key=lambda kv: (-kv[1], kv[0]))][:5]
    if checksum == ''.join(correct_checksum):
        return True
    return False


def main():
    with open('input4.txt', 'r') as fh:
        rooms = fh.readlines()

    id_sum = 0
    for room in rooms:
        name = get_room_name(room)
        serial_id = get_serial_id(room)
        checksum = get_checksum(room)

        if is_real_room(name, checksum):
            id_sum += serial_id

    print(id_sum)


if __name__ == '__main__':
    main()
