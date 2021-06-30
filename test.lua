local sf = require "snowflake"

sf.init(0x1f, 0x1f, nil, 5, 5, 12)
print(sf.next_id())
