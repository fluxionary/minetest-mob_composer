local api = mob_composer.api

local class = mob_composer.util.class

local properties_class = api.properties_class

local mob_class = class(properties_class)

function mob_class:_init(object)
	self._object = object

	local luaentity = object:get_luaentity()
	if not luaentity then
		error("object is not currently loaded")
	end

	self._luaentity = luaentity

	local id = luaentity._id
	if not id then
		id = api.generate_next_id()
		self._id = id
		luaentity._id = id

	else
		self._id = id
	end

	properties_class._init(self, object)
end

function mob_class:get_entity_definition(overrides)
	error("todo")
end

function mob_class:register_mob(name, overrides)
	minetest.register_entity(name, self:get_entity_definition(overrides))
end

api.mob_base = mob_class
