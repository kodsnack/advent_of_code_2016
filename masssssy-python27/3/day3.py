def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

    goodData = []
    for posTriangle in splitData:
    	goodData.append(posTriangle.split("  "))

    validTriangles = 0
    invalidTriangles = 0
    for triangle in goodData:
    	triangle = [x for x in triangle if x != '']
    	triangle = [x.strip(' ') for x in triangle]
    	print triangle
    	if int(triangle[0]) + int(triangle[1]) > int(triangle[2]) and int(triangle[0]) + int(triangle[2]) > int(triangle[1]) and int(triangle[1]) + int(triangle[2]) > int(triangle[0]):
    		validTriangles+=1
    	else:
    		invalidTriangles+=1

    print validTriangles
    print invalidTriangles

if __name__ == "__main__":
    main()