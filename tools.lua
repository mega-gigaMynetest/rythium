-- support for MT game translation.
local S = minetest.get_translator(rythium)

-- Retrieving mod settings
local rythium = {}
rythium.wands_max_charge = minetest.settings:get("rythium.wands_max_charge")

--
-- Wands
--

-- Healing wand
minetest.register_tool("rythium:healing_wand", {
	description = S("Healing wand"),
	inventory_image = "rythium_healing_wand.png",
	on_use = function(itemstack, user, pointed_thing)
		minetest.sound_play("rythium_healing")
		-- pointed_thing is a table and this table contains a ref variable,
		-- i.e. another table which represents the pointed object itself.
		-- difference is tested with ~= not with != as in other languages
		if (pointed_thing.ref~=nil and pointed_thing.ref:is_player())
		then
			pointed_thing.ref:set_hp(20)
		else
			user:set_hp(20)
		end
	end,
})

local pos = {}

minetest.register_tool("rythium:huge_pick", {
    description = ("3*3 Pick"),
    inventory_image = "huge_pick.png",
    on_use = function(itemstack, user, pointed_thing)
        pos = minetest.get_pointed_thing_position(pointed_thing, false)
    end,
    tool_capabilities = {
        full_punch_interval = 0.9,
        max_drop_level=3,
        groupcaps={
            cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=40, maxlevel=3},
        },
        damage_groups = {fleshy=4},
    },
    after_use = function(itemstack, user, node, digparams)
        minetest.dig_node({x = pos.x, y = pos.y, z = pos.z})
        minetest.dig_node({x = pos.x, y = pos.y, z = pos.z + 1})
        minetest.dig_node({x = pos.x, y = pos.y, z = pos.z - 1})
        minetest.dig_node({x = pos.x, y = pos.y + 1, z = pos.z})
        minetest.dig_node({x = pos.x, y = pos.y - 1, z = pos.z})
        minetest.dig_node({x = pos.x, y = pos.y + 1, z = pos.z + 1})
        minetest.dig_node({x = pos.x, y = pos.y - 1, z = pos.z - 1})
        minetest.dig_node({x = pos.x, y = pos.y + 1, z = pos.z - 1})
        minetest.dig_node({x = pos.x, y = pos.y - 1, z = pos.z + 1})
    end,
    sound = {breaks = "default_tool_breaks"},
    groups = {pickaxe = 1}
})
