local player = {
  x = 100, y = 100, speed = 200,
  spriteSheet = nil,
  width = 32, height = 32,
  rotation = 0,

  currentAnimation = 'idle',
  animationTimer = 0,
  currentFrame = 1,

  animations = {
    idle = {
      frames = {
        {x = 0, y = 0, width = 32, height = 32},
        {x = 32, y = 0, width = 32, height = 32},
        {x = 64, y = 0, width = 32, height = 32},
        {x = 96, y = 0, width = 32, height = 32}
      },
      frameDuration = 0.15
    },

    run = {
        frames = {
        {x = 0, y = 64, width = 32, height = 32},
        {x = 32, y = 64, width = 32, height = 32},
        {x = 64, y = 64, width = 32, height = 32},
        {x = 96, y = 64, width = 32, height = 32},
        {x = 128, y = 64, width = 32, height = 32},
        {x = 160, y = 64, width = 32, height = 32}, 
        {x = 192, y = 64, width = 32, height = 32},
        {x = 224, y = 64, width = 32, height = 32},
        {x = 0, y = 96, width = 32, height = 32},
        {x = 32, y = 96, width = 32, height = 32},
        {x = 64, y = 96, width = 32, height = 32},
        {x = 96, y = 96, width = 32, height = 32},
        {x = 128, y = 96, width = 32, height = 32},
        {x = 160, y = 96, width = 32, height = 32},
        {x = 192, y = 96, width = 32, height = 32},
        {x = 224, y = 96, width = 32, height = 32}
      },
      frameDuration = 0.1
    }
  }
}

local currentQuad

function player:load()
  if not self.spriteSheet then
    self.spriteSheet = love.graphics.newImage('assets/player.png')
  end
end

function player:reset(x, y)
  self.x, self.y = x, y
  self.rotation = 0
  self.currentAnimation = 'idle'
  self.animationTimer = 0
  self.currentFrame = 1
end

function player:update(dt, roomW, roomH)
  local moved = false
  local newAnimation = 'idle'

  local dx = 0
  local dy = 0

  if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
    dy = dy - self.speed * dt
    self.rotation = math.rad(-90)
    moved = true
  end
  if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
    dy = dy + self.speed * dt
    self.rotation = math.rad(90)
    moved = true
  end
  if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
    dx = dx - self.speed * dt
    self.rotation = math.rad(180)
    moved = true
  end
  if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
    dx = dx + self.speed * dt
    self.rotation = math.rad(0)
    moved = true
  end

  self.x = self.x + dx
  self.y = self.y + dy

  if moved then
      newAnimation = 'run'
  else
      newAnimation = 'idle'
  end

  if self.currentAnimation ~= newAnimation then
    self.currentAnimation = newAnimation
    self.currentFrame = 1
    self.animationTimer = 0
  end

  self.x = math.max(0, self.x)
  self.x = math.min(self.x, roomW - self.width)
  self.y = math.max(0, self.y)
  self.y = math.min(self.y, roomH - self.height)

  self.animationTimer = self.animationTimer + dt
  local currentAnimData = self.animations[self.currentAnimation]

  if currentAnimData then
    local numFrames = #currentAnimData.frames
    local frameDuration = currentAnimData.frameDuration

    if self.animationTimer >= frameDuration then
        self.currentFrame = self.currentFrame + 1
        self.animationTimer = self.animationTimer - frameDuration
        if self.currentFrame > numFrames then
            self.currentFrame = 1
        end
    end
  end
end 

function player:draw(camera)
    local currentAnimData = self.animations[self.currentAnimation]
    if not currentAnimData then return end

    local frameInfo = currentAnimData.frames[self.currentFrame]
    if not frameInfo then return end

    currentQuad = love.graphics.newQuad(
        frameInfo.x,
        frameInfo.y,
        frameInfo.width,
        frameInfo.height,
        self.spriteSheet:getWidth(),
        self.spriteSheet:getHeight()
    )

    local drawX = self.x - camera.x
    local drawY = self.y - camera.y
    local originX = self.width / 2
    local originY = self.height / 2

    love.graphics.draw(
        self.spriteSheet,
        currentQuad,
        drawX + originX,
        drawY + originY,
        self.rotation,
        2, 2,  -- scale x, y, 2x for now obv very temporary
        originX,
        originY
    )
end

return player