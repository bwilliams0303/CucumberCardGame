local assets = {}

function assets.load()
	assets.images = {
		title = love.graphics.newImage("assets/title.png"),
		startButton = love.graphics.newImage("assets/UI/PNG/Red/Default/button_rectangle_flat.png"),
	}
end

return assets
