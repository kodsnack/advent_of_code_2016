[

/*

Advent of code 2016 Day 4 by Johan Sölve

*/

define rooms => type {

	data 
		public sumID=integer
	public evaluateRoom(input::string) => {
		local(row=#input->split('-'))
		local(id=integer(#row->last->split('[')->first))
		local(checksum=#row->last->split('[')->last)
		#checksum->removetrailing(']')
		local(name=#input->ascopy)
		#name->removetrailing('-'+#row->last)
		if(#checksum===.makeCheckSum(#name)) => {
			.sumID += #id
		}
		return .makeCheckSum(#name)
	}

	private makeCheckSum(input::string) => {
		local(letterCount=map)
		with character in #input->eachCharacter
		do {
			if(#letterCount!>>#character) => {
				#letterCount->insert(#character=1)
			else
				#letterCount->find(#character)+=1
			}
		}
		#letterCount->remove('-')
		local(letterToplist=#letterCount->asArray)
		
		local(output=
			with n in #letterToplist
				order by #n->second descending, #n->first
				take 5
				select #n->first
		)
		return #output->join('')
	}
	
}

local(timer=date_msec)

local(rooms=rooms)

library('day4_input.lasso')

with line in $input->eachLineBreak
	do #rooms->evaluateRoom(#line)

'The sum of valid room IDs is ' + #rooms->sumID + ' calculated in ' (date_msec-#timer) + ' ms'

]
