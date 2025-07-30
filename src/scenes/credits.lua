local credits = {}

local font
local screenWidth
local screenHeight

local startingPosition = { y = 0 }

-- `previous` - the previously active scene, or `false` if there was no previously active scene
-- `...` - additional arguments passed to `manager.enter` or `manager.push`
function credits:enter(previous, ...)
  -- set up the level
  love.graphics.setBackgroundColor(colors.rgbForGraphics(colors.Gray700))

  font = love.graphics.newFont(24)
  love.graphics.setFont(font)

  -- Store screen dimensions
  screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

  startingPosition.y = screenHeight / 3
end

function credits:update(dt)
  -- update entities
  flux.update(dt)
end

function credits:keypressed(key)
  -- someone pressed a key
  -- pressing any key closes the credits
  if key then
    roomy:push(scenes.mainMenu)
  end
end

function credits:mousepressed()
  -- skip on click
  roomy:push(scenes.mainMenu)
end

-- `next` - the scene that will be active next
-- `...` - additional arguments passed to `manager.enter` or `manager.pop`
function credits:leave(next, ...)
  -- destroy entities and cleanup resources
  font, screenWidth, screenHeight, startingPosition = nil, nil, nil, nil
end

-- `next` - the scene that was pushed on top of this scene
-- `...` - additional arguments passed to `manager.push`
function credits:pause(next, ...)
  -- destroy entities and cleanup resources
end

-- `previous` - the scene that was popped
-- `...` - additional arguments passed to `manager.pop`
function credits:resume(previous, ...)
  -- Called when a scene is popped and this scene becomes active again.
end

function credits:draw()
  flux.to(startingPosition, 30, { y = -1000 }):ease("linear"):delay(2):oncomplete(function ()
    roomy:push(scenes.mainMenu)
  end)

  -- Print centered text
  love.graphics.printf(
    "Credits",
    0, startingPosition.y - font:getHeight() / 2,
    screenWidth, "center"
  )
end

return credits