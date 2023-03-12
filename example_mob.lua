-- luacheck: ignore

-- TODO: this is mostly so i can work out now i want things to work

local api = mob_composer.api

local trait = mob_composer.trait

local Lizard = api.register_mob(
	"composed_mob:lizard",
	trait.Appears({
		default = {
			drawtype = "mesh",
			model = "composed_mob_lizard.b3d",
		},
		variants = {
			purple = {
				textures = { "composed_mob_lizard_purple.png" },
			},
			red = {
				textures = { "composed_mob_lizard_red.png" },
			},
		},
	}),
	trait.Spawns({
		{
			strategy = "ABM",
			nodenames = { "group:soil" },
			interval = 61.3,
			chance = 1000,
		},
	}),
	trait.Sees({
		range = 3,
		min_light = 5,
	}),
	trait.Hears({
		range = 12,
	}),
	trait.Fears_objects({
		what = {
			player = 10,
		},
	}),
	trait.Flees({
		when = { "afraid" },
		speed = 5,
	})
)

local lizard = Lizard(pos) -- create a new lizard?

local Balrog = api.register_mob(
	"composed_mob:balrog",
	trait.Appears({
		drawtype = "mesh",
		model = "composed_mob_balrog.b3d",
		textures = { "composed_mob_balrog.png" },
	}),
	trait.Spawns({
		{
			strategy = "ABM",
			nodenames = { "group:stone" },
			interval = 61.3,
			chance = 1000,
			max_y = -18000,
		},
	}),
	trait.Sees({
		range = 40,
		min_light = 1,
	}),
	trait.Hears({
		range = 40,
	}),
	trait.Extrasenses({
		range = 10,
	})
)
