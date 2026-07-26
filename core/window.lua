local push = require("lib.push")

local window = {}

local GAME_WIDTH, GAME_HEIGHT = 1080, 720 -- fixed virtual game resolution

function window.setup()
	love.graphics.setDefaultFilter("nearest", "nearest") -- crisp pixel art, no smoothing on scale

	local desktopWidth, desktopHeight = love.window.getDesktopDimensions()

	if love.system.getOS() == "iOS" or love.system.getOS() == "Android" then
		push:setupScreen(GAME_WIDTH, GAME_HEIGHT, desktopWidth, desktopHeight, { fullscreen = true, resizable = false })
	else
		push:setupScreen(GAME_WIDTH, GAME_HEIGHT, desktopWidth, desktopHeight, { fullscreen = false })
	end
end

return window
