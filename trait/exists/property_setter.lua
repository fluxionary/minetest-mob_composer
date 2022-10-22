local PropertySetter = mob_composer.Trait()

function PropertySetter:_init(properties)
	for i = 1, #properties do
		local prop = properties[i]
		local value = self[prop]
		if value ~= nil then
			self:set_property(prop, value)
		end
	end
end

mob_composer.trait.PropertySetter = PropertySetter
