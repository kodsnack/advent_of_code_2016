/* Advent of code, day 4, puzzle 2
   Read a code consisting of a sequence of letters interspersed with dashes, 
   followed by a number and finally a checksum between square brackets.
   Rotate the letter sequence as many times as indicated by the number.
 */

file='input.txt'
in = xrange('a','z')
ut = xrange('b','z') || 'a'

do while lines(file)
	line = linein(file)
	dash = lastpos('-',line)
	parse value line with 1 line =(dash) . +1 number '[' checksum ']'
	do number
		line = translate(line,ut,in)
	end
	say number line
end
exit