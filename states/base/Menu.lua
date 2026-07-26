local State = require("states.base.State")

-- Base class for menu-style states (splash, pause, etc). Subclasses draw
-- their own content and call self:addButton(...) in load(); Menu handles
-- drawing and click/hover routing for whatever buttons they register.
local Menu = State:extend()

function Menu:new(name, background)
	Menu.super.new(self, name, background)
	self.buttons = {}
end

function Menu:addButton(button)
	table.insert(self.buttons, button)
end

function Menu:load()
end

function Menu:update(dt)
end

function Menu:draw()
	for _, button in ipairs(self.buttons) do
		button:draw()
	end
end

function Menu:mousepressed(x, y, button)
	for _, b in ipairs(self.buttons) do
		b:mousepressed(x, y, button)
	end
end

function Menu:mousemoved(x, y, dx, dy)
	for _, b in ipairs(self.buttons) do
		b:mousemoved(x, y)
	end
end

return Menu
