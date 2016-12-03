import os

# read in the data
dir_path = os.path.dirname(os.path.realpath(__file__))
filename = dir_path + "/data_day1.txt"
file = open(filename, 'r')
instruction_list = str(file.read()).split(",")


class Player:
    def __init__(self):
        self.direction = 'north'
        self.coordinates = [0,0]
        self.correct_place = []
        self.visited_places = ['[0,0]']

    def get_first_visited_location(self):
        memory = []
        duplicates = []

        for elements in self.visited_places:
            if elements in memory:
                duplicates.append(elements)
            memory.append(elements)
        return [int(duplicates[0][1:-1].split(",")[0]) , int(duplicates[0][1:-1].split(",")[1])]

    def calculate_move(self, instruction):
        movement, number_of_moves = instruction[0], instruction[1:]

        if self.direction == 'north':
            if movement == 'L':
                return ['west', number_of_moves]
            if movement == 'R':
                return ['east', number_of_moves]

        if self.direction == 'south':
            if movement == 'L':
                return ['east', number_of_moves]
            if movement == 'R':
                return ['west', number_of_moves]

        if self.direction == 'east':
            if movement == 'L':
                return ['north', number_of_moves]
            if movement == 'R':
                return ['south', number_of_moves]

        if self.direction == 'west':
            if movement == 'L':
                return ['south', number_of_moves]
            if movement == 'R':
                return ['north', number_of_moves]

    def make_move(self, instruction):
        list_answer = self.calculate_move(instruction)
        self.direction = list_answer[0]
        steps = int(list_answer[1])

        if self.direction == 'north':
            for i in range(0, steps):
                self.coordinates[1] += 1
                self.visited_places.extend([str(self.coordinates)])
        if self.direction == 'south':
            for i in range(0, steps):
                self.coordinates[1] -= 1
                self.visited_places.extend([str(self.coordinates)])
        if self.direction == 'east':
            for i in range(0, steps):
                self.coordinates[0] += 1
                self.visited_places.extend([str(self.coordinates)])
        if self.direction == 'west':
            for i in range(0, steps):
                self.coordinates[0] -= 1
                self.visited_places.extend([str(self.coordinates)])



me = Player()

counter = 1
for instruction in instruction_list:
    me.make_move(instruction.strip())

#(abs turn all integars to positive numbers)

# first answer
print(sum(map(abs,me.coordinates)))

# second answer
print(sum(map(abs,me.get_first_visited_location())))



