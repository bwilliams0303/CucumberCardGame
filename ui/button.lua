local Object = require("lib.classic")

local Button = Object:extend()

function Button:new(x, y, image, scale, label, onClick)
	self.x, self.y = x, y
	self.image = image
	self.scale = scale or 1
	self.label = label
	self.onClick = onClick
	self.hovered = false
	self.width = image:getWidth() * self.scale
	self.height = image:getHeight() * self.scale
end

function Button:isHovered(mx, my)
	return mx >= self.x and mx <= self.x + self.width
	   and my >= self.y and my <= self.y + self.height
end

function Button:mousemoved(mx, my)
	self.hovered = self:isHovered(mx, my)
end

function Button:mousepressed(mx, my, btn)
	if btn == 1 and self:isHovered(mx, my) then
		self.onClick()
	end
end

function Button:draw()
	love.graphics.setColor(1, 1, 1, self.hovered and 0.85 or 1)
	love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
	love.graphics.setColor(1, 1, 1, 1)

	if self.label then
		love.graphics.printf(self.label, self.x, self.y + self.height / 2 - 8, self.width, "center")
	end
end

return Button
