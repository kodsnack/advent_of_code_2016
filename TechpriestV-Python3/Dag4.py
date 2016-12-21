#Viktor Ceder, Advent of Code 2016
def fileRead(fileName):
    fileData = []
    file = open(fileName, 'r')
    for line in file:
        line = line.strip()
        line = line[:-1]
        fileData.append(line.split('['))
    return fileData

def countLetters(data):
    counter = {}
    counterList = []
    letters = ''
    tmpList = []
    for letter in data:
        if letter in counter.keys():
            counter[letter] += 1
        else:
            counter[letter] = 1
    for letter in counter.keys():
        counterList.append([letter, counter[letter]])
    counterList.sort(key=lambda x: x[0])
    counterList.sort(key=lambda x: x[1], reverse=True)
    for i in counterList:
        letters += i[0]
    return letters

def checkAgainstChecksum(data, checkSum):
    data = ''.join(data.split('-')[:-1])
    letters = countLetters(data)
    if len(letters) > len(checkSum):
        letters = letters[:len(checkSum)]
    errors = 0
    for i in range(len(letters)):
        if letters[i] == checkSum[i]:
            pass
        else:
            errors += 1
    if errors == 0:
        return True
    return False
    
def countValidID(data):
    counter = 0
    for row in data:
        if checkAgainstChecksum(row[0], row[1]):
            counter += int(row[0].split('-')[-1])
    return counter

def deCrypt(data, key):
    returnString = ''
    for item in data:
        for letter in item:
            returnString += moveInTheAlphabet(letter, int(key))
        returnString+= ' '
    return returnString

def moveInTheAlphabet(start, steps):
    alphabet=[chr(i) for i in range(ord('a'),ord('z')+1)]
    start = alphabet.index(start)
    step = start
    for i in range(steps):
        step += 1
        try:
             alphabet[step]
        except IndexError:
            step = 0
    return alphabet[step]

def searchAndFind(data, searchString):
    potential = []
    for row in data:
        if checkAgainstChecksum(row[0], row[1]):
            decrypted = deCrypt(row[0].split('-')[:-1],row[0].split('-')[-1])
            if searchString in decrypted:
                potential.append([row, decrypted])
    return potential

def main():
    test1 = ["aaaaa-bbb-z-y-x-123","abxyz"]
    test2 = ["a-b-c-d-e-f-g-h-987","abcde"]
    test3 = ["not-a-real-room-404", "oarel"]
    test4 = ["totally-real-room-200","decoy"]
    test5 = ["gbc-frperg-pubpbyngr-znantrzrag-377","rgbnp"]
    test6 = ["iehepwnu-cnwza-ykjoqian-cnwza-ywjzu-ykwpejc-iwjwcaiajp-316","wajci"]
    testDecrypt = "qzmt-zixmtkozy-ivhz-343"

    tests = [test1, test2, test3, test4]

    data = fileRead('input4.txt')

    #print(countValidID(tests))
    #print(deCrypt(testDecrypt.split('-')[:-1], 343))
    #print(searchAndFind(tests, 'ggg'))
    #assignmentOne = countValidID(data)
    assignmentTwo = searchAndFind(data, 'north')
    #print(assignmentOne)
    print(assignmentTwo)

if __name__ == '__main__':
    main()
