--[[
defines how a mob appears. controls animation states.
]]

local PropertySetter = mob_composer.trait.PropertySetter
local Appears = mob_composer.Trait(PropertySetter)

function Appears:_init(serialized_attributes, dtime_s)
	if self._initializing then
		PropertySetter.init(self, {
			"automatic_face_movement_dir",
			"automatic_face_movement_max_rotation_per_sec",
			"automatic_rotate",
			"backface_culling",
			"colors",
			"damage_texture_modifier",
			"glow",
			"initial_sprite_basepos",
			"is_visible",
			"mesh",
			"shaded",
			"spritediv",
			"textures",
			"use_texture_alpha",
			"visual",
			"visual_size",
		})
	end
end

mob_composer.trait.Appears = Appears
