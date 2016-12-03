"""" Advent of Code 2016 - Day 3 - Squares with Three Sides """


def is_valid_triangle(a, b, c):
    if a + b > c and a + c > b and c + b > a:
        return True
    return False


def main():
    with open('input3.txt', 'r') as fh:
        triangles = fh.readlines()

    valid = 0

    for l in triangles:
        a, b, c = [int(x) for x in l.split()]
        if is_valid_triangle(a, b, c):
            valid += 1

    print(valid)


if __name__ == '__main__':
    main()
