import re
def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

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

    decodedList = []
    for sentence in data:
    	sentence2 = sentence[0]
    	spin = sentence[1]
    	newSentence=[]
    	for char in sentence2:
    		 newSentence.append(chr( (((ord(char)-97) + int(spin) % 26) % 26) + 97))
    	decodedList.append(''.join(newSentence))
    	print decodedList[-1:]
    	if decodedList[-1:][0] == "northpoleobjectstorage":
    		result = "Room id is: " + str(sentence[1])

    print result

if __name__ == "__main__":
    main()
