"""" Advent of Code 2016 - Day 1 - No Time for a Taxicab """


class Problem1(object):
    def __init__(self):
        pass

    directions = ['North', 'East', 'South', 'West']
    current_direction = 0
    list_length = len(directions)

    def get_current_direction(self) -> int:
        return self.current_direction

    def get_current_direction_name(self) -> str:
        return self.directions[self.get_current_direction()]

    def set_current_direction(self, dir) -> None:
        self.current_direction = dir

    def turn_left(self) -> None:
        direction = self.get_current_direction()
        self.set_current_direction((direction - 1) % self.list_length)

    def turn_right(self) -> None:
        dir = self.get_current_direction()
        self.set_current_direction((dir + 1) % self.list_length)

    def is_left_move(self, move) -> bool:
        l = move[0]
        if l == 'L':
            return True
        else:
            return False

    def is_right_move(self, move) -> bool:
        l = move[0]
        if l == 'R':
            return True
        else:
            return False

    """ Gets the number of blocks moved in a move. """

    def get_move_blocks(self, move) -> int:
        return int(move[1:])

    """ Gets the direction facing after completing a move. """

    def get_move_direction(self, move) -> int:
        dir = self.get_current_direction()

        if self.is_left_move(move):
            dir = (dir - 1) % self.list_length
            self.set_current_direction(dir)
        elif self.is_right_move(move):
            dir = (dir + 1) % self.list_length
            self.set_current_direction(dir)

        return dir


def main():
    p = Problem1()

    north_blocks = 0
    east_blocks = 0
    south_blocks = 0
    west_blocks = 0

    with open('../inputs/day1_input.txt', 'r') as fh:
        moves = fh.readline().split(', ')

    for move in moves:
        dir = p.get_move_direction(move)
        blocks = p.get_move_blocks(move)

        if dir == 0:
            north_blocks += blocks
        elif dir == 1:
            east_blocks += blocks
        elif dir == 2:
            south_blocks += blocks
        elif dir == 3:
            west_blocks += blocks

    horizontal_blocks = abs(north_blocks - south_blocks)
    vertical_blocks = abs(east_blocks - west_blocks)
    print(horizontal_blocks + vertical_blocks)


if __name__ == '__main__':
    main()
