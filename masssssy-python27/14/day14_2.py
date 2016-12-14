import hashlib
import re
def main():
	input = "qzyelonm"
	keys = []
	hashed=dict()

	index = 0
	while len(keys) < 64:
		if index in hashed:
			hash = hashed[index]
		else:
			hash = hashlib.md5(input + str(index)).hexdigest()
			for x in range(0,2016):
				hash = hashlib.md5(hash).hexdigest()
			hashed[index] = hash
		check = checkInRow(hash)
		if check != None: 
			#3hash index found, check for 5hash in coming 2000
			for b in range (index+1, index+1000):
				if b in hashed:
					hash2 = hashed[b]
				else:	
					hash2 = hashlib.md5(input + str(b)).hexdigest()
					for x in range(0,2016):
						hash2 = hashlib.md5(hash2).hexdigest()
					hashed[b] = hash2
				if check5InRow(hash2, check[2]):
					keys.append([index, hash, hash2])
					break
		index+=1
	print keys


def checkInRow(hash):
		result = re.search(r"(.)\1\1", hash)
		if result != None:
			return result.group(0)
		return None
def check5InRow(hash, char):
	str = char + char + char + char + char
	result = re.search(str, hash)
	if result != None:
		return True
	return False

if __name__ == "__main__":
    main()