/* Advent of Code 2016 day 1:
   Taxicab coordinates */
path = 'R4, R3, L3, L2, L1, R1, L1, R2, R3, L5, L5, R4, L4, R2, R4, L3, R3, L3, R3, R4, R2, L1, R2, L3, L2, L1, R3, R5, L1, L4, R2, L4, R3, R1, R2, L5, R2, L189, R5, L5, R52, R3, L1, R4, R5, R1, R4, L1, L3, R2, L2, L3, R4, R3, L2, L5, R4, R5, L2, R2, L1, L3, R3, L4, R4, R5, L1, L1, R3, L5, L2, R76, R2, R2, L1, L3, R189, L3, L4, L1, L3, R5, R4, L1, R1, L1, L1, R2, L4, R2, L5, L5, L5, R2, L4, L5, R4, R4, R5, L5, R3, L1, L3, L1, L1, L3, L4, R5, L3, R5, R3, R3, L5, L5, R3, R4, L3, R3, R1, R3, R2, R2, L1, R1, L3, L3, L3, L1, R2, L1, R4, R4, L1, L1, R3, R3, R4, R1, L5, L2, R2, R3, R2, L3, R4, L5, R1, R4, R5, R4, L4, R1, L3, R1, R3, L2, L3, R1, L2, R3, L3, L1, L3, R4, L4, L5, R3, R5, R4, R1, L2, R3, R5, L5, L4, L1, L1'

/* Truth table for X/Y delta values and pointers to left/right deltas */
deltas.n =  '0 -1  W E'
deltas.w = '-1  0  S N'
deltas.e =  '1  0  N S'
deltas.s =  '0  1  E W'

visited=' '
orientation = n /* Point north at beginning */
parse var deltas.orientation dx dy next.l next.r /* Initialise deltas and pointers */
y=0 ; x=0

do loop=0 while path \= ''
	parse var path steps . ',' path
	parse var steps direction +1 steps
	orientation = next.direction
	parse var deltas.orientation dx dy next.l next.r
	do #=1 to steps
		x = x + dx
		y = y + dy
		/* Remove line below to solve puzzle 1 */
		if pos(' ' || x y || ',',visited) \== 0 then leave loop
		visited = visited x y || ','
	end
end
say abs(x)+abs(y) 'blocks away'
