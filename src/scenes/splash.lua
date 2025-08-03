local splash = {}

local font
local screenWidth, screenHeight
local spriteSheet
local quads = {}

local currentFrame = 1
local frameTime = 1 / 12
local elapsedTime = 0
local frameCount = 9
local frameWidth = 320
local frameHeight = 160

local isAnimating = false

function splash:enter(previous, ...)
  love.graphics.setBackgroundColor(colors.black)

  font = love.graphics.newFont("assets/font.ttf", 60)
  love.graphics.setFont(font)

  screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

  spriteSheet = love.graphics.newImage("assets/title screen.png")

  frameCount = 8
  frameWidth = 320
  frameHeight = 160
  quads = {}

  for i = 0, frameCount - 1 do
    table.insert(quads, love.graphics.newQuad(
      i * frameWidth, 0, frameWidth, frameHeight,
      spriteSheet:getDimensions()
    ))
  end

  currentFrame = 1
  elapsedTime = 0
  isAnimating = false
end

function splash:resume(previous, ...)
    isAnimating = false
  currentFrame = 1
  elapsedTime = 0
end

function splash:update(dt)
  -- Update current window dimensions in case it changed
  screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

  if isAnimating then
    elapsedTime = elapsedTime + dt
    if elapsedTime >= frameTime then
      elapsedTime = elapsedTime - frameTime
      currentFrame = currentFrame + 1

      if currentFrame > frameCount then
        roomy:push(scenes.mainMenu)
      end
    end
  end
end
function splash:keypressed()
  if not isAnimating then
    isAnimating = true
    currentFrame = 1
    elapsedTime = 0
  end
end

function splash:mousepressed()
  if not isAnimating then
    isAnimating = true
    currentFrame = 1
    elapsedTime = 0
  end
end

-- function splash:leave(next, ...)
--   font, screenWidth, screenHeight = nil, nil, nil
--   spriteSheet, quads, currentFrame = nil, nil, nil
--   elapsedTime, timer = nil, nil
-- end

function splash:draw()
  local scaleX = screenWidth / frameWidth
  local scaleY = screenHeight / frameHeight
  local scale = math.max(scaleX, scaleY)

  local drawWidth = frameWidth * scale
  local drawHeight = frameHeight * scale
  local x = (screenWidth - drawWidth) / 2
  local y = (screenHeight - drawHeight) / 2

  local frameIndex = math.min(currentFrame, frameCount)
  local quad = quads[frameIndex]

  if spriteSheet and quad then
    love.graphics.draw(spriteSheet, quad, x, y, 0, scale, scale)
  end

  if not isAnimating then
      local hint = "Press any key to start"
      love.graphics.setFont(font)
      love.graphics.setColor(1, 1, 1, 0.7) -- slight transparency

      local textWidth = font:getWidth(hint)
      local fx = (screenWidth - textWidth) / 2
      local fy = screenHeight - 80

      love.graphics.print(hint, fx, fy)
      love.graphics.setColor(1, 1, 1, 1) -- reset
  end

end

return splash
