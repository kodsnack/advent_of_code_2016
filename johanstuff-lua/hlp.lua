--[[
	Testing modules..found som code..on_the_internet..
]]

local hlp = {}


--Source: https://forums.curseforge.com , User: Xinhuan
--Info:
--All it does is create a new sorting function for every combination of column sorting you throw at it,
--and storing these functions in a table for reuse.
local sort = { "col2", "col1" }
function hlp.cmp2col(lhs, rhs)
	--print('--------')
	if lhs[sort[1]] ~= rhs[sort[1]] then
		return lhs[sort[1]] < rhs[sort[1]]
	elseif lhs[sort[2]] ~= rhs[sort[2]] then
		return lhs[sort[2]] > rhs[sort[2]]
	end
end


return hlp
