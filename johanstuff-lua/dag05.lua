--[[
	"Day 5: How About a Nice Game of Chess?"   (Lua exempel *Part One*)
]]

-- vars
md5 = require 'ext/md5'
md5_str  = ''
dpass = ''

-- -- -- -- -- -- -- -- -- -- main --  --  --  --  --  --  --  --  --  -- 

i = 0
while #dpass < 8 do
	i = i + 1
	md5_str = md5.sumhexa('abc'..i)
	if md5_str:find('00') == 1 then
		dpass = dpass..md5_str:sub(6,6)
	end
end

--Svar:
print('Lösen till dörr: ' .. dpass)

--[[
	Test:
	Testdata 'abc' och två nollor skall ge 0b31783b, ändra till 00000 ovan för
	18f47a30 som resultat men bered dig på en lång(lång!) väntan.
]]
