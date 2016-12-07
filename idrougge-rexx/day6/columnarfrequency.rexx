/* Advent of code, day 2, puzzles 1 and 2
   Select most common letter per column
   and the least common letter per column */

file = 'input.txt'
alphabet = xrange('a','z')
letters. = 0

/* Read lines and do statistics per column */
do rows=1 while lines(file)
	line = linein(file)
	do column=1 to length(line)
		letter = substr(line,column,1)
		letters.column.letter = letters.column.letter + 1
	end
end

/* Find most common letter per column */
message = ''
do column=1 to length(line)
	do a = 1 to length(alphabet)
		letter = substr(alphabet,a,1)
		if letters.column.letter > letters.column.top then top = letter
	end
	top.column = top
	message = message || top
end
say message

/* Find least common letter per column */
message = ''
do column=1 to length(line)
	top = ''
	letters.column. = rows
	do a = 1 to length(alphabet)
		letter = substr(alphabet,a,1)
		if letters.column.letter = 0 then iterate
		if letters.column.letter < letters.column.top then top = letter
	end
	top.column = top
	message = message || top
end
say message