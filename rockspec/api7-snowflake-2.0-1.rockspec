package = "api7-snowflake"
version = "2.0-1"

source = {
	url = "git://github.com/api7/lua-snowflake.git",
	tag = "v2.0",
}

description = {
	summary = "An implementation of a distributed ID generator, similar to Snowflake by Twitter",
	homepage = "http://github.com/api7/lua-snowflake",
	license = "MIT",
	maintainer = "Stuart Carnie",
}

dependencies = {
	"lua >= 5.1",
}

build = {
	type = "builtin",

    modules = {
        ["api7-snowflake"] = {
            sources = { "src/main.c" }
        }
    },
}
