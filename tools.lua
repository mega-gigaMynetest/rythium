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
