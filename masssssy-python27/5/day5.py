import hashlib

def main():
	input="ugkcyxxp"	

	thepass = []
	appendInt = 0
	while len(thepass) < 8:
		incInput = input + str(appendInt)
		hash = hashlib.md5(incInput).hexdigest()
		if hash[0:5] == "00000":
			thepass.append(hash[5])
		appendInt +=1

	print thepass
if __name__ == "__main__":
    main()