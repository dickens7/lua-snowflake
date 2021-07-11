local sf = require "snowflake"

sf.init(0x1f, 0x1f, nil, 8, 8, 8, 10)
print(sf.next_id())
