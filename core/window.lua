local push = require("lib.push")

local window = {}

local GAME_WIDTH, GAME_HEIGHT = 1080, 720 -- fixed virtual game resolution

function window.setup()
	love.graphics.setDefaultFilter("nearest", "nearest") -- crisp pixel art, no smoothing on scale

	local desktopWidth, desktopHeight = love.window.getDesktopDimensions()

	if love.system.getOS() == "iOS" or love.system.getOS() == "Android" then
		push:setupScreen(GAME_WIDTH, GAME_HEIGHT, desktopWidth, desktopHeight, { fullscreen = true, resizable = false })
	else
		-- start fullscreen at the monitor's actual resolution -- push scales
		-- the fixed 1080x720 virtual canvas to fit proportionally
		-- (letterboxed, never stretched) no matter the real aspect ratio.
		-- resizable so toggling out of fullscreen (F11, see
		-- core/controls.lua) leaves an ordinary, freely resizable window;
		-- push:resize() (wired to love.resize in main.lua) keeps the
		-- letterboxing correct if/when that window gets resized too.
		push:setupScreen(GAME_WIDTH, GAME_HEIGHT, desktopWidth, desktopHeight, { fullscreen = true, resizable = true })
	end
end

function window.resize(w, h)
	push:resize(w, h)
end

function window.toggleFullscreen()
	push:switchFullscreen()
end

return window
