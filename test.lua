local sf = require "api7-snowflake"

function Sleep(n)
    local t0 = os.clock()
    while os.clock() - t0 <= n do
    end
end

sf.init(0x1f, 0x1f, nil, 6, 6, 12)
print(sf.next_id())
