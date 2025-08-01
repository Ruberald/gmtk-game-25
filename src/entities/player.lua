local player = {
    x = 0, y = 0,
    gridX = 1, gridY = 1,
    targetGridX = 1, targetGridY = 1,

    moving = false,
    moveTimer = 0,
    moveDuration = 0.2,

    idleImage = nil,
    walkImage = nil,
    quads = { idle = {}, run = {} },
    width = 16, height = 32,
    drawScale = 1,
    flipH = false,
    facingRow = 6, 

    currentAnimation = 'idle',
    animationTimer = 0,
    currentFrame = 1,
    frameDurationIdle = 0.15,
    frameDurationRun = 0.05,

    isDead = false,

    spawnEffect = nil,

}

local currentQuad

local FRAME_W, FRAME_H = 16, 32
local ROWS = 6
local COLS = 8
local START_X, START_Y = 16, 16
local STRIDE_X, STRIDE_Y = 48, 64

function player:load()
    if not self.spriteSheet then
        self.spriteSheet = love.graphics.newImage('assets/player_spritesheet.png')
    end

    if not self.spawnEffect then
        local partImg = love.graphics.newImage('assets/particle.png')
        self.spawnEffect = love.graphics.newParticleSystem(partImg, 300)
        self.spawnEffect:setParticleLifetime(0.1, 0.2)
        self.spawnEffect:setEmissionRate(0)
        self.spawnEffect:setSpeed(50, 150)
        self.spawnEffect:setSpread(math.pi * 2)
        self.spawnEffect:setLinearAcceleration(0, 0, 0, 0)
        self.spawnEffect:setSizes(0.05, 0.02)  
        self.spawnEffect:setColors(
            1, 1, 1, 1,
            1, 1, 1, 0
        )
    end

   if not self.idleImage then
       self.idleImage = love.graphics.newImage('assets/player/idle.png')
   end
   if not self.walkImage then
       self.walkImage = love.graphics.newImage('assets/player/walk.png')
   end
   if #self.quads.idle == 0 then
       for row = 1, ROWS do
           self.quads.idle[row] = {}
           for col = 1, COLS do
               local x = START_X + (col - 1) * STRIDE_X
               local y = START_Y + (row - 1) * STRIDE_Y
               self.quads.idle[row][col] = love.graphics.newQuad(x, y, FRAME_W, FRAME_H, self.idleImage:getWidth(), self.idleImage:getHeight())
           end
       end
   end
   if #self.quads.run == 0 then
       for row = 1, ROWS do
           self.quads.run[row] = {}
           for col = 1, COLS do
               local x = START_X + (col - 1) * STRIDE_X
               local y = START_Y + (row - 1) * STRIDE_Y
               self.quads.run[row][col] = love.graphics.newQuad(x, y, FRAME_W, FRAME_H, self.walkImage:getWidth(), self.walkImage:getHeight())
           end
       end
   end
end

function player:reset(initialGridX, initialGridY, tileSize)
    self.gridX = initialGridX
    self.gridY = initialGridY
    self.targetGridX = initialGridX
    self.targetGridY = initialGridY
    self.x = (self.gridX - 1) * tileSize + (tileSize / 2)
    self.y = (self.gridY - 1) * tileSize + (tileSize / 2)
    self.rotation = 0
    self.currentAnimation = 'idle'
    self.animationTimer = 0
    self.currentFrame = 1
    self.moving = false
    self.moveTimer = 0
    self.isDead = false
    self.flipH = false
    self.facingRow = 6

    if self.spawnEffect then
        self.spawnEffect:setPosition(self.x, self.y)
        self.spawnEffect:emit(25)   
    end
end

function player:getIsDead()
    return self.isDead
end

function player:update(dt, collisionMap, tileSize, gameTimer, actionsTable)
    local newAnimation = self.currentAnimation

    if self.moving then
        self.moveTimer = self.moveTimer + dt
        local moveProgress = self.moveTimer / self.moveDuration
        newAnimation = 'run'

        if moveProgress >= 1 then
            self.gridX = self.targetGridX
            self.gridY = self.targetGridY
            self.x = (self.gridX - 1) * tileSize + (tileSize / 2)
            self.y = (self.gridY - 1) * tileSize + (tileSize / 2)
            self.moving = false
            self.moveTimer = 0
            newAnimation = 'idle'
        else
            local startX = (self.gridX - 1) * tileSize + (tileSize / 2)
            local startY = (self.gridY - 1) * tileSize + (tileSize / 2)
            local endX = (self.targetGridX - 1) * tileSize + (tileSize / 2)
            local endY = (self.targetGridY - 1) * tileSize + (tileSize / 2)

            self.x = startX + (endX - startX) * moveProgress
            self.y = startY + (endY - startY) * moveProgress
        end
    else
        newAnimation = 'idle'
        local targetX, targetY = self.gridX, self.gridY
        local movedInput = false

        if love.keyboard.isDown('down','s') then
            targetY = self.gridY + 1
            self.facingRow = 1; self.flipH = false
            movedInput = true
        elseif love.keyboard.isDown('up','w') then
            targetY = self.gridY - 1
            self.facingRow = 4; self.flipH = false
            movedInput = true
        elseif love.keyboard.isDown('left','a') then
            targetX = self.gridX - 1
            self.facingRow = 6; self.flipH = true
            movedInput = true
        elseif love.keyboard.isDown('right','d') then
            targetX = self.gridX + 1
            self.facingRow = 6; self.flipH = false
            movedInput = true
        elseif love.keyboard.isDown('space') then
            self.isDead = true
        end

        if movedInput then
            local mapWidthInTiles = #collisionMap[1]
            local mapHeightInTiles = #collisionMap

            if targetX >= 1 and targetX <= mapWidthInTiles and
                targetY >= 1 and targetY <= mapHeightInTiles then

                if collisionMap[targetY][targetX] == 0 then
                    self.targetGridX = targetX
                    self.targetGridY = targetY
                    self.moving = true
                    self.moveTimer = 0
                    newAnimation = 'run'

                    local action = {
                        time = gameTimer,
                        type = 'move',
                        targetGridX = targetX,
                        targetGridY = targetY
                    }
                    table.insert(actionsTable, action)
                end
            end
        end
    end

    if self.currentAnimation ~= newAnimation then
        self.currentAnimation = newAnimation
        self.currentFrame = 1
        self.animationTimer = 0
    end

    local cols = COLS
    local frameTime = (self.currentAnimation=='idle') and self.frameDurationIdle or self.frameDurationRun
    self.animationTimer = self.animationTimer + dt
    if self.animationTimer >= frameTime then
        self.currentFrame = (self.currentFrame % cols) + 1
        self.animationTimer = self.animationTimer - frameTime
    end

    if self.spawnEffect then
        self.spawnEffect:update(dt)
    end
end

function player:draw()

    local map = (self.currentAnimation=='idle') and self.idleImage or self.walkImage
    local quadSet = (self.currentAnimation=='idle') and self.quads.idle or self.quads.run
    local quad = quadSet[self.facingRow][self.currentFrame]

    love.graphics.setColor(1,1,1,1)
    local sx = self.flipH and -self.drawScale or self.drawScale
    love.graphics.draw(map, quad,
        self.x, self.y,
        0, sx, self.drawScale,
        FRAME_W/2, FRAME_H/2)
    love.graphics.setColor(1,1,1,1)

    if self.spawnEffect then
        love.graphics.push()
        love.graphics.setBlendMode('add')
        love.graphics.draw(self.spawnEffect)
        love.graphics.setBlendMode('alpha')
        love.graphics.pop()
    end
end

return player