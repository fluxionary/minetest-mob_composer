local api = mob_composer.api

local class = futil.class

local properties_class = api.properties_class

local Mob = class(properties_class)

function Mob:_init(object)
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

function Mob:get_entity_definition(overrides)
	error("todo")
end

function Mob:register_mob(name, overrides)
	minetest.register_entity(name, self:get_entity_definition(overrides))
end

api.Mob = Mob
