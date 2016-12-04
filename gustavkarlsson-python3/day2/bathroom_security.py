""" Advent of Code 2016 - Day 2 - Bathroom Security"""
def main():
    keypad = [[1, 2, 3],
              [4, 5, 6],
              [7, 8, 9]]

    pos = {'x': 1, 'y': 1}

    with open('../inputs/day2_input.txt', 'r') as fh:
        inputs = fh.readlines()

    for line in inputs:
        moves = list(line)
        for m in moves:
            if m == 'U':
                if pos['x'] == 0:
                    continue
                else:
                    pos['x'] -= 1

            elif m == 'D':
                if pos['x'] == 2:
                    continue
                else:
                    pos['x'] += 1

            elif m == 'L':
                if pos['y'] == 0:
                    continue
                else:
                    pos['y'] -= 1

            elif m == 'R':
                if pos['y'] == 2:
                    continue
                else:
                    pos['y'] += 1

        print(keypad[pos['x']][pos['y']], end='')


if __name__ == '__main__':
    main()
