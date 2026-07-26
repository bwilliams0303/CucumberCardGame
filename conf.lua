function love.conf(t)
	t.window.title = "Cucumber"
	t.window.width = 1080
	t.window.height = 720
	t.window.fullscreen = true -- also set here (not just in core/window.lua) so
	                           -- the window opens fullscreen from the first
	                           -- frame instead of flashing small then snapping
	t.identity = "cucumber"
end
