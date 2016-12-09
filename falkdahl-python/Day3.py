import re


def calcValidTriangles(triangles, groupVertically=False):

    # Re-format inputs using a regular expression
    triangleList = re.findall('(\d+)\s*(\d+)\s*(\d+)', triangles)

    # Flip list and group triangles vertically instead (for problem 2)
    if groupVertically:
        flippedTriangleList = []
        for row in range(0, len(triangleList), 3):
            for col in range(0, 3):
                newTriangle = (triangleList[row][col], triangleList[row+1][col], triangleList[row+2][col])
                flippedTriangleList.append(newTriangle)
        triangleList = flippedTriangleList

    # Count all invalid triangles in the list
    nInvalid = 0
    for item in triangleList:
        # Convert item to a list of float values
        triangle = [float(x) for x in item]

        # Check that all sides are smaller than sum of remaining sides
        for side in triangle:
            if sum(triangle) - side <= side:
                nInvalid += 1
                break

    # Return number of valid triangles in the list
    return len(triangleList) - nInvalid

if __name__ == '__main__':
    with open('Day3-input.txt') as f:
        triangles = f.read()

    print('Valid triangles: %d' % calcValidTriangles(triangles))
    print('Valid vertical triangles: %d' % calcValidTriangles(triangles, True))