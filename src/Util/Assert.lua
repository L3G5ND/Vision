return function(condition, message, level)
	if not condition then
		error("[Vision] - " .. message, level or 3)
	end
end
