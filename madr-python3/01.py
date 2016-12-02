import sys
from random import randint


def get_distance(start, current):
    return abs(abs(start[0] - current[0]) + abs(start[1] - current[1]))


def go_north(current_block, distance):
    return (current_block[0] - distance, current_block[1]), 'N'


def go_south(current_block, distance):
    return (current_block[0] + distance, current_block[1]), 'S'


def go_west(current_block, distance):
    return (current_block[0], current_block[1] - distance), 'W'


def go_east(current_block, distance):
    return (current_block[0], current_block[1] + distance), 'E'


def go_left(current_block, facing_direction, distance):
    if facing_direction == 'N':
        return go_west(current_block, distance)
    if facing_direction == 'W':
        return go_south(current_block, distance)
    if facing_direction == 'S':
        return go_east(current_block, distance)
    if facing_direction == 'E':
        return go_north(current_block, distance)


def go_right(current_block, facing_direction, distance):
    if facing_direction == 'N':
        return go_east(current_block, distance)
    if facing_direction == 'E':
        return go_south(current_block, distance)
    if facing_direction == 'S':
        return go_west(current_block, distance)
    if facing_direction == 'W':
        return go_north(current_block, distance)


def track_santa(tracks, direction, distance):
    pos = tracks[-1]
    recurrence = None

    i = 0
    while i < distance:
        if direction == 'N':
            pos, f = go_north(pos, 1)
        if direction == 'W':
            pos, f = go_west(pos, 1)
        if direction == 'S':
            pos, f = go_south(pos, 1)
        if direction == 'E':
            pos, f = go_east(pos, 1)

        if not recurrence and pos in tracks:
            recurrence = pos

        tracks.append(pos)
        i += 1

    return tracks, recurrence


def direct_santa(starting_block, directions):
    gone_in_circle_at = None
    current_block = starting_block
    facing = 'N'
    tracks = [starting_block]

    for d in directions.split(', '):
        distance = int(d[1:])
        current_block, facing = go_left(current_block, facing, distance) if d.startswith('L') else go_right(
            current_block, facing, distance)
        tracks, recurrence = track_santa(tracks, facing, distance)

        if not gone_in_circle_at and recurrence:
            gone_in_circle_at = recurrence

    distance_from_santa = get_distance(starting_block, current_block)
    print(distance_from_santa)

    distance_from_gone_in_circle_at = get_distance(starting_block, gone_in_circle_at)
    print(distance_from_gone_in_circle_at)


if __name__ == '__main__':
    santa_starting_position = (randint(-1024, 1024), randint(-1024, 1024))
    try:
        with open(sys.argv[1], 'r') as directions:
            direct_santa(santa_starting_position, directions.read())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
