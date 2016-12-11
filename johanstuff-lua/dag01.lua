--[[
	"Day 1: No Time for a Taxicab"   (Lua exempel *Part One*)
]]

-- vars
direction = 'N'   xpos = 0   ypos = 0

function GetNewDirection(chr)
	-- plocka ut ny riktning, bak/fram i lista
	NoEsWeSo = {'W','N','E','S','W','N'}
	for i = 2, 5 do
		if NoEsWeSo[i] == direction then -- hitta 'N,E,S,W'
			if chr == 'R' then return NoEsWeSo[i+1] end
			if chr == 'L' then return NoEsWeSo[i-1] end
		end
	end
end

function GetNewPos(num)
	-- öka|minska|ignorera, x/y
	if direction == 'N' then return xpos+(num*0), ypos+(num*1) end
	if direction == 'E' then return xpos+(num*1), ypos+(num*0) end
	if direction == 'S' then return xpos+(num*0), ypos+(num*-1) end
	if direction == 'W' then return xpos+(num*-1), ypos+(num*0) end
end

-- -- -- -- -- -- -- -- -- -- "main"-- -- -- -- -- -- -- -- -- -- 

inp = "R3,R1,R4,L4,R3,R1,R1,L3,L5,L5,L3,R1,R4,L2,L1,R3,L3,R2,R1,R1,L5,L2,L1,R2,L4,R1,L2,L4,R2,R2,L2,L4,L3,R1,R4,R3,L1,R1,L5,R4,L2,R185,L2,R4,R49,L3,L4,R5,R1,R1,L1,L1,R2,L1,L4,R4,R5,R4,L3,L5,R1,R71,L1,R1,R186,L5,L2,R5,R4,R1,L5,L2,R3,R2,R5,R5,R4,R1,R4,R2,L1,R4,L1,L4,L5,L4,R4,R5,R1,L2,L4,L1,L5,L3,L5,R2,L5,R4,L4,R3,R3,R1,R4,L1,L2,R2,L1,R4,R2,R2,R5,R2,R5,L1,R1,L4,R5,R4,R2,R4,L5,R3,R2,R5,R3,L3,L5,L4,L3,L2,L2,R3,R2,L1,L1,L5,R1,L3,R3,R4,R5,L3,L5,R1,L3,L5,L5,L2,R1,L3,L1,L3,R4,L1,R3,L2,L2,R3,R3,R4,R4,R1,L4,R1,L5"

for str in string.gmatch(inp, "[^,]+") do
	-- läs sträng/komma och hantera respektive riktning+steg.
	direction = GetNewDirection(str:match("%a+")) -- 'R'
	xpos, ypos = GetNewPos(str:match("%d+")) -- '3' 
	--print(direction, xpos, ypos)
end

--Svar:
print("Blocks away: "..math.abs(xpos) + math.abs(ypos))
