import hashlib

def main():
	input="ugkcyxxp"	

	thepass = [None]*8
	appendInt = 0
	pwlength = 0
	while pwlength < 8:
		incInput = input + str(appendInt)
		hash = hashlib.md5(incInput).hexdigest()
		if hash[0:5] == "00000":
			print "Found 00000"
			unic = unicode(hash[5], 'utf-8')
			if unic.isnumeric():
				if int(hash[5]) <= 7 and int(hash[5] >= 0):
					if thepass[int(hash[5])] == None: 
						thepass[int(hash[5])] = hash[6]
						print "found valid 00000"
						pwlength +=1
		appendInt +=1

	print thepass
if __name__ == "__main__":
    main()