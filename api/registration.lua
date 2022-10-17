local class = futil.class

local api = mob_composer.api

function api.register_mob(name, ...)
	minetest.register_entity(name, class(api.Mob, ...))
end
