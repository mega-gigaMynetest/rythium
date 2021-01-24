-- support for translation.
local S = minetest.get_translator("rythium")

--
-- Wands
--

-- Retrieving mod settings
-- https://dev.minetest.net/Settings (beware of the bug !)
local wands_max_use = minetest.settings:get("rythium.wands_max_use") or 20
local wands_wear = 65535/(wands_max_use-1)

-- Healing wand
minetest.register_tool("rythium:healing_wand", {
	description = S("Healing wand"),
	inventory_image = "rythium_healing_wand.png",
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		minetest.sound_play("rythium_healing", {to_player = name, gain = 0.5}, true)
		-- pointed_thing is a table and this table contains a ref variable,
		-- i.e. another table which represents the pointed object itself.
		if pointed_thing.ref and pointed_thing.ref:is_player() then
			pointed_thing.ref:set_hp(20)
			minetest.sound_play("rythium_healing",
				{to_player = pointed_thing.ref:get_player_name(), gain = 0.5},
				true)
		else
			user:set_hp(20)
		end
		-- Wand wear management
		-- user is an object representing a player, is_creative_enabled needs only the name
		if not minetest.is_creative_enabled(user:get_player_name()) then
			itemstack:add_wear(wands_wear)
			if itemstack:get_count() == 0 then
				minetest.sound_play("default_tool_breaks", {to_player = name}, true)
			end
			return itemstack -- /!\ On_use must return the modified itemstack
		end
	end,
})

--
-- Rythium Pickaxe
--

-- This is set to false when the callback runs, to prevent additional calls to
-- on_dig from making it run again
local pick_cb_enabled = true

local function dig_it(pos, player)
	local player_name = player:get_player_name()
	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return
	end
	local node = minetest.get_node(pos)
	local node_name = node.name
	local groupcracky = minetest.get_item_group(node_name, "cracky")
	if node_name == "air" or node_name == "ignore" then return end
	if node_name == "default:lava_source" then return end
	if node_name == "default:lava_flowing" then return end
	if node_name == "default:water_source" then minetest.remove_node(pos) return end
	if node_name == "default:water_flowing" then minetest.remove_node(pos) return end
	local def = minetest.registered_nodes[node_name]
	if not def then return end
	if groupcracky == 0 then return end

	def.on_dig(pos, node, player)
end

local dig_offsets = {
	{x = 0,  y = 1,  z = 0},
	{x = 1,  y = 1,  z = 0},
	{x = -1, y = 1,  z = 0},
	{x = 1,  y = 0,  z = 0},
	{x = -1, y = 0,  z = 0},
	{x = 0,  y = -1, z = 0},
	{x = 1,  y = -1, z = 0},
	{x = -1, y = -1, z = 0}
}

local function dig_it_dir(pos, player)
	local dir = player:get_look_dir()
	-- Rounded_dir has only one non-zero component
	local rounded_dir = minetest.facedir_to_dir(minetest.dir_to_facedir(dir, true))
	local rot = vector.dir_to_rotation(rounded_dir)

	for _, v in ipairs(dig_offsets) do
		local offset = vector.rotate(v, rot)
		dig_it(vector.add(pos, offset), player)
	end
end

minetest.register_tool("rythium:huge_pick", {
	description = S("3*3 Pick"),
	inventory_image = "rythium_huge_pick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=3.5, [2]=2.5, [3]=1.5}, uses=800, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {pickaxe = 1}
})

minetest.register_on_dignode(
	function(pos, oldnode, digger)
		if not pick_cb_enabled then return end
		if not digger or not digger:is_player() then return end

		if digger:get_wielded_item():get_name() == "rythium:huge_pick" then
			pick_cb_enabled = false
			dig_it_dir(pos, digger)
			pick_cb_enabled = true
		end
	end
)

--
-- Night vision headlamp
--

local rythium_light_users = {}

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	rythium_light_users[name] = nil
end)

minetest.register_node("rythium:light", {
	description = "light source",
	light_source = 12,
	paramtype = "light",
	walkable = false,
	drawtype = "airlike",
	pointable = false,
	buildable_to = true,
	sunlight_propagates = true,
	groups = {not_in_creative_inventory = 1},
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(2)
	end,
	on_timer = function(pos, elapsed)
		minetest.set_node(pos, {name="air"})
	end,
})


minetest.register_tool("rythium:headlamp_controller", {
	description = S("Headlamp Controller"),
	inventory_image = "rythium_headlamp_controller.png",
	on_use = function(itemstack, user, pointed_thing)
		local _, inv = armor:get_valid_player(user)
		if inv:contains_item("armor", "rythium:headlamp") then
			rythium_light_users[user:get_player_name()] = {player = user, inside = 0}
		end
	end,
	on_place = function(itemstack, user, pointed_thing)
		rythium_light_users[user:get_player_name()] = nil
	end,
	on_secondary_use = function(itemstack, user, pointed_thing)
		rythium_light_users[user:get_player_name()] = nil
	end,
	sound = {breaks = "default_tool_breaks"},
})

armor:register_armor("rythium:headlamp", {
	description = S("Headlamp"),
	inventory_image = "rythium_inv_headlamp.png",
	groups = {armor_head=1, armor_heal=0, armor_use=10},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=1, snappy=1, level=1},
	on_unequip = function(player, index, stack)
		rythium_light_users[player:get_player_name()] = nil
	end,
})

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > 1 then
		timer = 0
		for name, ob in pairs(rythium_light_users) do
			local pos = ob.player:get_pos()
			pos.y = pos.y + 1.5
			local n = minetest.get_node(pos).name
			local light = minetest.get_node_light(pos)
			if not light then
				rythium_light_users[name] = nil
				return
			end
			if ob.inside > 10 or minetest.get_node_light(pos) > 12 then
				rythium_light_users[name] = nil
			elseif n == "air" then
				minetest.set_node(pos, {name = "rythium:light"})
			elseif n == "rythium:light" then
				minetest.get_node_timer(pos):start(2)
			else
				ob.inside = ob.inside + 1
			end
		end
	end
end)

