local sf = require "snowflake"
local socket = require("socket")

local function sleep(n)
    socket.select(nil, nil, n)
end

local function check (sf ,start)
    local a = 1000
    local i = 0
    local last_offset
    while( a>0 )
    do
        local id = sf.next_id()
        local offset = sf.getmillisecond() - start
        if last_offset ~= offset then
            i = 0
        end
        local result =  sf.bit_split(id)
        if ("1, "..offset..", " .. i ~= result) then
            print("result:" .. result)
            print("offset:" .. offset)
            print("\n1, "..offset..", " .. i)
        end
        sleep(0.02)
        last_offset = offset
        a = a-1
        i = i+1
    end
end

sf.init(0x0, 0x1, 1609459200000, 5, 5, 10, 1)
check(sf, 1609459200000)
print("1 millisecond success\n")


sf.init(0x0, 0x1, 1609459200000, 5, 5, 10, 10)
check(sf, 160945920000)
print("10 millisecond success\n")


sf.init(0x0, 0x1, 1609459200000, 5, 5, 10, 100)
check(sf, 16094592000)
print("100 millisecond success\n")

sf.init(0x0, 0x1, 1609459200000, 5, 5, 10, 1000)
check(sf, 1609459200)
print("1000 millisecond success\n")