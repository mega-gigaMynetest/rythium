-- support for MT game translation.
local S = minetest.get_translator(rythium)

-- Retrieving mod settings
local rythium = {}
rythium.wands_max_charge = minetest.settings:get("rythium.wands_max_charge")

dofile(minetest.get_modpath("rythium").."/tools.lua")
dofile(minetest.get_modpath("rythium").."/nodes.lua")
dofile(minetest.get_modpath("rythium").."/craft.lua")
dofile(minetest.get_modpath("rythium").."/tree.lua")

