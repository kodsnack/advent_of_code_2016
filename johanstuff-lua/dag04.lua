--[[
	"Day 4: Security Through Obscurity"   (Lua exempel *Part One*)
]]

-- vars
list = {} --(unordered) antal char

function CountCharsInRow(inp)
	local row = inp:match( "[^%[.+%]]*" ) --(regex-[abcde])
	row = row:match( "%D+" ) --(regex-digits)
	row = row:gsub("-", "")
	-- spara antalet för varje char
	for chr in string.gmatch(row, ".") do
		if list[chr] == nil then 
			list[chr] = 1 
		elseif list[chr] ~= nil then 
			list[chr] = list[chr] + 1 
		end
	end
	--print: for k,v in pairs(list) do print(k, v) end
end

function SortCharsInList()
	 -- spara högsta resultat
	local cnt = 0
	for k,v in pairs(list) do
		if v>cnt then cnt = v end
	end
	 -- spara ut-och-bort högsta resultat
	local arr = {}
	for k,v in pairs(list) do
		if list[k] == cnt then
			table.insert(arr, k)
			list[k] = nil
		end
	end
	table.sort(arr)
	--print: print( ':'..table.concat(arr) )
	return table.concat(arr)
end

-- -- -- -- -- -- -- -- -- -- main --  --  --  --  --  --  --  --  --  -- 

-- läs fil
file = io.open("inp04test.txt", "r") -- testdata(sum=1514)
input = file:read("*a") --ex:"aaaaa-bbb-z-y-x-123[abxyz]"
file:close()

sum = 0
for row in string.gmatch(input, "[^\n]+") do
	-- hitta kod och jämför i raderna
	CountCharsInRow(row)
	local codeOrg = row:match("%[.+%]")   codeOrg = codeOrg:match("%a+")
	local codeCalc = ""
	-- sortera hittade chars, ut ur lista
	while (next(list) ~= nil) do codeCalc = codeCalc..SortCharsInList() end
	-- summera om koden stämmer
	if codeCalc:match("%a%a%a%a%a") == codeOrg then
		sum = sum + tonumber(row:match("%d+"))
	end
end

--Svar:
print(sum)
