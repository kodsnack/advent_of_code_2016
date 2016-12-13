--[[
	"Day 3: Squares With Three Sides"   (Lua exempel *Part One*)
]]

-- vars
input = ""   triangel = 0

-- läs fil
file = io.open("inp03.txt", "r")
input = file:read("*a")
file:close()

-- -- -- -- -- -- -- -- -- -- "main"-- -- -- -- -- -- -- -- -- -- 

for str in string.gmatch(input, "[^\n]+") do
	--läs/rad och testa om triangel.
	s1, s2, s3 = str:match("(%d+)%s+(%d+)%s+(%d+)")
	a = tonumber(s1) b = tonumber(s2) c = tonumber(s3)
	
	if (a<(b+c)) and (b<(a+c)) and  (c<(a+b)) then
		triangel = triangel + 1
	end
end

--Svar:
print('triangel: ' .. triangel)
