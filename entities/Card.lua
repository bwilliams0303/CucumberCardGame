local Object = require("lib.classic")

local Card = Object:extend()

function Card:new(number, suit, color, scale)
	self.number = number
	self.suit = suit
	self.faceUp = false
	self.x, self.y = 0, 0

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

	self.width = scale
	self.height = self.front:getHeight() * (scale / self.front:getWidth())
end

-- The front art is centered inside its canvas with padding baked into the
-- source image (measured directly on the pixels: content occupies ~65.6%
-- of the canvas width and ~93.75% of its height). The back art fills its
-- own canvas edge-to-edge with no padding, so drawn at self.width/height it
-- reads as noticeably bigger than the front -- shrink and center it to the
-- same effective size the front already renders at.
local BACK_WIDTH_FRACTION = 42 / 64
local BACK_HEIGHT_FRACTION = 60 / 64

function Card:moveTo(x, y)
	self.x, self.y = x, y
end

function Card:containsPoint(px, py)
	return px >= self.x and px <= self.x + self.width
	   and py >= self.y and py <= self.y + self.height
end

function Card:flip()
	self.faceUp = not self.faceUp
end

function Card:draw()
	if self.faceUp then
		love.graphics.draw(self.front, self.x, self.y, 0, self.width / self.front:getWidth(), self.height / self.front:getHeight())
	else
		local backWidth = self.width * BACK_WIDTH_FRACTION
		local backHeight = self.height * BACK_HEIGHT_FRACTION
		local offsetX = (self.width - backWidth) / 2
		local offsetY = (self.height - backHeight) / 2
		love.graphics.draw(self.back, self.x + offsetX, self.y + offsetY, 0, backWidth / self.back:getWidth(), backHeight / self.back:getHeight())
	end
end

return Card
