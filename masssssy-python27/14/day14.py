import hashlib
import re
def main():
	input = "qzyelonm"
	keys = []

	index = 0
	while len(keys) < 64:
		hash = hashlib.md5(input + str(index)).hexdigest()
		check = checkInRow(hash)
		if check != None: 
			#3hash index found, check for 5hash in coming 2000
			for b in range (index, index+1000):
				hash2 = hashlib.md5(input + str(b+1)).hexdigest()
				if check5InRow(hash2, check[2]):
					keys.append([index, hash])
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