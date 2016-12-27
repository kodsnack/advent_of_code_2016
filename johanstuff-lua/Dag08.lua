--[[ "Day 8: Two-Factor Authentication"   (Lua exempel *Part One*) ]]
--(found Python I liked in repo, translatet to Lua//learnig experience)

--vars
hlp = require 'hlp'
screen = {} --screen[y][x]
for i = 1, 6 do
    screen[i] = {}  for j = 1, 50 do  screen[i][j] = 0 end --(0=off)
end

--funcs
function rect(xarea,yarea)
    for y in hlp.range(1,yarea,1) do
        for x in hlp.range(1,xarea,1) do screen[y][x] = 1 end --(1=on)
    end
end

function rotateRow(row,xmove)
     for i=1,xmove do table.insert(row, 1, row[#row]) table.remove(row, #row) end
end

function rotateColumn(x,ydown)
    local tb = {}
    for i=1,#screen do table.insert(tb, screen[i][x]) end
    rotateRow(tb,ydown)
    for i=1,#screen do screen[i][x] = tb[i] end
end

function fixArgs(args) return tonumber(args[1]), tonumber(args[2]) end

function operate(s)
    if s:sub(1,5) == 'rect ' then
        args = hlp.split(s:sub(6,#s),'x')
        a1,a2 = fixArgs(args)
        rect(a1,a2)
    elseif s:sub(1,13) == 'rotate row y=' then
        args = hlp.split(s:sub(14,#s),'by')
        a1,a2 = fixArgs(args)
        rotateRow(screen[a1+1], a2)
    elseif s:sub(1,16) == 'rotate column x=' then
        args = hlp.split(s:sub(17,#s),'by')
        a1,a2 = fixArgs(args)
        rotateColumn(a1+1, a2)--(Lua+1)
    else
        print('UNKNOWN INSTRUCTION: '..s)
    end
    --print(s..' <-op=> '..s:sub(1,5))
end

-- -- -- -- -- -- -- -- -- -- main --  --  --  --  --  --  --  --  --  -- 

function getVoltage()
    local noOfLit = 0
    for i=1,6 do
        for k,v in ipairs(screen[i]) do noOfLit = noOfLit + v end
    end
    return noOfLit
end

file = io.open("inp8.txt", "r")   filestr = file:read("*a")   file:close()
for line in string.gmatch(filestr, "[^\n]+") do-->>strings..
    operate(line)
end

print("Part one: " .. getVoltage())

--[[
dbug: rect(1,1) rotateRow(screen[1],1) rotateColumn(2,1) hlp.pprint(screen)
test: operate('rect 1x1') operate('rotate row y=0 by 1') operate('rotate column x=1 by 1') hlp.pprint(screen)
Answer:
0,0,,,
0,1,,,
]]
