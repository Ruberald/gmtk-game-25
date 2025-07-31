local player = require 'src.entities.player'

local level1 = {
  bg = nil,
  camera = {x = 0, y = 0, w = 800, h = 600},
  roomW = 2560, roomH = 1440
}

function level1:enter()
  self.bg = love.graphics.newImage('assets/bg1.png')
  player:load()
  player:reset(200, 200)
end

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

function level1:update(dt)
    player:update(dt, level1.roomW, level1.roomH)

    -- players center 
    local playerCenterX = player.x + player.width / 2
    local playerCenterY = player.y + player.height / 2

    -- ideally the player will be in the center of the screen
    -- so if the player is already at the center, desiredCameraX will be 0, hence we dont need to "shift" the bg at all
    local desiredCameraX = playerCenterX - screenWidth / 2
    local desiredCameraY = playerCenterY - screenHeight / 2

    -- clamp camera to room boundaries
    self.camera.x = math.max(0, desiredCameraX)
    -- top edge clamp
    self.camera.y = math.max(0, desiredCameraY)

    -- if the room is smaller than the screen width, the camera should stay at 0
    if self.roomW < screenWidth then
        self.camera.x = 0
    else
        self.camera.x = math.min(self.camera.x, self.roomW - screenWidth)
    end

    if self.roomH < screenHeight then
        self.camera.y = 0
    else
        self.camera.y = math.min(self.camera.y, self.roomH - screenHeight)
    end
end

function level1:draw()
  -- draw background
  love.graphics.draw(self.bg, -self.camera.x, -self.camera.y) -- the last two arguments are for the "translation"
  -- draw player
  player:draw(self.camera)
end

return level1
