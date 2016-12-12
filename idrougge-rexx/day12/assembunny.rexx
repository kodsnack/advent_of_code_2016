/* Advent of code, day 12, puzzles 1 and 2 
   Run a mock assembly program with four instructions:
   INC increases a register by 1, DEC decreases it.
   CPY moves a constant or the contents of a register to another register.
   JNZ jumps a specified number of lines back or forth 
   if the specified is not zero.
   There are four registers named A, B, C and D.
   Run the program once with all registers set to 0
   and once with register C set to 1.
   Return the contents of register A. */
file = 'input.txt'
do i = 0 to 1
	regs.a = 0 ; regs.b = 0 ; regs.c = i ; regs.d = 0
	do pc=1 until \lines(file)
		line = linein(file)
		parse upper var line command op1 op2 .
		select
			when command = 'INC' then regs.op1 = regs.op1 + 1
			when command = 'DEC' then regs.op1 = regs.op1 - 1
			when command = 'CPY' then do
				if datatype(op1) == num  then regs.op2 = op1
				if datatype(op1) == char then regs.op2 = regs.op1
			end
			when command = 'JNZ' then do
				if datatype(op1) == char then op1 = regs.op1
				if op1 <> 0 then do
					pc = pc+op2-1
					call linein file,pc
				end
			end
		end
	end
	call lineout file /* close file */
	say regs.a
end