local api = mob_composer
local mod_storage = mob_composer.mod_storage

local id = mod_storage:get_int("id")

function api.generate_next_id()
	if id >= 4503599627370496 then
		-- TODO maybe at this point return strings?
		-- if you create 1 entity per default server step (0.018s), it will take ~2.57 million years to run out
		-- and you will likely have other problems before then
		error("too many entities")
	end
	id = id + 1
	mod_storage:set_int("id", id)
	return id
end

function api.get_current_id()
	return id
end
