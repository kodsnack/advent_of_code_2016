#Viktor Ceder, Advent of Code 2016

def readFile(fileName):
    data = []
    file = open(fileName, 'r')
    for line in file:
        data.append(line.strip())
    return data

def validIPTLS(ip):
    inside = False
    possible = False
    for i in  range(len(ip)):
        if ip[i] == '[':
            inside = True
        elif ip[i] == ']':
            inside = False
        else:
            try:
                if ip[i]+ip[i+1] == ip[i+3] + ip[i+2] and ip[i] != ip[i+1]:
                    if inside:
                        return False
                    else:
                        possible = True
            except IndexError:
                pass
    return possible

def validIPSSL(ip):
    inside = False
    possible = False
    possibleMatches = []
    insideData = []
    for i in  range(len(ip)):
        if ip[i] == '[':
            inside = True
        elif ip[i] == ']':
            inside = False
        elif inside:
            insideData.append(ip[i])
        else:
            try:
                if ip[i]+ip[i+1]+ip[i+2]== ip[i+2]+ip[i+1]+ip[i] and ip[i] != ip[i+1] and ip[i] == ip[i+2]:
                    possibleMatches.append(ip[i]+ip[i+1]+ip[i+2])
            except IndexError:
                pass
    for i in range(len(insideData)):
        try:
            tmp = insideData[i]+insideData[i+1]+insideData[i+2]
            if insideData[i]==insideData[i+2]:
                if insideData[i+1]+insideData[i+2]+insideData[i+1] in possibleMatches:
                    possible = True
        except IndexError:
            pass
    return possible


def main():
    testData =['abba[mnop]qrst', 'abcd[bddb]xyyx','aaaa[qwer]tyui','ioxxoj[asdfgh]zxcvbn']

    testData2 = readFile('input7test.txt')

    data = readFile('input7.txt')

    test = 'abaccc[cccbab]'

    #print(validIPSSL(test))
    i = 0
    for row in data:
        if validIPTLS(row):
            i += 1
    print("Valid TLS: " + str(i))
    i = 0
    for row in data:
        if validIPSSL(row):
            i += 1
    print("Valid SSL: " + str(i))
if __name__ == '__main__':
    main()
