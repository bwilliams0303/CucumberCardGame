local State = require("states.State")
local Deck = require("entities.Deck")

local Gameplay = State:extend()

function Gameplay:new()
	Gameplay.super.new(self, "Gameplay", love.graphics.newImage("assets/GreenFeltBackground.png"))
end

function Gameplay:load()
	self.deck = Deck("red")
end

function Gameplay:update(dt)
end

function Gameplay:draw()
	self.deck:drawDeck()
end

return Gameplay
