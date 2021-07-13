-- 
-- The reason for "luaL_checklong" does not guarantee that every test is correct
--

local sf = require "snowflake"
local socket = require("socket")

function sleep(n)
    socket.select(nil, nil, n)
 end

sf.init(0x0, 0x1, 1609459200000, 5, 5, 10, 1)
local a=10
while( a>0 )
do
    local id = sf.next_id()
    local offset = sf.getmillisecond() - 1609459200000
    local result =  sf.bit_split(id)
    if (result ~= "1, " .. offset) then
        print("offset:" .. offset)
        print("rece : " .. result)
        print("fail")
    end
    a = a-1
end
print("1 millisecond success")


sf.init(0x0, 0x1, 1609459200000, 5, 5, 10, 10)
local a=10
while( a>0 )
do
    local id = sf.next_id()
    local offset = sf.getmillisecond() - 160945920000
    local result =  sf.bit_split(id)
    if (result ~= "1, " .. offset) then
        print("offset:" .. offset)
        print("rece : " .. result)
        print("fail")
    end
    sleep(0.01)
    a = a-1
end
print("10 millisecond success")


sf.init(0x0, 0x1, 1609459200000, 5, 5, 10, 100)
local a=10
while( a>0 )
do
    local id = sf.next_id()
    local offset = sf.getmillisecond() - 16094592000
    local result =  sf.bit_split(id)
    if (result ~= "1, " .. offset) then
        print("offset:" .. offset)
        print("rece : " .. result)
        print("fail")
    end
    sleep(0.01)
    a = a-1
end
print("100 millisecond success")

sf.init(0x0, 0x1, 1609459200000, 5, 5, 10, 1000)
local a=10
while( a>0 )
do
    local id = sf.next_id()
    local offset = sf.getmillisecond() - 1609459200
    local result =  sf.bit_split(id)
    if (result ~= "1, " .. offset) then
        print("offset:" .. offset)
        print("rece : " .. result)
        print("fail")
    end
    sleep(0.1)
    a = a-1
end
print("1000 millisecond success")