local StateManager = {}

local states = {}
local current = nil

function StateManager.add(name, state)
	states[name] = state
end

function StateManager.switch(name, ...)
	if states[name] then
		current = states[name]
		if current.load then current:load(...) end
	end
end

function StateManager.update(dt)
	if current and current.update then current:update(dt) end
end

function StateManager.draw()
	if current and current.draw then current:draw() end
end

function StateManager.keypressed(key)
	if current and current.keypressed then current:keypressed(key) end
end

function StateManager.mousepressed(x, y, button)
	if current and current.mousepressed then current:mousepressed(x, y, button) end
end

function StateManager.mousemoved(x, y, dx, dy)
	if current and current.mousemoved then current:mousemoved(x, y, dx, dy) end
end

return StateManager
