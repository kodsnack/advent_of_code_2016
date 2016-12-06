/* REXX */
file = 'input2.txt'
alphabet = xrange('a','z')
letters. = 0

do i=1 while lines(file)
	line = linein(file)
	say i line
	do column=1 to length(line)
		letter = substr(line,column,1)
		letters.column.letter = letters.column.letter + 1
		say ' ' letter letters.column.letter
	end
end

do column=1 to length(line)
	do a = 1 to length(alphabet)
		letter = substr(alphabet,a,1)
		if letters.column.letter > letters.column.top then top = letter
	end
	top.column = top
	say column top.column
end