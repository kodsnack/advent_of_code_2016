/* Advent of code, day 8, puzzles 1 and 2
   On a 50x6 matrix, follow directions such as "rect 2x3",
   "rotate column x=0 by 1" or "rotate row y=3 by 3"
   to draw rectangles or bit-rotate rows and columns.
   A text message will appear on the matrix. 
   Also, return the sum of all active cells in the matrix.
*/
file = input.txt

width = 50 ; height = 6
off = '.' ; on = '#'
screen. = copies(off,width)		/* Initialise screen */

do while lines(file)
	parse upper value linein(file) with instr line
	select
		when instr = rect then call rect line
		when word(line,1) = row then call rotrow line
		when word(line,1) = column then call rotcol line
		otherwise say 'FEL:' instr
		end
	end

call drawscreen

lit = 0
do row=1 to height
	lit = lit + length(space(translate(screen.row,,'.'),0))
	end
say lit
exit

rect: procedure expose screen. on
	arg x'X'y
	do row = 1 to y
		screen.row = overlay(copies(on,x), screen.row)
		end
	return

rotrow: procedure expose width screen.
	arg . .'=' row . 'BY' amount .
	row = row + 1
	screen.row = right(screen.row,amount) || left(screen.row, width-amount)
	return

rotcol: procedure expose height screen.
	arg . .'=' column . 'BY' amount .
	column = column + 1 ; row = 1 ; line = ''
	/* Extract column */
	do row = 1 to height
		line = line substr(screen.row, column, 1)
		end
	/* Rotate column */
	line = subword(line, height-amount+1) subword(line, 1, height-amount) 
	/* Reinsert column */
	do row = 1 to height
		screen.row = overlay(word(line,row),screen.row,column)
		end
	return

drawscreen: procedure expose screen. height
	do row = 1 to height
		say screen.row
		end