local function grow_rythium_sapling(...)
	return default.grow_rythium_sapling(...)
end
local S = default.get_translator
local random = math.random

function default.can_grow(pos)
	local node_under = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
	if not node_under then
		return false
	end
	local name_under = node_under.name
	if name_under ~= "rythium:mineral_dirt" then
		return false
	end
	local light_level = minetest.get_node_light(pos)
	if not light_level or light_level < 13 then
		return false
	end
	return true
end


local function is_snow_nearby(pos)
	return minetest.find_node_near(pos, 1, {"group:snowy"})
end


function default.grow_rythium_sapling(pos)
	if not default.can_grow(pos) then
		minetest.get_node_timer(pos):start(10)
		return
	end
	local mg_name = minetest.get_mapgen_setting("mg_name")
	local node = minetest.get_node(pos)
	if node.name == "rythium:sapling" then
		minetest.log("action", "A rythium sapling grows into a rythium tree at "..
			minetest.pos_to_string(pos))
    grow_rythium_tree(pos, 1)
  end
end

local function add_trunk_and_leaves_rythium(data, a, pos, tree_cid, leaves_cid,
		height, size, iters, is_apple_tree)
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

	for z_dist = -1, 1 do
	for y_dist = -size, 1 do
		local vi = a:index(x - 1, y + height + y_dist, z + z_dist)
		for x_dist = -1, 1 do
			if data[vi] == c_air or data[vi] == c_ignore then
				if is_apple_tree and random(1, 25) == 1 then
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
				if is_apple_tree and random(1, 25) == 1 then
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

function grow_rythium_tree(pos, is_apple_tree, bad)
	if bad then
		error("Deprecated use of grow_rythium_tree")
	end
	local x, y, z = pos.x, pos.y, pos.z
	local height = random(2, 3)
	local c_rythium_tree = minetest.get_content_id("default:tree")
	local c_rythium_leaves = minetest.get_content_id("rythium:leaves")
	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - 2, y = y, z = z - 2},
		{x = x + 2, y = y + height + 1, z = z + 2}
	)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	add_trunk_and_leaves_rythium(data, a, pos, c_rythium_tree, c_rythium_leaves, height, 2, 8, is_apple_tree)
	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end

function default.sapling_on_place(itemstack, placer, pointed_thing,
		sapling_name, minp_relative, maxp_relative, interval)
	local pos = pointed_thing.under
	local node = minetest.get_node_or_nil(pos)
	local pdef = node and minetest.registered_nodes[node.name]
	if pdef and pdef.on_rightclick and
			not (placer and placer:is_player() and
			placer:get_player_control().sneak) then
		return pdef.on_rightclick(pos, node, placer, itemstack, pointed_thing)
	end
	if not pdef or not pdef.buildable_to then
		pos = pointed_thing.above
		node = minetest.get_node_or_nil(pos)
		pdef = node and minetest.registered_nodes[node.name]
		if not pdef or not pdef.buildable_to then
			return itemstack
		end
	end

	local player_name = placer and placer:get_player_name() or ""
	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return itemstack
	end
	if minetest.is_area_protected(
			vector.add(pos, minp_relative),
			vector.add(pos, maxp_relative),
			player_name,
			interval) then
		minetest.record_protection_violation(pos, player_name)
		minetest.chat_send_player(player_name,
		    S("@1 will intersect protection on growth.",
			itemstack:get_definition().description))
		return itemstack
	end

	minetest.log("action", player_name .. " places node "
			.. sapling_name .. " at " .. minetest.pos_to_string(pos))

	local take_item = not (creative and creative.is_enabled_for
		and creative.is_enabled_for(player_name))
	local newnode = {name = sapling_name}
	local ndef = minetest.registered_nodes[sapling_name]
	minetest.set_node(pos, newnode)

	if ndef and ndef.after_place_node then
		-- Deepcopy place_to and pointed_thing because callback can modify it
		if ndef.after_place_node(table.copy(pos), placer,
				itemstack, table.copy(pointed_thing)) then
			take_item = false
		end
	end

	for _, callback in ipairs(minetest.registered_on_placenodes) do
		-- Deepcopy pos, node and pointed_thing because callback can modify them
		if callback(table.copy(pos), table.copy(newnode),
				placer, table.copy(node or {}),
				itemstack, table.copy(pointed_thing)) then
			take_item = false
		end
	end

	if take_item then
		itemstack:take_item()
	end

	return itemstack
end
