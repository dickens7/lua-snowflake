local sf = require "api7-snowflake"

sf.init(0x1f, 0x1f)
print(sf.next_id())
