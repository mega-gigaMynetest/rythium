--local function grow_rythium_sapling(...)
--	return default.grow_rythium_sapling(...)
--end
--local S = default.get_translator
--local random = math.random

minetest.register_craft({
	type = "cooking",
	output = "rythium:mithril_powder",
	recipe = "moreores:mithril_ingot",
})

minetest.register_craft({
	type = "cooking",
	output = "rythium:diamond_powder",
	recipe = "default:diamond",
})



minetest.register_craft( {
	output = "rythium:sapling",
	recipe = {
		{"rythium:diamond_powder", "default:mese_crystal", "rythium:diamond_powder" },
		{"rythium:mithril_powder", "default:mese_crystal", "rythium:mithril_powder" },
		{"", "default:stick", ""},
	},
})

minetest.register_craft( {
	output = "rythium:mineral_dirt",
	recipe = {
		{"", "rythium:diamond_powder", "" },
		{ "rythium:mithril_powder", "default:dirt", "rythium:mithril_powder" },
		{"", "rythium:diamond_powder", ""},
	},
})

minetest.register_craft( {
	output = "rythium:healing_wand",
	recipe = {
		{"default:apple", "rythium:rythium_ingot", "default:apple"},
		{"default:apple", "rythium:rythium_ingot", "default:apple"},
		{"", "default:stick", ""},
	},
})
