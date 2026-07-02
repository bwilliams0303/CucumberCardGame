local Object = require("lib.classic")

local State = Object:extend()

function State:new(name, background)
	self.name = name
	self.background = background
end

return State
