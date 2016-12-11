--[[
	"Day 2: Bathroom Security"   (Lua exempel *Part One*)
]]

-- vars
input = ""   x = 2   y = 2

-- läs fil
file = io.open("inp02.txt", "r")
input = file:read("*a")
file:close()

function GetMove(chr)
	local xx = x   local yy = y -- tempvar
	if chr == 'U' then y = y - 1 end  -- move
	if chr == 'D' then y = y +1 end
	if chr == 'R' then x = x + 1 end
	if chr == 'L' then x = x -1 end
	if x >= 1 and x <= 3  and  y >= 1 and y <= 3 then
		return x,y -- spara
	end
	return xx,yy -- ignore
end

-- -- -- -- -- -- -- -- -- -- "main"-- -- -- -- -- -- -- -- -- -- 

pad = {'1','2','3'}
pad[1] = {'1','4','7'}
pad[2] = {'2','5','8'}
pad[3] = {'3','6','9'}
res = ""

for str in string.gmatch(input, ".") do
	-- läs/char i varje rad & få slut siffran.
	if str:match("\n") ~= "\n" then
		x,y = GetMove(str)
	else
		res = res .. pad[x][y]
		print(':'..res)
	end
end

--Svar:
print(res)
