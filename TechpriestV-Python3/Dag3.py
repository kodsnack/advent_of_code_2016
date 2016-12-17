#Viktor Ceder, Advent of Code 2016

def fileRead(fileName):
    fileData = []
    file = open(fileName, 'r')
    for line in file:
        tmp = line.split()
        for i in range(len(tmp)):
            tmp[i] = int(tmp[i])
        fileData.append(tmp)
    return fileData

def validateTriangle(messurments):
    tmp = sorted(messurments)
    return tmp[0] + tmp[1] > tmp[2]

def countTriangles(data):
    possible = 0
    for i in data:
        if validateTriangle(i):
            possible+=1
    return possible

def countColumTriangle(data):
    possible = 0
    for i in range(0,len(data), 3):
        for j in range(len(data[i])):
            tmp = [data[i][j], data[i+1][j], data[i+2][j]]
            if validateTriangle(tmp):
                possible += 1
    return possible

def main():
    instructions = fileRead('input3.txt')
    solution1 = countTriangles(instructions)
    solution2 = countColumTriangle(instructions)
    print(solution1)
    print(solution2)

if __name__ == '__main__':
    main()
