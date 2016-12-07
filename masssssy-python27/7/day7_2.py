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
        abas = []
        lookfor = []
        for nonbracket in entry[0]:
            for x in range(0, len(nonbracket)-2):
                if nonbracket[x] == nonbracket[x+2] and nonbracket[x+1] != nonbracket[x]:
                    #ABA found
                    abastr = nonbracket[x] + nonbracket[x+1] + nonbracket[x+2]
                    abas.append(abastr)
                    lookforstr = nonbracket[x+1] + nonbracket[x] + nonbracket[x+1]
                    lookfor.append(lookforstr)
        #print lookfor
        #print abas

        isOk = False
        for bracket in entry[1]:
            for y in range(1, len(bracket)-3):
                mystr = bracket[y] + bracket[y+1] + bracket[y+2]
                if any(mystr in s for s in lookfor):
                    isOk = True
        if isOk == True:
            valid+=1

    print valid

if __name__ == "__main__":
    main()

                      #  isOk = False
                    #for bracket in entry[1]:
                        #
                            #if bracket[x] == nonbracket[x+1] and bracket[x+1] == nonbracket[x] and bracket[x+2] == nonbracket[x+1]:
                                #found bab
                                #isOk = True