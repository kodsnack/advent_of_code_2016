f = open('input_19.txt', 'r')
n = int(f.readline())
elves = [x for x in xrange(1,n+1)]
pos = 0

for elf_count in xrange(len(elves), 1, -1):
	to_remove = (pos + elf_count/2)%elf_count
	del elves[to_remove]	
	pos = (pos+1)%(elf_count-1) if to_remove > pos else pos % (elf_count-1)
	
print elves[0]