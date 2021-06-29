#include <lua.h>
#include <lauxlib.h>
#include <stdbool.h>
#include <sys/time.h>
#include <string.h>

#if LUA_VERSION_NUM < 502
#define luaL_newlib(L, l) (lua_newtable(L), luaL_register(L, NULL, l))
#endif

static bool initialized = false;

static int g_datacenter_id = 0;
static int g_node_id = 0;
static long g_last_timestamp = -1;
static int g_sequence = 0;

// 2021-01-01T00:00:00Z
#define SNOWFLAKE_EPOC 1609459200000L

#define NODE_ID_BITS 5
#define DATACENTER_ID_BITS 5
#define SEQUENCE_BITS 12
#define NODE_ID_SHIFT SEQUENCE_BITS
#define DATACENTER_ID_SHIFT (NODE_ID_SHIFT + NODE_ID_BITS)
#define TIMESTAMP_SHIFT (DATACENTER_ID_SHIFT + DATACENTER_ID_BITS)

#define SEQUENCE_MASK (0xffffffff ^ (0xffffffff << SEQUENCE_BITS))

struct conf
{
    long snowflake_epoc;
    int node_id_bits;
    int datacenter_id_bits;
    int sequence_bits;
    int node_id_shift;
    int datacenter_id_shift;
    int timestamp_shift;
    int sequence_mask;
} conf;

static long get_timestamp()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);

    return tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

static long get_til_next_millis(long last_timestamp)
{
    long ts = get_timestamp();
    while (ts < last_timestamp)
    {
        ts = get_timestamp();
    }

    return ts;
}

static int luasnowflake_init(lua_State *L)
{
    conf.snowflake_epoc = luaL_optlong(L, 3, SNOWFLAKE_EPOC);
    conf.node_id_bits = luaL_optint(L, 4, NODE_ID_BITS);
    conf.datacenter_id_bits = luaL_optint(L, 5, DATACENTER_ID_BITS);
    conf.sequence_bits = luaL_optint(L, 6, SEQUENCE_BITS);

    if ((conf.node_id_bits + conf.datacenter_id_bits + conf.sequence_bits) > 32)
    {
        return luaL_error(L, "(node_id_bits + datacenter_id_bits + sequence_bits) cannot be greater than 32");
    }

    g_datacenter_id = luaL_checkint(L, 1);
    if (g_datacenter_id < 0x00 || g_datacenter_id > (1 << conf.datacenter_id_bits))
    {
        return luaL_error(L, "datacenter_id must be an integer n, where 0 ≤ n ≤ %d", (1 << conf.datacenter_id_bits));
    }

    g_node_id = luaL_checkint(L, 2);
    if (g_node_id < 0x00 || g_node_id > (1 << conf.node_id_bits))
    {
        return luaL_error(L, "node_id must be an integer n where 0 ≤ n ≤ %d", (1 << conf.node_id_bits));
    }

    conf.node_id_shift = conf.sequence_bits;
    conf.datacenter_id_shift = (conf.node_id_shift + conf.node_id_bits);
    conf.timestamp_shift = (conf.datacenter_id_shift + conf.datacenter_id_bits);
    conf.sequence_mask = (0xffffffff ^ (0xffffffff << conf.sequence_bits));

    initialized = true;

    return 1;
}

static int luasnowflake_next_id(lua_State *L)
{
    if (!initialized)
    {
        return luaL_error(L, "snowflake.init must be called first");
    }

    long ts = get_timestamp();

    if (g_last_timestamp == ts)
    {
        g_sequence = (g_sequence + 1) & conf.sequence_mask;
        if (g_sequence == 0)
        {
            ts = get_til_next_millis(g_last_timestamp);
        }
    }
    else
    {
        g_sequence = 0;
    }

    g_last_timestamp = ts;
    ts = ((ts - conf.snowflake_epoc) << conf.timestamp_shift) | (g_datacenter_id << conf.datacenter_id_shift) | (g_node_id << conf.node_id_shift) | g_sequence;

    char buffer[32];
    snprintf(buffer, 32, "%ld", ts);
    lua_pushstring(L, buffer);

    return 1;
}

static const struct luaL_Reg luasnowflake_lib[] = {
    {"init", luasnowflake_init},
    {"next_id", luasnowflake_next_id},
    {NULL, NULL},
};

LUALIB_API int luaopen_snowflake(lua_State *const L)
{
    luaL_newlib(L, luasnowflake_lib);

    return 1;
}
