[

/*

Advent of code 2016 Day 1 by Johan Sölve

*/

define location => type {

	data 
		public x=integer,
		public y=integer,
		private direction=integer

	public move(movement::string) => {
		local(turn=#movement->substring(1,1),
			steps=integer(#movement->substring(2))
		)
		if(#turn==='L') => {
			.direction-=90
		else(#turn==='R')
			.direction+=90
		}
		.direction<0 ? .direction+=360
		.direction>=360 ? .direction-=360
		if(.direction===0) => {
			.y+=#steps
		else(.direction===90)
			.x+=#steps
		else(.direction===180)
			.y-=#steps
		else(.direction===270)
			.x-=#steps
		}
	}
	public blocksAway => {
		local(blocksAway=.x->abs + .y->abs)
		return #blocksAway
	}
}

local(cityLocation=location)

local(input='R3, L5, R1, R2, L5, R2, R3, L2, L5, R5, L4, L3, R5, L1, R3, R4, R1, L3, R3, L2, L5, L2, R4, R5, R5, L4, L3, L3, R4, R4, R5, L5, L3, R2, R2, L3, L4, L5, R1, R3, L3, R2, L3, R5, L194, L2, L5, R2, R1, R1, L1, L5, L4, R4, R2, R2, L4, L1, R2, R53, R3, L5, R72, R2, L5, R3, L4, R187, L4, L5, L2, R1, R3, R5, L4, L4, R2, R5, L5, L4, L3, R5, L2, R1, R1, R4, L1, R2, L3, R5, L4, R2, L3, R1, L4, R4, L1, L2, R3, L1, L1, R4, R3, L4, R2, R5, L2, L3, L3, L1, R3, R5, R2, R3, R1, R2, L1, L4, L5, L2, R4, R5, L2, R4, R4, L3, R2, R1, L4, R3, L3, L4, L3, L1, R3, L2, R2, L4, L4, L5, R3, R5, R3, L2, R5, L2, L1, L5, L1, R2, R4, L5, R2, L4, L5, L4, L5, L2, L5, L4, R5, R3, R2, R2, L3, R3, L2, L5')

#input=#input->split(',')

iterate(#input) => {
	loop_value->trim;
	#cityLocation->move(loop_value)
}

'Easter Bunny HQ is ' + #cityLocation->blocksAway + ' blocks away'

]