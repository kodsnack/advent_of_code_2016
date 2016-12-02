def getCodeNumber(currentPos):
	if currentPos == (3,5):
		return 1
	if currentPos == (2,4):
		return 2
	if currentPos == (3,4):
		return 3
	if currentPos == (4,4):
		return 4
	if currentPos == (1,3):
		return 5
	if currentPos == (2,3):
		return 6
	if currentPos == (3,3):
		return 7
	if currentPos == (4,3):
		return 8
	if currentPos == (5,3):
		return 9
	if currentPos == (2,2):
		return "A"
	if currentPos == (3,2):
		return "B"
	if currentPos == (4,2):
		return "C"
	if currentPos == (3,1):
		return "D"

def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

    currentPos = (3,1)

    for move in splitData:
    	for command in move:
    		if command == "U" and currentPos != (2,4) and currentPos != (4,4) and currentPos != (3,5) and currentPos != (1,3) and currentPos != (5,3):
    			#fine to move up
    			currentPos = (currentPos[0], currentPos[1]+1)
    		if command == "D" and currentPos != (1,3) and currentPos != (5,3) and currentPos != (2,2) and currentPos != (4,2) and currentPos != (3,1):
    			#fine to move down
    			currentPos = (currentPos[0], currentPos[1]-1)
    		if command == "R" and currentPos != (3,5) and currentPos != (4,4) and currentPos != (5,3) and currentPos != (4,2) and currentPos != (3,1):
    			#fine to move right
    			currentPos = (currentPos[0]+1, currentPos[1])
    		if command == "L" and currentPos != (3,5) and currentPos != (2,4) and currentPos != (1,3) and currentPos != (2,2) and currentPos != (3,1):
    			#fine to move left
    			currentPos = (currentPos[0]-1, currentPos[1])

    	print(getCodeNumber(currentPos))

if __name__ == "__main__":
    main()