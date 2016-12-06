import hashlib

with open ("d5_input.txt", "r") as inputfile:
    input = inputfile.read()

pwd = ""
i = 0

while len(pwd) < 8:
    g = hashlib.md5()
    while g.hexdigest()[0:5] != "00000":
        g = hashlib.md5()
        g.update(input + str(i))
        i += 1
    pwd += str(g.hexdigest()[5])
print "Part one: " + str(pwd)

pwd = ['_', '_', '_', '_', '_', '_', '_', '_']
i = 0

while '_' in pwd:
    g = hashlib.md5()
    while g.hexdigest()[0:5] != "00000":
        g = hashlib.md5()
        g.update(input + str(i))
        i += 1
    if (int(g.hexdigest()[5], 16) < 8):
        if pwd[int(g.hexdigest()[5])] == '_':
            pwd[int(g.hexdigest()[5])] = g.hexdigest()[6]
print "Part two: " + "".join(pwd)
