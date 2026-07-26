local Object = require("lib.classic")
local Card = require("entities.Card")

local Deck = Object:extend()

function Deck:new(color, centerX, centerY, scale)
	local seed = os.time() + string.byte("username", 1, #("username"))
	math.randomseed(seed)

	self.dragging = nil
	self.dragOffsetX, self.dragOffsetY = 0, 0

	self.cards = {}
	for _, suit in ipairs({"hearts", "diamonds", "clubs", "spades"}) do
		for number = 1, 13 do
			table.insert(self.cards, Card(number, suit, color, scale))
		end
	end
	self:shuffle()

	local pileX = centerX - self.cards[1].width / 2
	local pileY = centerY - self.cards[1].height / 2
	for _, card in ipairs(self.cards) do
		card:moveTo(pileX, pileY)
	end
end

function Deck:shuffle()
	for i = #self.cards, 2, -1 do
		local j = math.random(i)
		self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
	end
end

-- Topmost card (drawn last) under the given point, searched top-down.
function Deck:cardAt(x, y)
	for i = #self.cards, 1, -1 do
		local card = self.cards[i]
		if card:containsPoint(x, y) then
			return card, i
		end
	end
	return nil
end

function Deck:drawDeck()
	for _, card in ipairs(self.cards) do
		card:draw()
	end
end

function Deck:mousepressed(x, y, button, presses)
	if button ~= 1 then return end

	local card, index = self:cardAt(x, y)
	if not card then return end

	if presses and presses >= 2 then
		card:flip()
		self.dragging = nil
		return
	end

	-- bring the grabbed card to the top of the draw/z-order, then start dragging it
	table.remove(self.cards, index)
	table.insert(self.cards, card)

	self.dragging = card
	self.dragOffsetX = card.x - x
	self.dragOffsetY = card.y - y
end

function Deck:mousemoved(x, y, dx, dy)
	if self.dragging then
		self.dragging:moveTo(x + self.dragOffsetX, y + self.dragOffsetY)
	end
end

function Deck:mousereleased(x, y, button)
	if button == 1 then
		self.dragging = nil
	end
end

return Deck
