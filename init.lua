local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

local S = minetest.get_translator(modname)

mob_automata = {
	modname = modname,
	modpath = modpath,
	mod_storage = minetest.get_mod_storage(),
	S = S,

	has = {
	},

	log = function(level, messagefmt, ...)
		return minetest.log(level, ("[%s] %s"):format(modname, messagefmt:format(...)))
	end,

	dofile = function(...)
		return dofile(table.concat({modpath, ...}, DIR_DELIM) .. ".lua")
	end,
}

cottages.dofile("settings")
cottages.dofile("util")
cottages.dofile("api", "init")


self.mod_storage = nil
