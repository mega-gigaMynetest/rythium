-- support for MT game translation.
local S = minetest.get_translator(rythium)

--
-- Wands
--


---- Crystal Gilly Staff (replenishes air supply when used)
--minetest.register_tool("ethereal:crystal_gilly_staff", {
--	description = S("Crystal Gilly Staff"),
--	inventory_image = "crystal_gilly_staff.png",
--	wield_image = "crystal_gilly_staff.png",

--	on_use = function(itemstack, user, pointed_thing)
--		if user:get_breath() < 10 then
--			user:set_breath(10)
--		end
--	end,
--})

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
