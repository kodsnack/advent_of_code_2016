def main():
	input = "00111101111101000"
	length = 35651584

	str = input
	while len(str) < length:
		str = str + "0" + str[::-1].replace('1', '2').replace('0', '1').replace('2', '0')

	str = str[0:length]

	checksum = str
	while len(checksum) % 2 == 0:
		checksum = check(checksum)
	print checksum
	print len(checksum)



def check(input):
	checksum =""
	for x in range(0, len(input), 2):
		if input[x] == input[x+1]:
			checksum += "1"
		else:
			checksum+= "0"
	return checksum

if __name__ == "__main__":
    main()

    