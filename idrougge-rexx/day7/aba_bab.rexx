/* Advent of code, day 7, puzzle 2
   Given a string containing a sequence of letters a-z interspersed with
   sequences between square brackets, find triplets of letters beginning
   and ending with the same letters, but with another letter between them.
   If such a sequence is found outside the bracketed sequences, such as ABA, 
   look for an inverted version of that sequence, such as BAB, inside the
   bracketed sequences.
   If such a ABA-BAB pair is found, the line is valid and added to the 
   final count.
 */

file = 'input.txt'
found = 0

do #=1 while lines(file)
	line = linein(file)
	bracketed = ''
	do until between = ''
		parse var line before '[' between ']' line
		line = before line
		bracketed = bracketed between
	end
	found = found + check(line, bracketed)
end

say found
exit

check: procedure
parse arg super, hyper
do while length(super) >= 3
	parse var super first +1 middle +1 last +1 1 . +1 super
	if first \= last then iterate
	if first == middle then iterate
	if pos(middle||first||middle,hyper) > 0 then return 1
end
return 0
