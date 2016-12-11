[

/*

Advent of code 2016 Day 3 by Johan Sölve

*/

define triangles => type {

	data 
		public countChecked=integer,
		public countValid=integer
	public checkRow(input::string) => {
		#input->trim & replace(regexp(' +', ' '))
		local(row=#input->split(' '))
		if(#row->size===3) => {
			.checkTriangle(integer(#row->get(1)), integer(#row->get(2)), integer(#row->get(3)))
		}
	}
	public checkTriangle(side1::integer, side2::integer, side3::integer) => {
		local(valid=
			(
				#side1 < #side2 + #side3
				&& #side2 < #side1 + #side3
				&& #side3 < #side1 + #side2
			)
		)
		.countChecked+=1
		.countValid+=integer(#valid)
	}
}

local(timer=date_msec)

local(triangles=triangles)

library('day3_input.lasso')


with line in $input->eachLineBreak
	do #triangles->checkRow(#line)


'There are ' + #triangles->countValid + ' valid triangles out of ' + #triangles->countChecked + ' checked in ' (date_msec-#timer) + ' ms'

]
