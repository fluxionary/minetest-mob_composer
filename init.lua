local f = string.format

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

local S = minetest.get_translator(modname)

mob_composer = {
	modname = modname,
	modpath = modpath,
	mod_storage = minetest.get_mod_storage(),
	S = S,

	has = {
	},

	log = function(level, messagefmt, ...)
		return minetest.log(level, f("[%s] %s", modname, f(messagefmt, ...)))
	end,

	dofile = function(...)
		return dofile(table.concat({modpath, ...}, DIR_DELIM) .. ".lua")
	end,
}

mob_composer.dofile("settings")
mob_composer.dofile("api", "init")

mob_composer.mod_storage = nil
