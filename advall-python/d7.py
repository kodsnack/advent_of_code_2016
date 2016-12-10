def isAbba(s):
    return (s[0] == s[3]) and (s[1] == s[2]) and (s[0] != s[1])

def containsAbba(s):
    if len(s) < 4:
        return False
    hasAbba = False
    for i in range(len(s) - 3):
        if isAbba(s[i:(i+4)]):
            hasAbba = True
            break
    return hasAbba

def isAba(s):
    if (s[0] == s[2]) and (s[1] != s[0]):
        return (s[0], s[1])
    else:
        return ('_', '_')


numOfTLS = 0
numOfSSL = 0
for line in open ("d7_input.txt", "r"):
    ip = line.rstrip()
    if ip[0] == '[':
        ip = "_" + ip
    ip = ip.replace(']', '[')
    ip = ip.split('[')
    isTLS = False
    for i in range(0, len(ip), 2):
        if containsAbba(ip[i]):
            isTLS = True
    for i in range(1, len(ip), 2):
        if containsAbba(ip[i]):
            isTLS = False
    if isTLS:
        numOfTLS += 1

    isSSL = False
    for i in range(0, len(ip), 2):
        if len(ip[i]) > 2:
            for j in range(len(ip[i])-2):
                aba = isAba(ip[i][j:(j+3)])
                if aba != ('_', '_'):
                    for k in range(1, len(ip), 2):
                        if (aba[1] + aba[0] + aba[1]) in ip[k]:
                            isSSL = True
    if isSSL:
        numOfSSL += 1

print "Part one: " + str(numOfTLS)
print "Part two: " + str(numOfSSL)