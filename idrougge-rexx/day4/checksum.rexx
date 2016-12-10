/* Advent of code, day 4, puzzle 1
   Read a code consisting of a sequence of letters interspersed with dashes, 
   followed by a number and finally a checksum between square brackets.
   The checksum consists of the five most common letters in the sequence,
   in descending order. When two letters occur the same number of times,
   they are sorted alphabetically. Find all correct checksums and sum all 
   numbers in those lines.
 */
file='input.txt'
sum=0

do while lines(file)
	line = linein(file)
	dash = lastpos('-',line)
	parse value line with 1 line =(dash) . +1 number '[' checksum ']'
	line = space( translate(line,'','-'),0 )
	linediff = length(line)
	prevletter=''
	do while checksum \= ''
		parse var checksum letter +1 checksum
		oldlength = length(line)
		line = translate(line,,letter)
		line = space(line,0)
		newlength = length(line)
		select
			when oldlength - newlength > linediff then do
				number=0
				leave
			end
			when oldlength - newlength = 0 then do
				number=0
				leave
			end
			when oldlength - newlength = linediff then do
				if prevletter > letter then do
					number=0
					leave
				end
			end
			otherwise nop
		end
		linediff = oldlength - newlength
		prevletter = letter
	end
	sum = sum + number
end
say sum
exit