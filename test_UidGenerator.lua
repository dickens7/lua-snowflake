-- 
-- The reason for "luaL_checklong" does not guarantee that every test is correct
--

local sf = require "snowflake"
local socket = require("socket")

function sleep(n)
    socket.select(nil, nil, n)
 end

sf.init(0x0, 0x1, 1609459200000, 11, 11, 13, 1000)
local a=1000
while( a>0 )
do
    local id = sf.next_id()
    local offset = sf.getmillisecond() - 1609459200
    local result =  sf.bit_split(id)
    print("result:" .. result)
    print("offset:" .. offset)
    sleep(0.01)
    a = a-1
end