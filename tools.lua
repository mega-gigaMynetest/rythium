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
		local player = user
		minetest.sound_play("rythium_healing")
		player:set_hp(20)
	end,
})
