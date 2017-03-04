input = '01111010110010011'

def generate_checksum(disk_length, data):
    while len(data) < disk_length:
        data = data + '0' + ''.join(['0' if b=='1' else '1' for b in data[::-1]])
        
    checksum = data[:disk_length]
    while len(checksum) % 2 == 0:
        checksum = ''.join(['1' if i==j else '0' for i,j in zip(checksum[0::2],checksum[1::2])])
    return checksum
            
print 'Part 1:', generate_checksum(272, input)
print 'Part 2:', generate_checksum(35651584, input)
