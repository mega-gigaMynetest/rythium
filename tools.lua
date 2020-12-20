-- support for MT game translation.
local S = minetest.get_translator(rythium)

--
-- Wands
--

-- Retrieving mod settings
-- https://dev.minetest.net/Settings (beware of the bug !)
local wands_max_use
wands_max_use = minetest.settings:get("rythium.wands_max_use") or 20
local wands_wear = 65535/(wands_max_use-1)

-- Healing wand
minetest.register_tool("rythium:healing_wand", {
	description = S("Healing wand"),
	inventory_image = "rythium_healing_wand.png",
	on_use = function(itemstack, user, pointed_thing)
		minetest.sound_play("rythium_healing", {gain = 0.5})
		-- pointed_thing is a table and this table contains a ref variable,
		-- i.e. another table which represents the pointed object itself.
		-- difference is tested with ~= not with != as in other languages
		if (pointed_thing.ref~=nil and pointed_thing.ref:is_player())
		then
			pointed_thing.ref:set_hp(20)
		else
			user:set_hp(20)
		end
		-- Wand wear management
		-- user is a table representing a player is_creative_enabled needs only the name
		if not minetest.is_creative_enabled(user:get_player_name()) then
			itemstack:add_wear(wands_wear)
			if itemstack:get_count() == 0 then
				minetest.sound_play("default_tool_breaks", {gain = 1})
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
	if minetest.is_protected(pos, player:get_player_name()) then
		minetest.record_protection_violation(pos, player:get_player_name())
		return
	end
	local node = minetest.get_node(pos)
	local name = node.name
	local groupcracky = minetest.get_item_group(name, "cracky")
	if name == "air" or node.name == "ignore" then return end
	if name == "default:lava_source" then return end
	if name == "default:lava_flowing" then return end
	if name == "default:water_source" then minetest.remove_node(pos) return end
	if name == "default:water_flowing" then minetest.remove_node(pos) return end
	local def = minetest.registered_nodes[node.name]
	if not def then return end
	if groupcracky == 0 then return end

	minetest.registered_nodes[name].on_dig(pos, node, player)
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
			cracky = {times={[1]=3.5, [2]=2.5, [3]=1.5}, uses=200, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {pickaxe = 1}
})

minetest.register_on_dignode(
	function(pos, oldnode, digger)
		if not pick_cb_enabled then return end
		pick_cb_enabled = false

		if not digger:is_player() then return end
		if digger:get_wielded_item():get_name() == "rythium:huge_pick" then
			dig_it_dir(pos, digger)
		end

		pick_cb_enabled = true
	end
)
