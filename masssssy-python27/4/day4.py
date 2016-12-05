import re
import collections

def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

    #print splitData

    data = []
    for row in splitData:
    	#Shitty string rewrites
    	row = row.replace('-', '')
    	checksum = row[row.find("[")+1 : row.find("]")]
    	row = row[:row.find("[")] + row[row.find("]")]
    	row = row[:-1]

    	match = re.match(r"([a-z]+)([0-9]+)", row, re.I)
    	if match:
    		items = match.groups()
    	data.append([items[0], items[1], checksum])

    sectorSum = 0
    for entry in data:	
	    todo = entry
	    print todo
	    todoStr = todo[0]
	    mostFive = []
	    while len(todoStr) > 0:
		    a = collections.Counter(todoStr).most_common(1)[0]
		    todoStr = todoStr.replace(a[0], "")
		    mostFive.append([a[0], a[1]])

	    mostFive = sorted(sorted(mostFive, key = lambda x : x[0]), key = lambda x : x[1], reverse = True)
	    print mostFive
	    valid = True
	    for x in range(0,5):
	    	if todo[2][x] != mostFive[x][0]:
	    		valid = False
	    if valid == True:
	    	sectorSum += int(todo[1]) 	
    print sectorSum
if __name__ == "__main__":
    main()