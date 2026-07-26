if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local push = require("lib.push")
local StateManager = require("core.statemanager")
local assets = require("core.assets")
local window = require("core.window")
local controls = require("core.controls")

function love.load()
	window.setup()
	assets.load()
	StateManager.loadAll()
	StateManager.switch("Splash")
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
	controls.keypressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
	controls.mousepressed(x, y, button, presses)
end

function love.mousemoved(x, y, dx, dy)
	controls.mousemoved(x, y, dx, dy)
end

function love.mousereleased(x, y, button)
	controls.mousereleased(x, y, button)
end

function love.resize(w, h)
	window.resize(w, h)
end
