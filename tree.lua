local random = math.random

local grow_ground_nodes = {
	{{x = 0, y = -1, z = 0}, "rythium:mineral_dirt"},
	{{x = 0, y = -1, z = 1}, "rythium:mineral_dirt"},
	{{x = 0, y = -1, z = -1}, "rythium:mineral_dirt"},
	{{x = -1, y = -1, z = 0}, "rythium:mineral_dirt"},
	{{x = 1, y = -1, z = 0}, "rythium:mineral_dirt"},
	{{x = -1, y = -1, z = 1}, "rythium:mineral_dirt"},
	{{x = 1, y = -1, z = 1}, "rythium:mineral_dirt"},
	{{x = -1, y = -1, z = -1}, "rythium:mineral_dirt"},
	{{x = 1, y = -1, z = -1}, "rythium:mineral_dirt"},

	{{x = 0, y = -1, z = 2}, "default:water_source"},
	{{x = 1, y = -1, z = 2}, "default:water_source"},
	{{x = 2, y = -1, z = 2}, "default:water_source"},
	{{x = -1, y = -1, z = 2}, "default:water_source"},
	{{x = -2, y = -1, z = 2}, "default:water_source"},
	{{x = 2, y = -1, z = 1}, "default:water_source"},
	{{x = -2, y = -1, z = 1}, "default:water_source"},
	{{x = 2, y = -1, z = 0}, "default:water_source"},
	{{x = -2, y = -1, z = 0}, "default:water_source"},
	{{x = 2, y = -1, z = -1}, "default:water_source"},
	{{x = -2, y = -1, z = -1}, "default:water_source"},
	{{x = 0, y = -1, z = -2}, "default:water_source"},
	{{x = 1, y = -1, z = -2}, "default:water_source"},
	{{x = 2, y = -1, z = -2}, "default:water_source"},
	{{x = -1, y = -1, z = -2}, "default:water_source"},
	{{x = -2, y = -1, z = -2}, "default:water_source"},
}

local function can_grow(pos)
	for _, v in ipairs(grow_ground_nodes) do
		local node_pos = vector.add(pos, v[1])
		if minetest.get_node(node_pos).name ~= v[2] then
			return false
		end
	end

	local light_level = minetest.get_node_light(pos)
	if not light_level or light_level < 13 then
		return false
	end
	return true
end

local function add_trunk_and_leaves_rythium(data, a, pos, tree_cid, leaves_cid,
		height, size, iters)
	local x, y, z = pos.x, pos.y, pos.z
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_apple = minetest.get_content_id("rythium:rythium_nugget")

	data[a:index(x, y, z)] = tree_cid
	for yy = y + 1, y + height - 1 do
		local vi = a:index(x, yy, z)
		local node_id = data[vi]
		if node_id == c_air or node_id == c_ignore or node_id == leaves_cid then
			data[vi] = tree_cid
		end
	end

	for z_dist = -1, 2 do
	for y_dist = -size, 2 do
		local vi = a:index(x - 1, y + height + y_dist, z + z_dist)
		for x_dist = -1, 2 do
			if data[vi] == c_air or data[vi] == c_ignore then
				if random(1, 50) == 1 then
					data[vi] = c_apple
				else
					data[vi] = leaves_cid
				end
			end
			vi = vi + 1
		end
	end
	end
	for i = 1, iters do
		local clust_x = x + random(-size, size - 1)
		local clust_y = y + height + random(-size, 0)
		local clust_z = z + random(-size, size - 1)

		for xi = 0, 1 do
		for yi = 0, 1 do
		for zi = 0, 1 do
			local vi = a:index(clust_x + xi, clust_y + yi, clust_z + zi)
			if data[vi] == c_air or data[vi] == c_ignore then
				if random(1, 25) == 1 then
					data[vi] = c_apple
				else
					data[vi] = leaves_cid
				end
			end
		end
		end
		end
	end
end

local function grow_rythium_tree(pos)
	local x, y, z = pos.x, pos.y, pos.z
	local height = random(5, 6)
	local c_rythium_tree = minetest.get_content_id("default:tree")
	local c_rythium_leaves = minetest.get_content_id("rythium:leaves")
	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - 2, y = y, z = z - 2},
		{x = x + 2, y = y + height + 1, z = z + 2}
	)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	add_trunk_and_leaves_rythium(data, a, pos, c_rythium_tree, c_rythium_leaves, height, 2, 8)
	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end

function rythium.grow_rythium_sapling(pos)
	if not can_grow(pos) then
		minetest.get_node_timer(pos):start(10)
		return
	end
	local node = minetest.get_node(pos)
	if node.name == "rythium:sapling" then
		minetest.log("action", "A rythium sapling grows into a rythium tree at "..
			minetest.pos_to_string(pos))
		grow_rythium_tree(pos)
		minetest.set_node({x = pos.x, y = pos.y - 1, z = pos.z}, {name = "default:dirt"})
		minetest.set_node({x = pos.x, y = pos.y - 1, z = pos.z + 1}, {name = "default:dirt"})
		minetest.set_node({x = pos.x, y = pos.y - 1, z = pos.z - 1}, {name = "default:dirt"})
		minetest.set_node({x = pos.x - 1, y = pos.y - 1, z = pos.z}, {name = "default:dirt"})
		minetest.set_node({x = pos.x + 1, y = pos.y - 1, z = pos.z}, {name = "default:dirt"})
		minetest.set_node({x = pos.x - 1, y = pos.y - 1, z = pos.z + 1}, {name = "default:dirt"})
		minetest.set_node({x = pos.x + 1, y = pos.y - 1, z = pos.z + 1}, {name = "default:dirt"})
		minetest.set_node({x = pos.x - 1, y = pos.y - 1, z = pos.z- 1}, {name = "default:dirt"})
		minetest.set_node({x = pos.x + 1, y = pos.y - 1, z = pos.z - 1}, {name = "default:dirt"})
	end
end
