#Viktor Ceder, Advent of Code 2016

def readFile(fileName):
    data = []
    file = open(fileName, 'r')
    for line in file:
        data.append(line.strip())
    return data

def countOccurence(data):
    counterDict = {}
    occurnaces = []
    #data = data.split('')
    for char in data:
        if char in counterDict.keys():
            counterDict[char] += 1
        else:
            counterDict[char] = 1
    for key in counterDict.keys():
        occurnaces.append([key, counterDict[key]])
    occurnaces.sort(key=lambda x: x[1], reverse=False)#True för att lösa u1, false för u2
    print(occurnaces)
    return occurnaces

def deScramble(data):
    tmp = ''
    finalWord = ''
    for i in range(len(data[0])):
        for row in data:
            tmp += row[i]
            #print(row[i])
        finalWord += countOccurence(tmp)[0][0]
        tmp = ''
    return finalWord

def main():
    testData = ['eedadn','drvtee','eandsr','raavrd','atevrs','tsrnev','sdttsa','rasrtv','nssdts','ntnada','svetve','tesnvt','vntsnd','vrdear','dvrsen','enarar']
    #print(deScramble(testData))
    data = readFile('input6.txt')
    #print(data)
    descrambled = deScramble(data)
    print(descrambled)


if __name__ == '__main__':
    main()
