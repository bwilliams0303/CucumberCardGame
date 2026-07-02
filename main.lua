if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local push = require("lib.push")
local StateManager = require("statemanager")
local assets = require("assets")
local Menu = require("states.menu")
local Gameplay = require("states.gameplay")

local gameWidth, gameHeight = 1080, 720 --fixed game resolution

function love.load()
	local windowWidth, windowHeight = love.window.getDesktopDimensions()
	if love.system.getOS() == "iOS" or love.system.getOS() == "Android" then
		push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, { fullscreen = true, resizable = false })
	else
		push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, { fullscreen = false })
	end

	assets.load()

	StateManager.add("Menu", Menu())
	StateManager.add("Gameplay", Gameplay())
	StateManager.switch("Menu")
end

function love.update(dt)
	StateManager.update(dt)
end

function love.draw()
	push:start()
		StateManager.draw()
	push:finish()
end

function love.keypressed(key)
	StateManager.keypressed(key)
end

function love.mousepressed(x, y, button)
	local gx, gy = push:toGame(x, y)
	if gx and gy then
		StateManager.mousepressed(gx, gy, button)
	end
end

function love.mousemoved(x, y, dx, dy)
	local gx, gy = push:toGame(x, y)
	if gx and gy then
		StateManager.mousemoved(gx, gy, dx, dy)
	end
end
