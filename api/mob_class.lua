local f = string.format

local deserialize = minetest.deserialize
local serialize = minetest.serialize

local class = futil.class
local identity = futil.functional.identity
local is_property_key = futil.is_property_key
local is_valid_property_value = futil.is_valid_property_value

local PairingHeap = futil.PairingHeap

local api = mob_composer.api
local log = mob_composer.log

api.entity_by_mob_id = {}

local Mob = class()

Mob.initial_properties = {
	hp_max = 1,
	physical = false,
	collide_with_objects = false,
	collisionbox = { 0, 0, 0, 0, 0, 0 },
	selectionbox = { 0, 0, 0, 0, 0, 0 },
	pointable = false,
	visual = "sprite",
	visual_size = { x = 0, y = 0, z = 0 },
	textures = { "blank.png" },
	use_texture_alpha = true,
	is_visible = false,
	makes_footstep_sound = false,
	automatic_face_movement_dir = false,
	static_save = false,
}

function Mob:_init(id)
	if not self.object then
		error("not an entity")
	end

	id = tonumber(id)

	if not id then
		error("no id")
	end

	self._id = id
end

function Mob:get_staticdata()
	local object = self.object
	return serialize({
		self._id,
		object:get_properties(),
		object:get_armor_groups(),
		object:get_nametag_attributes(),
		self:get_attributes(),
	})
end

function Mob:on_activate(staticdata, dtime_s)
	local object = self.object

	if not object then
		log("warning", "attempt to initialize mob of type %q w/out an object", self.name or "nil")
		return
	end

	local id, properties, armor_groups, nametag_attributes, attributes = unpack(deserialize(staticdata))

	if not id then
		error(f("attempt to initialize mob of type %q w/out an id", self.name or "nil"))
	elseif api.entity_by_mob_id[id] then
		self.is_duplicate = true
		error(f("mob created w/ already existing ID? will be removed. %i %s", id, dump(self)))
	end

	api.entity_by_mob_id[id] = self

	--
	self.attributes = attributes or {}

	if not properties then
		self._initializing = true
	end

	if properties then
		object:set_properties(properties)
	end

	if armor_groups then
		object:set_armor_groups(armor_groups)
	end

	if nametag_attributes then
		object:set_nametag_attributes(nametag_attributes)
	end

	self._on_deactivates = {}
	self._on_steps = {}
	self._on_punches = {}
	self._on_deaths = {}
	self._on_rightclicks = {}
	self._on_attach_childs = {}
	self._on_detach_childs = {}
	self._on_detaches = {}

	self.action_queue = PairingHeap()

	self.state = "stand"
	self.state_queue = PairingHeap()
	self.state_queue:set_priority("stand", 0)

	local traits = getmetatable(self)._parents

	for i = 1, #traits do
		local trait = traits[i]
		if trait._init then
			if i == 1 then
				-- note: traits[1] == Mob
				trait._init(self, id)
			else
				-- traits are responsible for registering and initializing their own attributes
				error("TODO: serialized_attributes doesn't exist")
				--trait._init(self, serialized_attributes, dtime_s)
			end
		end
	end

	self._initializing = false
end

function Mob:on_deactivate(removal)
	local callbacks = self._on_deactivates
	for i = 1, #callbacks do
		callbacks[i](self, removal)
	end

	api.entity_by_mob_id[self._id] = nil
	if removal and not self.is_duplicate then
		-- wipe backed-up properties
		futil.functional.noop()
	end
end

function Mob:register_on_deactivate(callback)
	table.insert(self._on_deactivates, callback)
end

function Mob:on_step(dtime, moveresult)
	local action_queue = self.action_queue

	if action_queue:size() > 0 then
		action_queue:pop()(dtime)
	end

	local state_queue = self.state_queue

	if state_queue:size() == 0 then
		self.state = "stand"
		state_queue:set_priority("stand", 0)
	else
		self.state = state_queue:peek()
	end

	local callbacks = self._on_steps
	for i = 1, #callbacks do
		callbacks[i](self, dtime, moveresult)
	end
end

function Mob:register_on_step(callback)
	table.insert(self._on_step, callback)
end

function Mob:on_punch(puncher, time_from_last_punch, tool_capabilities, dir, damage)
	local callbacks = self._on_punches
	for i = 1, #callbacks do
		callbacks[i](self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
	end
end

function Mob:register_on_punch(callback)
	table.insert(self._on_punches, callback)
end

function Mob:on_death(killer)
	local callbacks = self._on_deaths
	for i = 1, #callbacks do
		callbacks[i](self, killer)
	end
end

function Mob:register_on_death(callback)
	table.insert(self._on_deaths, callback)
end

function Mob:on_rightclick(clicker)
	local callbacks = self._on_rightclicks
	for i = 1, #callbacks do
		callbacks[i](self, clicker)
	end
end

function Mob:register_on_rightclick(callback)
	table.insert(self._on_rightclicks, callback)
end

function Mob:on_attach_child(child)
	local callbacks = self._on_attach_childs
	for i = 1, #callbacks do
		callbacks[i](self, child)
	end
end

function Mob:register_on_attach_child(callback)
	table.insert(self._on_attach_childs, callback)
end

function Mob:on_detach_child(child)
	local callbacks = self._on_detach_childs
	for i = 1, #callbacks do
		callbacks[i](self, child)
	end
end

function Mob:register_on_detach_child(callback)
	table.insert(self._on_detach_childs, callback)
end

function Mob:on_detach(parent)
	local callbacks = self._on_detaches
	for i = 1, #callbacks do
		callbacks[i](self, parent)
	end
end

function Mob:register_on_detach(callback)
	table.insert(self._on_detaches, callback)
end

function Mob:register_attribute(key, initializer, serializer)
	local attributes = self.attributes

	if attributes[key] then
		error(f("[properties] attempt to re-register key %q", key))
	end

	attributes[key] = {
		initializer = initializer or identity,
		serializer = serializer or identity,
	}
end

function Mob:has_attribute(key)
	return self.attributes[key] ~= nil
end

-- traits are "allowed" to read/write their own attributes via self.key directly.
-- or if they want to store an ephemeral attribute like a "target" object
-- however, they should use get_attribute/set_attribute if they want to modify someone else's traits
function Mob:get_attribute(key)
	local def = self.attributes[key]
	if not def then
		error(("attempt to get unknown attribute %q of mob %s"):format(key, dump(self)))
	end
	return self[key]
end

function Mob:set_attribute(key, value)
	local def = self.attributes[key]
	if not def then
		error(("attempt to get unknown attribute %q of mob %s"):format(key, dump(self)))
	end
	self[key] = value
end

function Mob:get_attributes()
	local attributes = {}

	for key, funcs in pairs(self.attributes) do
		attributes[key] = funcs.serializer(self[key])
	end

	return attributes
end

function Mob:get_property(key)
	if not is_property_key(key) then
		error(f("unknown property %s", key))
	end

	local o = self.object
	if not o then
		return
	end

	local properties = o:get_properties()
	if not properties then
		return
	end

	return properties[key]
end

function Mob:set_property(key, value)
	if not is_property_key(key) then
		error(f("unknown property %s", key))
	elseif not is_valid_property_value(key, value) then
		error(f("invalid property value %s = %s", key, dump(value)))
	end

	local o = self.object
	if not o and o.set_properties then
		return
	end

	o:set_properties({ [key] = value })
end

api.Mob = Mob
