#!/usr/bin/luajit
-- LuaJIT 2.0.4 November 26th 2017

require "LPPM"

x, y = 4096, 4096
LPPM_new = LPPM:new(x, y)
-- LPPM_new:set(6, 5, 1)
-- LPPM_new:dump()

local f; f = function(i)
    return math.floor((i / x) * 255)
end

LPPM_clone =  LPPM_new:process(f)

--[[
for i=1, y do
    LPPM_clone:set(i, i, 0)
    LPPM_clone:set(y-i+1, i, 0)
end
]]

--LPPM_clone:dump()
LPPM_clone:write("ppm")