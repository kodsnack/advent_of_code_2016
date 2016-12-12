/* Advent of code, day 10, puzzles 1 and 2 
   http://adventofcode.com/2016/day/10   */

file = 'input.txt'
actors. = ''

do while lines(file)
	line = linein(file)
	parse var line command line
	select
		when command == 'value' then do
			parse var line value . 'bot' number .
			call take 'bot' number value
		end
		when command == 'bot' then do
			parse var line number . . . low low# . . . high high#
			call give number low low# high high#
		end
	end
end

say '2:' actors.output.0.values * actors.output.1.values * actors.output.2.values
exit

take: procedure expose actors.
arg type number val
actors.type.number.values = actors.type.number.values val
if actors.type.number.todo = '' then return
if give(number subword(actors.type.number.todo,1,4)) 
then actors.type.number.todo = ''
return

give: procedure expose actors.
arg number lowreceiver low# highreceiver high#
if words(actors.bot.number.values) < 2 then do
	actors.bot.number.todo = lowreceiver low# highreceiver high#
	return 0
end
parse var actors.bot.number.values left right
call take lowreceiver low# min(left,right)
call take highreceiver high# max(left,right)
if min(left,right) = 17 & max(left,right) = 61 then say '1: bot' number
actors.bot.number.values = ''
return 1