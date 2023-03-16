# Unified Stamina API

This modding API provides easier access to different stamina implementations.
The stamina bar provides an essential gameplay mechanic, yet every sprint mod implements their own version.
Instead of implementing support for every single sprint mod you can use this instead.
It adds an abstraction layer between your new mod and the sprint mod so that you can access
every single sprint mod through the same API. You will get the same functions no matter which sprint mod is used.

## How to use

```lua
-- get current stamina value of a given player
-- return float between 0 and 1
-- always return 1 if no mod with a stamina bar is present
local stamina_value = unified_stamina.get(player_name)

-- sets the current stamina value of a given player
-- expects normalized value between 0 and 1 (here: 0.4 = 40% of the bar)
local new_value = 0.4
unified_stamina.set(player_name, new_value)

-- changes the current stamina value of a given player by the specified amount
-- expects normalized value between 0 and 1
-- positive values will increase stamina, negative values will decrease it (here: decrease by 20%)
local change = -0.2
unified_stamina.add(player_name, change)

-- returns the scale of the stamina bar for display purposes
-- a return value of e.g. 20 means that a player has a total value of 20 points at 100%
local display_scale = unified_stamina.get_scale()
```

## Compatible Mods

* [Hbsprint](https://content.minetest.net/packages/texmex/hbsprint/) [hbsprint]
* [Minetest Wadsprint](https://content.minetest.net/packages/drkwv/minetest_wadsprint/) [minetest_wadsprint]
* [Sprint Lite](https://content.minetest.net/packages/mt-mods/sprint_lite/) [sprint_lite]
* [Stamina++](https://content.minetest.net/packages/nekobit/real_stamina/) [real_stamina]

This mod doesn't work for *Stamina* by sofar or *Stamina (Fork)* by TenPlus1. Despite the name they only add a hunger bar and not an actual stamina bar. Unified Stamina API will always return full stamina if no compatible mod is installed.

## License
All code is licensed under MIT. No media assets were used.