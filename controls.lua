local push = require("lib.push")
local StateManager = require("statemanager")

local controls = {}

function controls.keypressed(key)
	StateManager.keypressed(key)
end

function controls.mousepressed(x, y, button)
	local gx, gy = push:toGame(x, y)
	if gx and gy then
		StateManager.mousepressed(gx, gy, button)
	end
end

function controls.mousemoved(x, y, dx, dy)
	local gx, gy = push:toGame(x, y)
	if gx and gy then
		StateManager.mousemoved(gx, gy, dx, dy)
	end
end

return controls
