minetest.register_craftitem("rythium:diamond_powder", {
	description = ("Diamond powder"),
	inventory_image = "diamond_powder.png",
})

minetest.register_craftitem("rythium:mithril_powder", {
	description = ("Mithril_powder"),
	inventory_image = "mithril_powder.png",
})

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

minetest.register_node("rythium:mineral_dirt", {
  description = ("Mineral fertilized dirt"),
  tiles = {"mineral_dirt.png"},
  groups = {crumbly = 3, soil = 1},
  sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_craft( {
        output = "rythium:mineral_dirt",
        recipe = {
                {"", "rythium:diamond_powder", "" },
                { "rythium:mithril_powder", "default:dirt", "rythium:mithril_powder" },
                {"", "rythium:diamond_powder", ""},
        },
})
