/* Advent of code, day 19, puzzle 1 
   http://adventofcode.com/2016/day/19
 */
number = 3014387
do i = 1 to number
	queue i
end
do while queued() > 1
	pull nisse
	pull .
	queue nisse
end

pull nisse
say nisse