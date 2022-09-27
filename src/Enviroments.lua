local Enviroments = {}

return {
	add = function(script, tree)
		if not Enviroments[script] then
			Enviroments[script] = {}
		end
		Enviroments[script][tree] = tree
	end,
	remove = function(script, tree)
		if not Enviroments[script] then
			return
		end
		Enviroments[script][tree] = nil
	end,
	get = function()
		return Enviroments
	end, 
}
