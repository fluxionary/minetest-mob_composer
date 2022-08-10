local util = {}

function util.class(...)
    local class = {}
	class.__index = class

	local parents = {...}
	if #parents > 0 then
		setmetatable(class, {__index = function(self, key)
			for i = #parents, 1, -1 do
				local v = parents[i][key]
				if v then
					return v
				end
			end
		end})
	end

    function class:__call(...)
        local obj = setmetatable({}, class)
        if obj._new then
            obj:_new(...)
        end
        return obj
    end

	function class:is_a(class2)
		if class == class2 then
			return true
		end

		for _, parent in ipairs(parents) do
			if parent:is_a(class2) then
				return true
			end
		end

		return false
	end

    return class
end

mob_automata.util = util
