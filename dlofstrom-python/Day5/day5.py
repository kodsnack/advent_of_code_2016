from hashlib import md5

input = 'ojvtpuvg'

#Part 1
code = ''
index = 0
while len(code)<8:
    hash = md5(input+str(index)).hexdigest()
    if hash[0:5]=='00000':
        print index, hash
        code += hash[5]
    index += 1

print 'Part 1:', code

#Part 2
code = {}
index = 0
while len(code.keys())<8:
    hash = md5(input+str(index)).hexdigest()
    if hash[0:5]=='00000':
        if hash[5] in '01234567' and hash[5] not in code:
            print index, hash
            code[hash[5]] = hash[6]
    index += 1
code = ''.join(code[i] for i in '01234567')

print 'Part 2:', code
