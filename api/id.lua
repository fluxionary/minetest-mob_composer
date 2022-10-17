local api = mob_composer.api
local mod_storage = mob_composer.mod_storage

local updated = false
local id = mod_storage:get_int("id")

function api.generate_next_id()
	if id >= 4503599627370496 then
		-- if you create 100 entity per default server step (0.09s),
		-- it will take ~2.57 myriads to run out.
		-- you will likely have other problems before then.
		error("too many entities")
	end
	id = id + 1
	updated = true
	return id
end

function api.get_current_id()
	return id
end

minetest.register_globalstep(function()
	if updated then
		mod_storage:set_int("id", id)
		updated = false
	end
end)

minetest.register_on_shutdown(function()
	mod_storage:set_int("id", id)
end)
