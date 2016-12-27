def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()
    splitData = inputdata.split("\n")

    scramble = list("abcdefgh")

    
    for instr in splitData:
    	splitInstr = instr.split(" ")
    	if splitInstr[0] == "swap":
    		if splitInstr[1] == "position":
    			fromTo=[int(s) for s in instr.split() if s.isdigit()]
    			scramble = swap(scramble, fromTo[0], fromTo[1])
    		else:
    			index1 = scramble.index(splitInstr[2])
    			index2 = scramble.index(splitInstr[5])
    			scramble = swap(scramble, index1, index2)

    	elif splitInstr[0] == "rotate":
    		if splitInstr[1] == "based":
    			letter = splitInstr[-1:]
    			amount = scramble.index(letter[0])

    			scramble = rotate(scramble, "R", 1+amount)
    			if amount >= 4:
    				scramble = rotate(scramble, "R", 1)
    		else:
    			steps =[int(s) for s in instr.split() if s.isdigit()][0]
    			if splitInstr[1] == "left":
    				scramble = rotate(scramble, "L", steps)
    			else:
    				scramble = rotate(scramble, "R", steps)

    	elif splitInstr[0] == "move":
    		fromTo =[int(s) for s in instr.split() if s.isdigit()]
    		scramble = move(scramble, fromTo[0], fromTo[1])
    	elif splitInstr[0] == "reverse":
    		fromTo=[int(s) for s in instr.split() if s.isdigit()]
    		scramble = reverse(scramble, fromTo[0], fromTo[1])
    	print scramble
    #print ''.join(scramble)

def reverse(string, startPos, endPos):
	before = string[0:startPos]
	after = string[endPos+1:]
	toReverse = string[startPos:endPos+1]
	reverse = toReverse[::-1]
	return 	before + reverse + after

def move(string, fromIndex, toIndex):
	p1 = string[:fromIndex]
	p2 = string[fromIndex+1:]
	removed = p1+p2
	string = removed[0:toIndex] + [string[fromIndex]] + removed[toIndex:]
	return string

def swap(string, index1, index2):
	in1 = string[index1]
	string[index1] = string[index2]
	string[index2] = in1
	return string

def rotate(string, direction, amount):
	if direction == "R":
		string = string[-amount:] + string[:-amount]
	else:
		string = string[amount:] + string[:amount]
	return string

main()



