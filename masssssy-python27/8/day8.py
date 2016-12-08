import re

#Rotate lists right
def rotate(l, n):
    return l[-n:] + l[:-n]

def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

    pixelMatrix = [[0]*50 for _ in range(6)]
    for command in splitData:
    	if command[0:4] == "rect":
    		#create rect
    		values = [int(s) for s in re.findall(r'\d+', command)]
    		for column in range(0,values[0]):
    			for row in range(0,values[1]):
    				pixelMatrix[row][column] = 1
    	elif command[0:10] == "rotate row":
            #values = (row, how much)
            values = [int(s) for s in re.findall(r'\d+', command)]
            pixelMatrix[values[0]] = rotate(pixelMatrix[values[0]], values[1])
        else:
            #rotate column, values =(column, how much)
            values = [int(s) for s in re.findall(r'\d+', command)]
            tempCol = []
            for row in pixelMatrix:
                tempCol.append(row[values[0]])
            tempCol = rotate(tempCol, values[1])

            b=0
            for row in pixelMatrix:
                row[values[0]] = tempCol[b]
                b+=1
    
    #Print visual
    str = ""
    for row in pixelMatrix:
        for element in row:
            if element == 1:
                str += "#"
            else:
                str += "."
        str +="\n"
    print str
    #Count lit pixels
    litPixels = 0
    for row in pixelMatrix:
        for pixel in row:
            if pixel == 1:
                litPixels +=1

    print litPixels
   			

if __name__ == "__main__":
    main()