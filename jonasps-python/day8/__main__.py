import os

dir_path = os.path.dirname(os.path.realpath(__file__))
filename = dir_path + "/data_day8.txt"
file = open(filename, "r")

x_max, y_max = 50, 6
display = [[0 for x in range(x_max)] for y in range(y_max)]


def format_string(format_string):
    return_list = []
    if "rect" in format_string:
        return_list = format_string.split("rect ", 1)[1].replace('x',' ').split()
    if "rotate row" in format_string:
        return_list = format_string.split("rotate row ", 1)[1].replace('y=', '').replace(' by ', ' ').split()
    if "rotate column" in format_string:
        return_list = format_string.split("rotate column ", 1)[1].replace('x=', '').replace(' by ', ' ').split()
    results_int = [int(i) for i in return_list] #return as integer
    return results_int


def pixels_lit(display):
    lit = 0
    for row in display:
        for pixel in row:
            if pixel == 1:
                lit += 1
    return lit

def rect(x,y):
    """ Takes the values x,y and set them as active pixels """
    for r in range(0,y):
        for p in range(0,x):
            display[r][p] = 1


def rotate_row(row, moves):
    if moves >= x_max:
        moves = moves % x_max
    move_these = display[row][-moves:]
    before_these = display[row][0:-moves]
    display[row] = list(move_these + before_these)


def rotate_column(column, moves):
    if moves >= y_max:
        moves = moves % y_max
    values = []
    for r in range(y_max):
        values.append(display[r][column])
    move_these = values[-moves:]
    before_these = values[0:-moves]
    values = list(move_these + before_these)
    for r in range(y_max):
        display[r][column] = values[r]



for row in file:
    results = format_string(str(row))
    if "rotate column" in row:
        rotate_column(results[0],results[1])
    if "rotate row" in row:
        rotate_row(results[0],results[1])
    if "rect " in row:
        rect(results[0],results[1])

#first answer
print(pixels_lit(display))

#second answer
#look in terminal
for row in display:
    print(str(row))