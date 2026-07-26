local Menu = require("states.base.Menu")
local Button = require("ui.button")
local assets = require("core.assets")
local push = require("lib.push")

local Splash = Menu:extend()

function Splash:new()
	Splash.super.new(self, "Splash")
end

function Splash:load()
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

	self:addButton(Button(buttonX, buttonY, buttonImage, buttonScale, "START", function()
		require("core.statemanager").switch("Gameplay")
	end))
end

function Splash:draw()
	local gameWidth, gameHeight = push:getWidth(), push:getHeight()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
	love.graphics.draw(self.title, self.titleX, self.titleY, 0, self.titleScale, self.titleScale)

	Splash.super.draw(self)
end

return Splash
