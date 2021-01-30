if minetest.get_modpath("treecapitator") then
	treecapitator.register_tree({
		trees = {"default:tree"},
		leaves = {"rythium:leaves"},
		range = 2,
		range_up = 9,
		stem_height_min = 5,
		fruits = {"rythium:rythium_nugget"},
	})
end
