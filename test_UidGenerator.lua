local sf = require "snowflake"

sf.init(0x1f, 0x1f, nil, 11, 11, 13, 1000)
print(sf.next_id())
