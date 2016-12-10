/* Advent of code, day 7, puzzle 1
   Given a string containing a sequence of letters a-z interspersed with
   sequences between square brackets, find pairs of letters followed by 
   a pair that is the reverse of that pair, such as ABBA.
   If such a pair is found inside the brackets on a line, that line is
   invalid.
   If a all letters in one pair are identical, the line is invalid.
   Otherwise, the line is valid and added to the count returned at the end.
 */

file = 'input.txt'
found = 0

do #=1 while lines(file)
	line = linein(file)
	do until middle = ''
		parse var line word '[' middle ']' line
		if check(middle) then iterate #
		line = word line
	end
	found = found + check(line)
end

say found
exit

check: procedure
parse arg line
do while length(line) >= 4
	parse var line first +2 last +2 1 . +1 line
	if first == reverse(first) then iterate
	if first == reverse(last) then return 1
end
return 0
