local splash = {}

local font
local screenWidth
local screenHeight

local timer = step.after(3)

-- `previous` - the previously active scene, or `false` if there was no previously active scene
-- `...` - additional arguments passed to `manager.enter` or `manager.push`
function splash:enter(previous, ...)
  love.graphics.setBackgroundColor(colors.black)

  font = love.graphics.newFont(24)
  love.graphics.setFont(font)

  -- Store screen dimensions
  screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
end

function splash:update(dt)
  -- update entities
  if timer:update(dt) then
    roomy:push(scenes.mainMenu)
  end
end

function splash:keypressed(key)
  -- pressing any key skips the splash
  if key then
    roomy:push(scenes.mainMenu)
  end
end

function splash:mousepressed()
  -- skip on click
  roomy:push(scenes.mainMenu)
end

-- `next` - the scene that will be active next
-- `...` - additional arguments passed to `manager.enter` or `manager.pop`
function splash:leave(next, ...)
  -- destroy entities and cleanup resources
  font, screenWidth, screenHeight, timer = nil, nil, nil, nil
end

-- `next` - the scene that was pushed on top of this scene
-- `...` - additional arguments passed to `manager.push`
function splash:pause(next, ...)
  -- destroy entities and cleanup resources
end

-- `previous` - the scene that was popped
-- `...` - additional arguments passed to `manager.pop`
function splash:resume(previous, ...)
  -- Called when a scene is popped and this scene becomes active again.
end

function splash:draw()
  -- Calculate center position
  local centerY = screenHeight / 2

  -- Print centered text
  love.graphics.printf(
    "Splash Screen",
    0, centerY - font:getHeight() / 2,
    screenWidth, "center"
  )
end

return splash