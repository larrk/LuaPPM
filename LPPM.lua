-- LuaJIT 2.0.4 January 16th 2018
-- Ryan Stenmark <ryanpstenmark@gmail.com>

--[[
    Axioms:

    x, y = j, i

    The grid origin is in the top left corner:
         1  2  3  4  5
       1 x  _  _  _  _
       2 |
       3 |
       4 |
       5 |
]]

-- Define LPPM class. Replace __index (normally nil) with table LPPM.
LPPM = {}
LPPM.data = {}
LPPM.colormode = 2
local LPPM_mt = { __index = LPPM }
setmetatable( LPPM, LPPM_mt )

-- Class constructor
function LPPM:new( x, y, colormode )
    new_instance = {}
    setmetatable( new_instance, LPPM_mt )
    new_instance.data = {}
    new_instance.colormode = colormode


    if colormode == 2 then
        for j = 1, y do
            table.insert(new_instance.data, {})
            for i = 1, x do
                table.insert(new_instance.data[j], 0)
            end
        end
    elseif colormode == 3 then
        for j = 1, y do
            table.insert(new_instance.data, {})
            for i = 1, x do
                table.insert(new_instance.data[j], {})
            end
        end
    end
    return new_instance
end

-- Sets a single pixel value.
function LPPM:set(x, y, v)
    self.data[y][x] = v
end

-- Converts an arbitrary size table to an LPPM object.
function tabToPPM(arr)
    new_instance = LPPM:new(#arr, #arr[1])
    for y=1, #arr do
        for x=1, #arr[1] do
            new_instance:set(x, y, arr[y][x])
        end
    end

    return new_instance
end

-- Returns a new LPPM object with each value modified by some function f.
function LPPM:process(f)
    new_instance = self
    for y, row in ipairs(self.data) do
        for x, cell in ipairs(row) do
            new_instance:set(x, y, f(cell))
        end
    end
    return new_instance
end

-- Blit an LPPM object to another LPPM object.
function LPPM:blit(ppm)
    for y=1, #ppm.data do
        for x=1, #ppm.data[1] do
            self:set(x, y, ppm.data[y][x])
        end
    end
end

-- Dumps object data table to stdout.
function LPPM:dump()
    for k, v in ipairs(self.data) do
        io.write("\n")
        for _, v in ipairs(v) do
            io.write(v .. ", ")
        end
    end
    io.write("\n")
end

function LPPM:write(filename)
    -- Create file and write appropriate header.
    file = io.open(filename, "w")
    -- If opening this file fails, exit immediately.
    if file == nil then print("I/O write failure in LPPM:write") return nil end

    header = string.format("%02s\n%1d %1d %3d\n", "P" .. self.colormode, #self.data, #self.data[1], 255)
    file:write(header)
    io.close(file)
    -- Close file and reopen in append update mode
    file = io.open(filename, "a+")

    -- Stringify self.data and write to file

    str = {}

    for y, row in ipairs(self.data) do
        for x, cell in ipairs(row) do
            if self.colormode == 2 then
                c = tostring(cell)
                table.insert(str, c)
            elseif self.colormode == 3 then
                c = string.format(tostring(cell[1]), tostring(cell[2]), tostring(cell[3]))
                table.insert(str, c)
            end
        end
    end

    data_string = table.concat(str, " ")
    file:write(data_string)
    file:close()
end
