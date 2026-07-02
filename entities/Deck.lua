local Object = require("lib.classic")
local Card = require("entities.Card")

local Deck = Object:extend()

function Deck:new(color)
	local seed = os.time() + string.byte("username", 1, #("username"))
	math.randomseed(seed)

	self.cards = {}
	for _, suit in ipairs({"hearts", "diamonds", "clubs", "spades"}) do
		for number = 1, 13 do
			table.insert(self.cards, Card(number, suit, color))
		end
	end
	self:shuffle()
end

function Deck:shuffle()
	for i = #self.cards, 2, -1 do
		local j = math.random(i)
		self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
	end
end

function Deck:drawDeck()
	local cardSpace = 0
	for _, drawnCard in ipairs(self.cards) do
		drawnCard:draw(cardSpace, 100, 150)
		cardSpace = cardSpace + 100
	end
end

return Deck