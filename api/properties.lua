local api = mob_composer.api
local class = mob_composer.util.class
local mod_storage = mob_composer.mod_storage

local object_properties = {
	hp_max = true,
	breath_max = true,
	zoom_fov = true,
	eye_height = true,
	physical = true,
	collide_with_objects = true,
	collisionbox = true,
	selectionbox = true,
	pointable = true,
	visual = true,
	visual_size = true,
	mesh = true,
	textures = true,
	colors = true,
	use_texture_alpha = true,
	spritediv = true,
	initial_sprite_basepos = true,
	is_visible = true,
	makes_footstep_sound = true,
	automatic_rotate = true,
	stepheight = true,
	automatic_face_movement_dir = true,
	automatic_face_movement_max_rotation_per_sec = true,
	backface_culling = true,
	glow = true,
	nametag = true,
	nametag_color = true,
	nametag_bgcolor = true,
	infotext = true,
	static_save = true,
	damage_texture_modifier = true,
	shaded = true,
	show_on_minimap = true,
}

local properties_class = class()

function properties_class:_init(object)
	self._object = object
	self._id = object:get_luaentity()._id
end

function properties_class:contains(key)
	if self[key] ~= nil then
		return true
	end

	local value
	if object_properties[key] then
		local properties = self._object:get_properties()
		value = properties[key]

	else
		key = ("%i.%s"):format(self._id, key)
		value = mod_storage:get(key)
	end

	self[key] = value
	return value ~= nil
end

function properties_class:get(key)
	local v = self[key]
	if v ~= nil then
		return v
	end

	if object_properties[key] then
		local properties = self._object:get_properties()
		return properties[key]

	else
		key = ("%i.%s"):format(self._id, key)
		return mod_storage:get(key)
	end
end

function properties_class:get_string(key)
	local v = self[key]
	if v ~= nil then
		return v
	end

	if object_properties[key] then
		local properties = self._object:get_properties()
		return tostring(properties[key])

	else
		key = ("%i.%s"):format(self._id, key)
		return mod_storage:get_string(key)
	end
end

function properties_class:get_int(key)
	local v = self[key]
	if v ~= nil then
		return v
	end

	if object_properties[key] then
		local properties = self._object:get_properties()
		return math.floor(tonumber(properties[key]))

	else
		key = ("%i.%s"):format(self._id, key)
		return mod_storage:get_int(key)
	end
end

function properties_class:get_float(key)
	local v = self[key]
	if v ~= nil then
		return v
	end

	if object_properties[key] then
		local properties = self._object:get_properties()
		return tonumber(properties[key])

	else
		key = ("%i.%s"):format(self.__id, key)
		return mod_storage:get_float(key)
	end
end

function properties_class:set_string(key, value)
	value = tostring(value)
	if object_properties[key] then
		local properties = self._object:get_properties()
		properties[key] = value
		self._object:set_properties(properties)

	else
		mod_storage:set_string(("%i.%s"):format(self._id, key), value)
	end

	self[key] = value
end

function properties_class:set_int(key, value)
	if object_properties[key] then
		local properties = self._object:get_properties()
		properties[key] = math.floor(tonumber(value))
		self._object:set_properties(properties)

	else
		key = ("%i.%s"):format(self._id, key)
		return mod_storage:set_int(key, value)
	end
end

function properties_class:set_float(key, value)
	if object_properties[key] then
		local properties = self._object:get_properties()
		properties[key] = tonumber(value)
		self._object:set_properties(properties)

	else
		key = ("%i.%s"):format(self._id, key)
		return mod_storage:set_float(key, value)
	end
end

api.properties_class = properties_class
