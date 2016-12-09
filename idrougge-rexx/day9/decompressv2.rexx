/* Advent of code, day 9, puzzle 2
   In a string, find tokens of the format '(NxM)'
   where N is a range of characters
   and M is the number of times to repeat those characters.
   The repeated string may itself contain repetition tokens
   and must be processed in the same way.
   Return the total number of characters in the decompressed string.
*/
numeric digits 12
line = linein('input.txt')
say decompress(line)
exit

decompress: procedure
parse arg line
total = 0
do while line \= ''
	parse var line before '(' range 'x' number ')' line
	if line == '' then return length(before)
	parse var line repeated +(range) line
	total = total + number * decompress(repeated)
end
return total