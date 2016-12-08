def getcode(instructions, useAdvancedKeypad=False):

    if useAdvancedKeypad:
        keypad = [['',  '',   1,  '', ''],
                  ['',   2,   3,   4, ''],
                  [ 5,   6,   7,   8,  9],
                  ['', 'A', 'B', 'C', ''],
                  ['',  '', 'D',  '', '']]
        # Set starting key to number 5
        row = 2
        col = 0
    else:
        keypad = [[1, 2, 3],
                  [4, 5, 6],
                  [7, 8, 9]]
        # Set starting key to number 5
        row = 1
        col = 1

    # Loop trough all instructions and extract bathroom code
    code = []
    for line in instructions.splitlines():
        for move in line:
            if move == 'U' and row > 0:
                row = row-1 if keypad[row-1][col] != '' else row

            elif move == 'D' and row+1 < len(keypad):
                row = row+1 if keypad[row+1][col] != '' else row

            elif move == 'L' and col > 0:
                col = col-1 if keypad[row][col-1] != '' else col

            elif move == 'R' and col+1 < len(keypad[row]):
                col = col+1 if keypad[row][col+1] != '' else col

        code.append(keypad[row][col])

    return code

if __name__ == '__main__':

    # Read instructions from input file
    with open('Day2-input.txt') as f:
        instructions = f.read()

    # Get code to bathroom
    print(getcode(instructions))

    # Get code to bathroom with advanced keypad
    useAdvancedKeypad = True
    print(getcode(instructions, useAdvancedKeypad))
