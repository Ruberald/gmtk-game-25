local player = {
    x = 0, y = 0,
    gridX = 1, gridY = 1,
    targetGridX = 1, targetGridY = 1,

    currentZ = 0,

    moving = false,
    moveTimer = 0,
    moveDuration = 0.2,

    idleImage = nil,
    walkImage = nil,
    deathImage = nil,
    dashImage = nil,
    quads = { idle = {}, run = {}, death = {}, dash = {} },
    width = 16, height = 32,
    drawScale = 1,
    initialDrawScale = 1,
    flipH = false,
    facingRow = 6,

    currentAnimation = 'idle',
    animationTimer = 0,
    currentFrame = 1,
    frameDurationIdle = 0.15,
    frameDurationRun = 0.05,
    frameDurationDeath = 0.1,
    frameDurationDash = 0.05, 

    isDead = false,
    isReadyToRespawn = false,
    deathType = 'none',
    pitfallTimer = 0,
    pitfallDuration = 0.4,

    spawnEffect = nil,
    hasKey = false

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
   if not self.deathImage then
       self.deathImage = love.graphics.newImage('assets/player/death_normal.png')
   end
   if not self.dashImage then
       self.dashImage = love.graphics.newImage('assets/player/dash.png')
   end
   if #self.quads.dash == 0 then
       for row = 1, ROWS do
           self.quads.dash[row] = {}
           for col = 1, COLS do
               local x = START_X + (col - 1) * STRIDE_X
               local y = START_Y + (row - 1) * STRIDE_Y
               self.quads.dash[row][col] = love.graphics.newQuad(
                   x, y, FRAME_W, FRAME_H,
                   self.dashImage:getWidth(), self.dashImage:getHeight()
               )
           end
       end
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
   if #self.quads.death == 0 then
       for row = 1, ROWS do
           self.quads.death[row] = {}
           for col = 1, COLS do
               local x = START_X + (col-1)*STRIDE_X
               local y = START_Y + (row-1)*STRIDE_Y
               self.quads.death[row][col] = love.graphics.newQuad(x,y,FRAME_W,FRAME_H,
                       self.deathImage:getWidth(), self.deathImage:getHeight())
           end
       end
   end
end

function player:reset(initialGridX, initialGridY, tileSize, initialZ)
    self.gridX = initialGridX
    self.gridY = initialGridY
    self.currentZ = initialZ
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
    self.isReadyToRespawn = false
    self.flipH = false
    self.facingRow = 6
    self.initialDrawScale = 1
    self.drawScale = self.initialDrawScale

    if self.spawnEffect then
        self.spawnEffect:setPosition(self.x, self.y)
        self.spawnEffect:emit(25)
    end
end

function player:getIsReadyToRespawn()
    return self.isReadyToRespawn
end

function player:die(type)
    if self.isDead then return end

    self.isDead = true
    self.deathType = type or 'normal'
    self.isReadyToRespawn = false

    if self.deathType == 'normal' then
        self.currentAnimation = 'death'
        self.currentFrame = 1
        self.animationTimer = 0
    elseif self.deathType == 'pitfall' then
        self.pitfallTimer = 0
        -- initialize dash animation
        self.currentAnimation = 'dash'
        self.currentFrame = 1
        self.animationTimer = 0
    end
end

function player:update(dt, collisionMap, tileSize, gameTimer, actionsTable, currentZ)
    self.currentZ = currentZ
    if self.isDead then
        if self.isReadyToRespawn then return end

        if self.deathType == 'normal' then
            self.animationTimer = self.animationTimer + dt
            if self.animationTimer >= self.frameDurationDeath then
                self.animationTimer = self.animationTimer - self.frameDurationDeath
                self.currentFrame = self.currentFrame + 1
                if self.currentFrame > COLS then
                    self.currentFrame = COLS
                    self.isReadyToRespawn = true
                end
            end
        elseif self.deathType == 'pitfall' then
            self.pitfallTimer = self.pitfallTimer + dt
            local progress = math.min(1, self.pitfallTimer / self.pitfallDuration)
            self.drawScale = self.initialDrawScale * (1 - progress/2)

            self.animationTimer = self.animationTimer + dt
            if self.animationTimer >= self.frameDurationDash then
                self.animationTimer = self.animationTimer - self.frameDurationDash
                self.currentFrame = (self.currentFrame % COLS) + 1
            end

            if progress >= 1 then
                self.isReadyToRespawn = true
            end
        end
        return self.currentZ
    end

    if self.moving then
        self.moveTimer = self.moveTimer + dt
        local moveProgress = self.moveTimer / self.moveDuration
        local newAnimation = 'run'

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

        if self.currentAnimation ~= newAnimation then
            self.currentAnimation = newAnimation
            self.currentFrame = 1
            self.animationTimer = 0
        end

    else -- Not moving
        local newAnimation = 'idle'
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
            self:die('normal')
            return
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

        if self.currentAnimation ~= newAnimation then
            self.currentAnimation = newAnimation
            self.currentFrame = 1
            self.animationTimer = 0
        end
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

    return self.currentZ
end

function player:draw()
    local map, quadSet, quad

    if self.isDead and self.deathType == 'pitfall' then
        map = self.dashImage
        quadSet = self.quads.dash
        quad = quadSet[self.facingRow][self.currentFrame]
    else
        if self.currentAnimation == 'idle' then
            map = self.idleImage; quadSet = self.quads.idle
        elseif self.currentAnimation == 'run' then
            map = self.walkImage; quadSet = self.quads.run
        else
            map = self.deathImage; quadSet = self.quads.death
        end
        quad = quadSet[self.facingRow][self.currentFrame]
    end

    love.graphics.setColor(1,1,1,1)
    local sx = self.flipH and -self.drawScale or self.drawScale
    love.graphics.draw(map, quad,
        self.x, self.y,
        0, sx, self.drawScale,
        FRAME_W/2, FRAME_H/2 + 8)
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
