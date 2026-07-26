local push = require("lib.push")
local StateManager = require("core.statemanager")

local controls = {}

function controls.keypressed(key)
	StateManager.keypressed(key)
end

function controls.mousepressed(x, y, button, presses)
	local gx, gy = push:toGame(x, y)
	if gx and gy then
		StateManager.mousepressed(gx, gy, button, presses)
	end
end

function controls.mousemoved(x, y, dx, dy)
	local gx, gy = push:toGame(x, y)
	if gx and gy then
		StateManager.mousemoved(gx, gy, dx, dy)
	end
end

function controls.mousereleased(x, y, button)
	-- always forward, even if the release lands in push's letterboxed
	-- border (toGame returns nil there) -- otherwise a drag started inside
	-- the canvas could never be released and would stick to the cursor.
	local gx, gy = push:toGame(x, y)
	StateManager.mousereleased(gx, gy, button)
end

return controls
