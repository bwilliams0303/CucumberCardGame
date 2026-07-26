local State = require("states.base.State")
local Deck = require("entities.Deck")
local push = require("lib.push")

local Gameplay = State:extend()

function Gameplay:new()
	Gameplay.super.new(self, "Gameplay", love.graphics.newImage("assets/GreenFeltBackground.png"))
end

function Gameplay:load()
	local gameWidth, gameHeight = push:getWidth(), push:getHeight()
	self.deck = Deck("red", gameWidth / 2, gameHeight / 2, 150)
end

function Gameplay:update(dt)
end

function Gameplay:draw()
	self.deck:drawDeck()
end

function Gameplay:mousepressed(x, y, button, presses)
	self.deck:mousepressed(x, y, button, presses)
end

function Gameplay:mousemoved(x, y, dx, dy)
	self.deck:mousemoved(x, y, dx, dy)
end

function Gameplay:mousereleased(x, y, button)
	self.deck:mousereleased(x, y, button)
end

return Gameplay
