-- mithril powder
if not minetest.get_modpath("technic") then
	minetest.register_craft({
		type = "cooking",
		output = "rythium:mithril_powder",
		recipe = "moreores:mithril_ingot",
	})
end

-- diamond powder
if minetest.get_modpath("technic") then
	technic.register_grinder_recipe({input = { "default:diamond" }, output = "rythium:diamond_powder 1"})
else
	minetest.register_craft({
		type = "cooking",
		output = "rythium:diamond_powder",
		recipe = "default:diamond",
	})
end

minetest.register_craft({
	output = "rythium:sapling",
	recipe = {
		{"default:diamondblock", "default:mese", "default:diamondblock" },
		{"rythium:mithril_powder", "default:mese", "rythium:mithril_powder" },
		{"", "default:stick", ""},
	},
})

minetest.register_craft({
	output = "rythium:mineral_dirt",
	recipe = {
		{"", "rythium:diamond_powder", "" },
		{ "rythium:mithril_powder", "default:dirt", "rythium:mithril_powder" },
		{"", "rythium:diamond_powder", ""},
	},
})

minetest.register_craft({
	output = "rythium:healing_wand",
	recipe = {
		{"default:apple", "rythium:rythium_ingot", "default:apple"},
		{"default:apple", "rythium:rythium_ingot", "default:apple"},
		{"", "default:stick", ""},
	},
})

minetest.register_craft({
	output = "rythium:huge_pick",
	recipe = {
		{"rythium:rythium_ingot", "rythium:rythium_ingot", "rythium:rythium_ingot"},
		{"rythium:rythium_ingot", "default:stick", "rythium:rythium_ingot"},
		{"", "default:stick", ""},
	},
})

minetest.register_craft({
        output = "rythium:rythium_ingot",
        recipe = {
                {"rythium:rythium_nugget", "rythium:rythium_nugget", "rythium:rythium_nugget" },
                { "rythium:rythium_nugget", "rythium:rythium_nugget", "rythium:rythium_nugget" },
                {"rythium:rythium_nugget", "rythium:rythium_nugget", "rythium:rythium_nugget"},
        },
})

minetest.register_craft({
        output = "rythium:rythium_block",
        recipe = {
                {"rythium:rythium_ingot", "rythium:rythium_ingot", "rythium:rythium_ingot" },
                { "rythium:rythium_ingot", "rythium:rythium_ingot", "rythium:rythium_ingot" },
                {"rythium:rythium_ingot", "rythium:rythium_ingot", "rythium:rythium_ingot"},
        },
})

minetest.register_craft({
        output = "rythium:rythium_ingot 9",
        recipe = {
                {"rythium:rythium_block"},
        },
})

minetest.register_craft({
        output = "rythium:rythium_nugget 9",
        recipe = {
                {"rythium:rythium_ingot"},
        },
})

minetest.register_craft({
        output = "rythium:headlamp_controller",
        recipe = {
                {"", "rythium:rythium_nugget", "" },
                { "", "default:stick", "" },
                {"", "default:stick", ""},
        },
})

minetest.register_craft({
        output = "rythium:headlamp",
        recipe = {
                {"rythium:rythium_ingot", "rythium:rythium_ingot", "rythium:rythium_ingot" },
                {"rythium:rythium_ingot", "", "rythium:rythium_ingot"},
                {"", "", ""},
        },
})
