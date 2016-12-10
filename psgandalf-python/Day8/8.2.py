# Advent of code 2016 from http://adventofcode.com/2016
# Day 8 part 1

grid_cols = 50
grid_rows = 6
grid =[]
row = []
col = []
answ = 0

def rotate(l, n):
    return l[-n:] + l[:-n]

for rows in range(0, grid_rows):
    for cols in range(0, grid_cols):
        row.append(' ')
    grid.append(row)
    row = []

file = open('8.1_input.txt', 'r')
for line in file:
    line = line.rstrip()
    in_row = line.split(' ')
    if in_row[0] != 'rect':
        coord = in_row[2].split('=')
        if in_row[1] == 'row':
            grid[int(coord[1])] = rotate(grid[int(coord[1])], int(in_row[4]))
        else:
            for rows in range(0, grid_rows):
                col.append(grid[rows][int(coord[1])])
            col = rotate(col, int(in_row[4]))
            for rows in range(0, grid_rows):
                grid[rows][int(coord[1])] = col[rows]
            col = []
    else:
        rect = in_row[1].split('x')
        for cols in range(0, int(rect[1])):
            for rows in range(0, int(rect[0])):
                grid[cols][rows] = '8'
for lists in grid:
    print ''.join(lists)
