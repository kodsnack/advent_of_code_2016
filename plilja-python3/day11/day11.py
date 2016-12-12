import sys
import re
from collections import *
from math import *

microchip_re = re.compile('\w+-compatible microchip')
generator_re = re.compile('\w+ generator')

def step1(inp):
    return solve(parse_floors())

def step2(inp):
    floors = parse_floors()
    free_number = 1000 # Can be any number, as long as it doesn't clash with the ones given by parse_floors
    floors = (floors[0] | {free_number, -free_number, free_number + 1, -free_number - 1}, ) + floors[1:]
    return solve(floors)

def solve(initial_floors):
    initial_floors = generify(initial_floors)
    visited = set()
    queue = []
    queue += [(0, initial_floors, 0)]
    # Do a BFS over the possible floor configurations. 
    # Graph edges are picks of one or to items. 
    while queue:
        dist, floors, floor_nr = queue[0]
        queue = queue[1:]

        if is_done(floors):
            return dist

        floor = floors[floor_nr]
        for pick in pick_one_or_two(floor):
            floor_after = floor - pick 
            if is_stable(floor_after):
                # Try to take items from pick up or down one floor
                for new_floor_nr in range(max(0, floor_nr - 1), min(4, floor_nr + 2)):
                    if floor_nr == new_floor_nr:
                        continue
                    new_floor_after = floors[new_floor_nr] | pick
                    if is_stable(new_floor_after):
                        new_floors = floors[:floor_nr] + (floor_after,) + floors[floor_nr + 1:]
                        new_floors = new_floors[:new_floor_nr] + (new_floor_after, ) + new_floors[new_floor_nr + 1:]
                        new_floors = generify(new_floors)
                        if (new_floor_nr, new_floors) not in visited:
                            visited |= {(new_floor_nr, new_floors)}
                            queue += [(dist + 1, new_floors, new_floor_nr)]

    return float('inf') # unsolvable

def parse_floors():
    floors = [frozenset() for i in range(0, 4)]
    d = {}
    j = 1
    for i in range(0, len(inp)):
        line = inp[i]
        floor = floors[i]
        for microchip in microchip_re.findall(line):
            element = microchip.split('-')[0]
            floor = floor | {j}
            d[element] = j
            j += 1
        floors[i] = (floor)
    for i in range(0, len(inp)):
        line = inp[i]
        floor = floors[i]
        for generator in generator_re.findall(line):
            element = generator.split(' ')[0]
            floor = floor | {-d[element]}
        floors[i] = (floor)
    return tuple(floors)

def is_done(floors):
    for floor in floors[0:3]:
        if len(floor) > 0:
            return False
    return True

def is_stable(floor):
    has_generator = False
    for item in floor:
        if is_generator(item):
            has_generator = True
            break
    if has_generator:
        for item in floor:
            if is_microship(item) and not -item in floor:
                return False
    return True

def pick_one_or_two(floor):
    r = []
    floor_list = list(floor)
    for i in range(0, len(floor_list)):
        r += [{floor_list[i]}]
        for j in range(i + 1, len(floor_list)):
            r += [{floor_list[i], floor_list[j]}]
    return r

def is_generator(item):
    return item < 0

def is_microship(item):
    return item > 0

def generify(floors):
    """
    There are several configurations that are equivalent. For performance reasons we
    want to test as few as possible. This methods maps floor configurations in a predictable
    way such that equivalent configurations are mapped to equal objects.

    For example:
    Floor 1: [cobalt generator, cobalt microship]
    Floor 2: [polonium generator, polonium microship]

    would be equivalent, at least as far as the algorithm is conserned, to:
    Floor 1: [polonium generator, polonium microship]
    Floor 2: [cobalt generator, cobalt microship]
    """
    new_floors = [frozenset() for f in floors]
    d = {}
    k = 1
    for i in range(0, len(floors)):
        floor = new_floors[i]
        gens = []
        micr = []
        for item in floors[i]:
            if -item in d:
                floor |= {-d[-item]}
            else:
                if is_generator(item):
                    gens += [item]
                else:
                    micr += [item]
        for g in gens:
            floor |= {-k}
            d[g] = -k
            k += 1
        for m in micr:
            if -m in d:
                floor |= {-d[-m]}
            else:
                floor |= {k}
                d[m] = k
                k += 1
        new_floors[i] = floor

    return tuple(new_floors)


inp = sys.stdin.readlines()
print('Step 1')
print(step1(inp))
print('This one is slow. Wait for it...', file=sys.stderr)
print('Step 2')
print(step2(inp))
