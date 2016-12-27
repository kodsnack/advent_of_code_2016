import re
def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")


    #generate 40 rows
    tiles = splitData[0].count('.')
    row = splitData[0]
    print row
    for x in range(0,399999):
    	row = generateRow(row)
    	print row
    	tiles += row.count('.')

    print tiles

def generateRow(rowAbove):
	rowLength = len(rowAbove)
	newRow = []
	for b in range(0, rowLength):
		if b == 0:
			left = "."
		else:
			left = rowAbove[b-1]

		if b == rowLength-1:
			right = "."
		else:
			right = rowAbove[b+1]
		center = rowAbove[b]

		#If clause of d00m
		if left == "^" and center == "^" and right != "^" or center == "^" and right == "^" and left != "^" or left == "^" and center != "^" and right != "^" or right == "^" and left != "^" and center != "^":
			newRow.append('^')
		else:
			newRow.append('.')
	return ''.join(newRow)

		




if __name__ == "__main__":
    main()