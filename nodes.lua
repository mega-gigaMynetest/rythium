-- support for translation.
local S = minetest.get_translator("rythium")

minetest.register_craftitem("rythium:diamond_powder", {
	description = S("Diamond powder"),
	inventory_image = "rythium_diamond_powder.png",
})

-- mithril powder
if minetest.get_modpath("technic") then
	minetest.register_alias("rythium:mithril_powder","technic:mithril_dust")
else
	minetest.register_craftitem("rythium:mithril_powder", {
		description = S("Mithril powder"),
		inventory_image = "rythium_mithril_powder.png",
	})
end

minetest.register_node("rythium:mineral_dirt", {
	description = S("Mineral fertilized dirt"),
	tiles = {"rythium_mineral_dirt.png"},
	groups = {crumbly = 3, soil = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_craftitem("rythium:rythium_ingot", {
	description = S("Rythium ingot"),
	inventory_image = "rythium_ingot.png"
}
)

minetest.register_node("rythium:rythium_nugget", {
	description = S("Rythium nugget"),
	drawtype = "plantlike",
	tiles = {"rythium_nugget.png"},
	inventory_image = "rythium_nugget.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {leafdecay = 3, leafdecay_drop = 1, cracky = 1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("rythium:rythium_block", {
	description = S("Rythium block"),
	tiles = {"rythium_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("rythium:leaves", {
	description = S("Rythium leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"rythium_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"rythium:sapling"},
				rarity = 60,
			},
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("rythium:sapling", {
	description = S("Rythium sapling"),
	drawtype = "plantlike",
	tiles = {"rythium_sapling.png"},
	inventory_image = "rythium_sapling.png",
	wield_image = "rythium_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = rythium.grow_rythium_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 900))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		return default.sapling_on_place(itemstack, placer, pointed_thing,
			"rythium:sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -3, y = 1, z = -3},
			{x = 3, y = 6, z = 3},
			4)
	end,
})
