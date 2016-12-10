def possible_triangle(triangle):
    return triangle[0] + triangle[1] > triangle[2] and \
           triangle[0] + triangle[2] > triangle[1] and \
           triangle[1] + triangle[2] > triangle[0]

def solve(file):
    valid = 0

    for line in file:
        triangle = [int(s) for s in line.split()]
        if possible_triangle(triangle):
           valid += 1
    print(valid)

    file.seek(0)
    valid = 0

    lines = file.readlines()

    for i in range(0, len(lines), 3):
        triangles = [line.split() for line in lines[i:i + 3]]
        triangles = list(zip(*triangles[::-1]))

        for triangle in triangles:
            triangle = list(map(int, list(triangle)))

            if possible_triangle(triangle):
                valid += 1
    print(valid)

with open('data/03.txt', 'r') as file:
    solve(file)
