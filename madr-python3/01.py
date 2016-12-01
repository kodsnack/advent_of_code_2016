import sys


def get_distance(start, current):
    distance = abs(start[0] - current[0]) + abs(start[1] - current[1])
    if distance < 0:
        distance = distance.__neg__()
    return distance


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


def check_history(hist, direction, distance):
    pos = hist[-1]
    recurrence = None

    for i in range(1, distance + 1):
        if direction == 'N':
            pos, f = go_north(pos, 1)
        if direction == 'W':
            pos, f = go_west(pos, 1)
        if direction == 'S':
            pos, f = go_south(pos, 1)
        if direction == 'E':
            pos, f = go_east(pos, 1)

        if not recurrence and pos in hist:
            recurrence = pos

        hist.append(pos)

    return hist, recurrence


def direct_santa(starting_block, data):
    directions = data.split(', ')

    gone_in_circle_at = None
    current_block = starting_block
    f = 'N'
    hist = [starting_block]

    for d in directions:
        distance = int(d[1:])
        current_block, f = go_left(current_block, f, distance) if d.startswith('L') else go_right(current_block, f,
                                                                                                  distance)
        hist, recurrence = check_history(hist, f, distance)

        if not gone_in_circle_at and recurrence:
            gone_in_circle_at = recurrence

    distance_from_santa = get_distance(starting_block, current_block)
    print(distance_from_santa)

    distance_from_gone_in_circle_at = get_distance(starting_block, gone_in_circle_at)
    print(distance_from_gone_in_circle_at)


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as directions:
            direct_santa((0, 0), directions.read())
    except IOError:
        print('please provide a file path to directions, example: ./directions.txt')
