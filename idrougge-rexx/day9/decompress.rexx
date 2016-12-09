/* Advent of code, day 9, puzzle 2
   In a string, find tokens of the format '(NxM)'
   where N is a range of characters
   and M is the number of times to repeat those characters.
   Repetition tokens inside the string to be repeated are ignored.
   Return the total number of characters in the decompressed string.
*/
signal on syntax
line = linein('input.txt')
total = 0

do while line \= ''
	parse var line before '(' range 'x' number ')' repeated +(range) line
	repeated = copies(repeated,number)
	total = total + length(space(repeated,0))
end

syntax:
say total
exit


say 'Fel på rad' sigl
say total
return