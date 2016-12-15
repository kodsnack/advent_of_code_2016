import sys
from collections import Counter, namedtuple

Room = namedtuple('Room', 'encrypted_name sector_id checksum')


def read_rooms():
    def parse_room(room_str):
        room_str = room_str.strip()
        parts = room_str.split('-')
        sector_id, checksum = parts[-1][:-1].split('[')
        sector_id = int(sector_id)
        encrypted_name = '-'.join(parts[:-1])
        return Room(encrypted_name, sector_id, checksum)

    def is_real_room(room):
        counter = Counter(room.encrypted_name)
        alphabet = [chr(ord('a') + i) for i in range(0, 26)]
        most_common = sorted(alphabet, key=lambda x: (-counter[x], x))
        for c1, c2 in zip(room.checksum, most_common):
            if c1 != c2:
                return False
        return True

    r = []
    for line in sys.stdin.readlines():
        room = parse_room(line)
        if is_real_room(room):
            r += [room]
    return r


def step1(rooms):
    return sum(map(lambda room: room.sector_id, rooms))


def step2(rooms):
    def decrypt(room):
        r = ''
        for c in room.encrypted_name:
            if c == '-':
                r += ' '
            else:
                r += chr(ord('a') + ((ord(c) - ord('a') + room.sector_id) % 26))
        return r

    for room in rooms:
        if 'northpole' in decrypt(room):
            return room.sector_id
    return -1


rooms = read_rooms()
print(step1(rooms))
print(step2(rooms))
