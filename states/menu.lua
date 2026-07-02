local State = require("states.State")
local Button = require("ui.button")
local assets = require("assets")
local push = require("lib.push")

local Menu = State:extend()

function Menu:new()
	Menu.super.new(self, "Menu")
end

function Menu:load()
	local gameWidth, gameHeight = push:getWidth(), push:getHeight()

	self.title = assets.images.title
	local titleWidth = gameWidth * 0.5
	self.titleScale = titleWidth / self.title:getWidth()
	self.titleX = (gameWidth - titleWidth) / 2
	self.titleY = gameHeight * 0.1

	local buttonScale = 1.5
	local buttonImage = assets.images.startButton
	local buttonWidth = buttonImage:getWidth() * buttonScale
	local buttonX = (gameWidth - buttonWidth) / 2
	local buttonY = gameHeight * 0.65

	self.startButton = Button(buttonX, buttonY, buttonImage, buttonScale, "START", function()
		require("statemanager").switch("Gameplay")
	end)
end

function Menu:update(dt)
end

function Menu:draw()
	local gameWidth, gameHeight = push:getWidth(), push:getHeight()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
	love.graphics.draw(self.title, self.titleX, self.titleY, 0, self.titleScale, self.titleScale)
	self.startButton:draw()
end

function Menu:mousepressed(x, y, button)
	self.startButton:mousepressed(x, y, button)
end

function Menu:mousemoved(x, y, dx, dy)
	self.startButton:mousemoved(x, y)
end

return Menu
