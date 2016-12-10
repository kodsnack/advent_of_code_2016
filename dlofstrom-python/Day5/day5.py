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
