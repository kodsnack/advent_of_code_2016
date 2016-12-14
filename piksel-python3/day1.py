
# AOC Day #1 Solution
# </> nils måsen, piksel bitworks

def load_instructions(input_file):
    file = open(input_file, mode='r')
    lines = file.readlines()
    return lines[0].split(', ')

def solution_one(input_file):

    current_direction = 0
    steps = [0, 0, 0, 0]

    for instruction in load_instructions(input_file):

        turn = instruction[:1]
        steps_in_direction = int(instruction[1:])

        current_direction = (current_direction + (1 if turn == 'R' else -1)) % 4

        steps[current_direction] += steps_in_direction

    return abs(steps[0] - steps[2]) + abs(steps[1] - steps[3])

def solution_two(input_file):

    current_direction = 0
    position = [0, 0]
    visited = list()

    for instruction in load_instructions(input_file):

        turn = instruction[:1]
        steps_in_direction = int(instruction[1:])

        current_direction = (current_direction + (1 if turn == 'R' else -1)) % 4

        while steps_in_direction > 0:
            position[current_direction % 2] += -1 if current_direction > 1 else 1
            steps_in_direction -= 1

            if position in visited:
                return abs(position[0]) + abs(position[1])
            else:
                visited.append(position[:])


if __name__ == '__main__':
    print("Part 1:", solution_one('input.txt'))
    print("Part 2:", solution_two('input.txt'))


