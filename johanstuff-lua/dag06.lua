--[[
	"Day 6: Signals and Noise"   (Lua exempel *Part One*)
]]

--vars
hlp = require 'hlp'

function SliceChars()
	local arr = {}
	local filstr = 'eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar\n'
	for i = 1,6 do--(1-6(7,8))
		local slice = ''
		for str in string.gmatch(filstr, "[^\n]+") do-->>strings..
			slice = slice..string.sub(str,i,i)
		end
		table.insert(arr,slice)
	end
	return arr
end

function CountChars(slice)
	--counting chars
	local tbl = {}
	for chr in string.gmatch(slice, ".") do-->>chars..
		if tbl[chr] == nil then tbl[chr] = 1 else tbl[chr] = tbl[chr] + 1 end
	end
	--use arr to sort
	local arr = {}	
	for k,v in pairs(tbl) do table.insert(arr,{col1 = k, col2 = v}) end
	table.sort(arr, hlp.cmp2col)
	return arr[#arr].col1
end

-- -- -- -- -- -- -- -- -- -- main --  --  --  --  --  --  --  --  --  -- 
 
code = ''   slices = {}
slices = SliceChars()--for k,v in ipairs(slices) do print(k,v) end
for k,v in ipairs(slices) do code = code..CountChars(v) end

print('The code is: '..code)

--[[
	Test: filstr = 'eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar\n'
	Answer: "easter"
]]
