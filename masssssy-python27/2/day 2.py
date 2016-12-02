def getCodeNumber(currentPos):
	if currentPos == (1,3):
		return 1
	if currentPos == (2,3):
		return 2
	if currentPos == (3,3):
		return 3
	if currentPos == (1,2):
		return 4
	if currentPos == (2,2):
		return 5
	if currentPos == (3,2):
		return 6
	if currentPos == (1,1):
		return 7
	if currentPos == (2,1):
		return 8
	if currentPos == (3,1):
		return 9


def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

    currentPos = (2,2)

    for move in splitData:
    	for command in move:
    		if command == "U" and currentPos[1] < 3:
    			currentPos = (currentPos[0], currentPos[1]+1)
    		if command == "R" and currentPos[0] < 3:
    			currentPos = (currentPos[0]+1, currentPos[1])
    		if command == "D" and currentPos[1] > 1:
    			currentPos = (currentPos[0], currentPos[1]-1)
    		if command == "L" and currentPos[0] > 1:
    			currentPos = (currentPos[0]-1, currentPos[1])

    	#End location for this move is now known as
    	#print(currentPos)

    	#Translate button presses into numbers
    	print(getCodeNumber(currentPos))



if __name__ == "__main__":
    main()