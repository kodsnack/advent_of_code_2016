
# AOC Day #2 Solution
# </> nils måsen, piksel bitworks

import sys

def load_instructions(input_file):
    file = open(input_file, mode='r')
    lines = file.readlines()
    return lines

DIRECTION_VECTORS = {
    'U': [ 0,-1],
    'R': [ 1, 0],
    'D': [ 0, 1],
    'L': [-1, 0]
}

KEYPAD = [
    '  1  ',
    ' 234 ',
    '56789',
    ' ABC ',
    '  D  '
]

def solution_one(instructions):

    button_pos = [1, 1]
    digits = ""

    for line in instructions:
        for dir_symbol in line:
            if dir_symbol == '\n':
                continue
            dir_vector = DIRECTION_VECTORS[dir_symbol]
            button_pos[0] = max(0, min(2, button_pos[0] + dir_vector[0]))
            button_pos[1] = max(0, min(2, button_pos[1] + dir_vector[1]))

        digits += str(button_pos[1]*3 + button_pos[0] + 1)
    return digits



def solution_two(instructions):
    button_pos = [0, 2]
    digits = ""

    for line in instructions:
        for dir_symbol in line:
            if dir_symbol == '\n':
                continue
            dir_vector = DIRECTION_VECTORS[dir_symbol]
            x_lim = abs(button_pos[1] - 2)
            y_lim = abs(button_pos[0] - 2)

            button_pos[0] = max(0 + x_lim, min(4 - x_lim, button_pos[0] + dir_vector[0]))
            button_pos[1] = max(0 + y_lim, min(4 - y_lim, button_pos[1] + dir_vector[1]))

        digits += KEYPAD[button_pos[1]][button_pos[0]]
    return digits

if __name__ == '__main__':
    main()

def main():
    instructions = load_instructions(sys.argv[1])

    print("Part 1:", solution_one(instructions))
    print("Part 2:", solution_two(instructions))


