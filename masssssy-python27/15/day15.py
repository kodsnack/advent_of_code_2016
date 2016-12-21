import re
def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

    discs = []
    for disc in splitData:
    	digits = [int(s) for s in re.findall(r'\b\d+\b', disc)]
    	discs.append([digits[0], digits[1], digits[3]])
    disclen = len(discs) #Just add disk 7 in input file

    startTime = 0 
    found = False
    while found == False:
    	openlist = []
    	for disc in discs:
    		discPos = getDiscPosition(disc, startTime)
    		if discPos == 0:
    			openlist.append(discPos)
    			if len(openlist) == disclen:
    				print startTime
    				found = True
    		else:
    			break
    	startTime+=1

def getDiscPosition(disc, time):
	diskOffset = disc[0] #Disk 1 is processed one, disk2 twice etc...
	diskPositions = disc[1]
	diskStartPos = disc[2]

	#Calculate the current position of the disk
	reachedPos = (diskStartPos + time + diskOffset) % diskPositions
	return reachedPos

if __name__ == "__main__":
    main()