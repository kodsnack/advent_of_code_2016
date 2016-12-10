import re
import collections

def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

    row = splitData[0]

    newData = []
    for row in splitData:
        brackets = []
        nonBrackets = []
        while row[row.find("[") : row.find("]")+1] != "":
            bracket = row[row.find("[") : row.find("]")+1]
            row = row.replace(bracket, "-")
            brackets.append(bracket)
        nonBrackets = row.split("-")
        newData.append([nonBrackets, brackets])

    #TIMECOMPLEXITY = INFIINTY?! Oh well.. whatevs
    valid = 0
    for entry in newData:
        isFine = True
        brackets = entry[1]
        for bracket in brackets:
            for x in range (1, len(bracket)-4):
                str2 = bracket[x] + bracket[x+1] + bracket[x+2] + bracket[x+3]
                if str2 == str2[::-1] and len(set(str2)) > 1:
                    #found abba
                    isFine = False
        if isFine == True:
            isOk = False
            print "next"
            #check if non brackets is valid
            for input in entry[0]:
                for x in range (0, len(input)-3):
                    str2 = input[x] + input[x+1] + input[x+2] + input[x+3]
                    if str2 == str2[::-1] and len(set(str2)) > 1:
                        isOk = True
            if isOk == True:
                valid+=1
    print valid
if __name__ == "__main__":
    main()