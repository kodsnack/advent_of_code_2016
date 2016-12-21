
# AOC Day #3 Solution
# </> nils måsen, piksel bitworks

import sys

def solution_one(lines):

    possible = 0

    for line in lines:
        vector = [int(line[:5]), int(line[5:10]), int(line[10:])]
        if triangle_possible(vector):
            possible += 1

    return possible

def solution_two(lines):

    possible = 0

    for base_row in range(0, len(lines) // 3):
        vector = [0, 0, 0]
        for row in range(0, 3):
            vector[0] = int(lines[(base_row*3)+0][row*5:(row+1)*5])
            vector[1] = int(lines[(base_row*3)+1][row*5:(row+1)*5])
            vector[2] = int(lines[(base_row*3)+2][row*5:(row+1)*5])
            if triangle_possible(vector):
                possible += 1

    return possible

def triangle_possible(vec):
    return vec[0] + vec[1] > vec[2] and vec[1] + vec[2] > vec[0] and vec[0] + vec[2] > vec[1]

def load_instructions(input_file):
    file = open(input_file, mode='r')
    return file.readlines()

def main():
    lines = load_instructions(sys.argv[1])

    print("Part 1:", solution_one(lines))
    print("Part 2:", solution_two(lines))

if __name__ == '__main__':
    main()