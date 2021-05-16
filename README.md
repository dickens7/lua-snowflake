lua-snowflake
=============

An implementation of [Snowflake](https://blog.twitter.com/2010/announcing-snowflake) for Lua. Snowflake is an algorithm
which supports ordered, distributed id generation. 

Installation
------------

    $ luarocks install snowflake
     
Usage
-----

    local sf = require "snowflake"
    sf.init(0x01, 0x01)
    local uuid = sf.next_id()

`uuid` will be a 64-bit number represented as a string that is structured as follows:

    6  6         5         4         3         2         1         
    3210987654321098765432109876543210987654321098765432109876543210
    
    tttttttttttttttttttttttttttttttttttttttttdddddnnnnnsssssssssssss

where

* `s` is a 10-bit integer that increments when next_id() is called multiple times for the same millisecond
* `n` is a 7-bit integer representing the node within a given data center
* `d` is a 7-bit integer representing a unique data center or group of servers
* `t` is a 39-bit integer representing the current timestamp in milliseconds
    * the number of milliseconds to have elapsed since 1609430400000 or 2021-01-01T00:00:00Z

`sf.init(datacenter_id, node_id)` is used to initialize snowflake and set values for ddddd and nnnnn as follows:

* `datacenter_id` is an integer n, where 0 ≤ n ≤ 0x7f and specifies the `ddddd` portion of the id
* `node_id` is an integer n, where 0 ≤ n ≤ 0x7f and specifies the `nnnnn` portion of the id
