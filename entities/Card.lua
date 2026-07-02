local Object = require("lib.classic")

local Card = Object:extend()

function Card:new(number, suit, color)
	self.number = number
	self.suit = suit
	if number == 11 then
		self.front = love.graphics.newImage("assets/cards/PNG/CardsLarge/card_" .. suit .. "_J.png")
	elseif number == 12 then
		self.front = love.graphics.newImage("assets/cards/PNG/CardsLarge/card_" .. suit .. "_Q.png")
	elseif number == 13 then
		self.front = love.graphics.newImage("assets/cards/PNG/CardsLarge/card_" .. suit .. "_K.png")
	elseif number == 1 then
		self.front = love.graphics.newImage("assets/cards/PNG/CardsLarge/card_" .. suit .. "_A.png")
	else
		self.front = love.graphics.newImage("assets/cards/PNG/CardsLarge/card_" .. suit .. "_" .. number .. ".png")
	end
	self.back = love.graphics.newImage("assets/cards/PNG/CardsBack/cardBack_" .. color .. "4.png")

end

function Card:draw(x, y, scale)
	love.graphics.draw(self.front, x, y, 0, scale / self.front:getWidth(), scale / self.front:getHeight())
end

return Card