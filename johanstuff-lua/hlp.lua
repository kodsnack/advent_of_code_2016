--[[
    Some module/helpers
]]

local hlp = {}


--Source: forums.curseforge.com , User: Xinhuan
--Info: All it does is create a new sorting function for every combination of column sorting you throw at it, and storing these functions in a table for reuse.
local sort = { "col2", "col1" }
function hlp.cmp2col(lhs, rhs)
    --print('--------')
    if lhs[sort[1]] ~= rhs[sort[1]] then
        return lhs[sort[1]] < rhs[sort[1]]
    elseif lhs[sort[2]] ~= rhs[sort[2]] then
        return lhs[sort[2]] > rhs[sort[2]]
    end
end

--Source: stackoverflow.com
function hlp.split(str, sep)
    if sep == nil then sep = "%s" end
    local t={}   i=1
    for str in string.gmatch(str, "([^"..sep.."]+)") do
        t[i] = str   i = i + 1  --for k,v in ipairs( split('aa[bb', '[') ) do print(k,v) end
    end
    return t
end

--Source: Lua manual
function hlp.pprint(arr)
    --for k,v in ipairs(arr) do print(k,v) end
    print(table.concat(arr,','))
end

--Source: lua-users.org/wiki
function hlp.range(from, to, step)
  step = step or 1
  return function(_, lastvalue)
    local nextvalue = lastvalue + step
    if step > 0 and nextvalue <= to or step < 0 and nextvalue >= to or
       step == 0
    then
      return nextvalue
    end
  end, nil, from - step
end


return hlp
