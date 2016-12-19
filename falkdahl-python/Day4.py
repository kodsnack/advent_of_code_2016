import re
from collections import Counter

def getRoomName(roomCode):
    return re.search('^[a-z-]+', roomCode).group()

def getCheckSum(roomCode):
    return re.search('(?<=\[)[a-z]+(?=\])', roomCode).group()

def getSectorId(roomCode):
    return int(re.search('(?<=-)\d+(?=\[)', roomCode).group())

def generateNewCheckSum(roomCode):
    roomName = getRoomName(roomCode)
    letterCounter = Counter(roomName.replace('-', ''))
    sortedLetters = sorted(letterCounter.items(), key=lambda pair: 1000 * pair[1] - ord(pair[0]), reverse=True)
    return ''.join([letter[0] for letter in sortedLetters[0:5]])

def isRealRoom(roomCode):
    return True if generateNewCheckSum(roomCode) == getCheckSum(roomCode) else False

def decryptRoomName(roomCode):
    nShift = getSectorId(roomCode)
    name = getRoomName(roomCode)
    newName = ''
    for letter in name:
        if letter == '-':
            newName += ' '
        else:
            newName += chr(((ord(letter)-97+nShift) % 26) + 97)
    return newName

if __name__ == '__main__':
    with open('Day4-input.txt') as f:
        inputData = f.read()

    sumSectorId = 0
    for roomCode in inputData.splitlines():
        sectorId = getSectorId(roomCode)
        print('ID %d: %s' % (sectorId, decryptRoomName(roomCode)))
        if isRealRoom(roomCode):
            sumSectorId = sumSectorId + sectorId

    print('\nSum of SectorIDs: %d' % sumSectorId)
