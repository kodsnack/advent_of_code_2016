--[[ "Day 7: Internet Protocol Version 7"   (Lua exempel *Part One*) ]]
--(found Python I liked in repo, translatet to Lua//learnig experience)

hlp = require 'hlp'

function isAbba(s)
    return(s:sub(1,1) == s:sub(4,4)  and  s:sub(2,2) == s:sub(3,3)  and  s:sub(1,1) ~= s:sub(2,2))
end

function containsAbba(s)
    if string.len(s) < 4 then return false end
    hasAbba = false
    for i in hlp.range(1, string.len(s)-3, 1) do --walk -____->and test
        if isAbba(string.sub(s,i,i+3)) then
            hasAbba = true
            break
        end
    end
    return hasAbba
end

numOfTLS = 0
--file = io.open("inp7.txt", "r")   filestr = file:read("*a")   file:close()
filestr = 'abba[mnop]qrst\nabcd[bddb]xyyx\naaaa[qwer]tyui\nioxxoj[asdfgh]zxcvbn'
for line in string.gmatch(filestr, "[^\n]+") do
    ip = line
    ip = string.gsub(line,']', '[')      --=> abba[mnop[qrst
    ip = hlp.split(ip,'[')               --=> abba,mnop,qrst
    isTLS = False
    for i in hlp.range(1, #ip, 2) do     --=> abba qrst
        if containsAbba(ip[i]) then isTLS = true end
    end
    for i in hlp.range(2, #ip, 2) do     --=> mnop
        if containsAbba(ip[i]) then isTLS = false end
    end
    if isTLS then
        numOfTLS = numOfTLS + 1 end
end

print('Part1 one: '..numOfTLS)

--[[
    Test: filstr = 'abba[mnop]qrst\nabcd[bddb]xyyx\naaaa[qwer]tyui\nioxxoj[asdfgh]zxcvbn'
    Answer: 2 (true/false/true/false)
]]
