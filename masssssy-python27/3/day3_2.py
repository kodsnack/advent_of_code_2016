def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

    goodData = []
    for posTriangle in splitData:
        tri1 = posTriangle[2:5]
        tri2 = posTriangle[7:10]
        tri3 = posTriangle[12:15]

        triangle = [tri1,tri2,tri3]
        goodData.append(triangle)

    triangles = []
    for row in range(0, len(goodData)-2, 3):
        triangles.append([goodData[row][0], goodData[row+1][0], goodData[row+2][0]])
        triangles.append([goodData[row][1], goodData[row+1][1], goodData[row+2][1]])
        triangles.append([goodData[row][2], goodData[row+1][2], goodData[row+2][2]])

    validTriangles = 0
    invalidTriangles = 0
    print(len(triangles))
    for triangle in triangles:
            if int(triangle[0]) + int(triangle[1]) > int(triangle[2]) and int(triangle[0]) + int(triangle[2]) > int(triangle[1]) and int(triangle[1]) + int(triangle[2]) > int(triangle[0]):
                validTriangles+=1
            else:
                invalidTriangles+=1

    print validTriangles
    print invalidTriangles

        

if __name__ == "__main__":
    main()