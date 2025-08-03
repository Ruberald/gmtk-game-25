local ghost = {
    x = 0, y = 0,
    gridX = 1, gridY = 1,
    targetGridX = 1, targetGridY = 1,

    moving = false,
    moveTimer = 0,
    moveDuration = 0.2,

    idleImage = nil,
    walkImage = nil,
    quads = { idle = {}, run = {} },
    width = 32, height = 32,
    drawScale = 1,
    flipH = false,
    facingRow = 2,  -- 1=horizontal, 2=down, 3=up

    currentAnimation = 'idle',
    animationTimer = 0,
    currentFrame = 1,
    frameDurationIdle = 0.15,
    frameDurationRun = 0.05,

    actions = nil,
    actionIndex = 1,
    tileSize = 32,
    active = false,
    isFinished = false,
    spawnEffect = nil,
}


local currentQuad

local FRAME_W, FRAME_H = 16, 16
local ROWS = 3
local IDLE_COLS, WALK_COLS = 4, 8
local START_X, START_Y = 32, 32
local STRIDE_X, STRIDE_Y = 80, 80

function ghost:load()
    if not self.idleImage then
        self.idleImage = love.graphics.newImage('assets/ghost/idle.png')
    end
    if not self.walkImage then
        self.walkImage = love.graphics.newImage('assets/ghost/walk.png')
    end

    if #self.quads.idle == 0 then
        for row = 1, ROWS do
            self.quads.idle[row] = {}
            for col = 1, IDLE_COLS do
                local x = START_X + (col - 1) * STRIDE_X
                local y = START_Y + (row - 1) * STRIDE_Y
                self.quads.idle[row][col] = love.graphics.newQuad(x, y, FRAME_W, FRAME_H, self.idleImage:getWidth(), self.idleImage:getHeight())
            end
        end
    end
    if #self.quads.run == 0 then
        for row = 1, ROWS do
            self.quads.run[row] = {}
            for col = 1, WALK_COLS do
                local x = START_X + (col - 1) * STRIDE_X
                local y = START_Y + (row - 1) * STRIDE_Y
                self.quads.run[row][col] = love.graphics.newQuad(x, y, FRAME_W, FRAME_H, self.walkImage:getWidth(), self.walkImage:getHeight())
            end
        end
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
        self.spawnEffect:setColors(1,1,1,1, 1,1,1,0)
    end
end

function ghost:reset(initialGridX, initialGridY, tileSize, actionList)
    self.gridX = initialGridX
    self.gridY = initialGridY
    self.targetGridX = initialGridX
    self.targetGridY = initialGridY
    self.tileSize = tileSize
    self.x = (self.gridX - 1) * self.tileSize + (self.tileSize / 2)
    self.y = (self.gridY - 1) * self.tileSize + (self.tileSize / 2)
    self.rotation = 0
    self.flipH = false
    self.currentAnimation = 'idle'
    self.animationTimer = 0
    self.currentFrame = 1
    self.moving = false
    self.moveTimer = 0
    self.isFinished = false
    self.facingRow = 2

    if actionList and #actionList > 0 then
        self.actions = actionList
        self.actionIndex = 1
        self.active = true
    else
        self.actions = nil
        self.active = false
    end

    -- spawn effect at reset
    if self.spawnEffect then
        self.spawnEffect:setPosition(self.x, self.y)
        self.spawnEffect:emit(25)
    end
end

function ghost:update(dt, gameTimer)
    if not self.active then return end

    local nextAction = self.actions[self.actionIndex]
    if nextAction and gameTimer >= nextAction.time and not self.moving then
        if nextAction.type == 'move' then
            self.targetGridX = nextAction.targetGridX
            self.targetGridY = nextAction.targetGridY
            self.moving = true
            self.moveTimer = 0

            if self.targetGridX > self.gridX then         -- Right
                self.facingRow = 1; self.flipH = false
            elseif self.targetGridX < self.gridX then     -- Left
                self.facingRow = 1; self.flipH = true
            elseif self.targetGridY > self.gridY then     -- Down
                self.facingRow = 2; self.flipH = false
            elseif self.targetGridY < self.gridY then     -- Up
                self.facingRow = 3; self.flipH = false
            end
        end
        self.actionIndex = self.actionIndex + 1
    end

    if not self.moving and not self.actions[self.actionIndex] then
        self.isFinished = true
    end

    if self.moving then
        self.moveTimer = self.moveTimer + dt
        local moveProgress = self.moveTimer / self.moveDuration
        if moveProgress >= 1 then
            self.gridX, self.gridY = self.targetGridX, self.targetGridY
            self.x = (self.gridX - 1) * self.tileSize + (self.tileSize / 2)
            self.y = (self.gridY - 1) * self.tileSize + (self.tileSize / 2)
            self.moving = false
            self.moveTimer = 0
        else
            local startX = (self.gridX - 1) * self.tileSize + (self.tileSize / 2)
            local startY = (self.gridY - 1) * self.tileSize + (self.tileSize / 2)
            local endX = (self.targetGridX - 1) * self.tileSize + (self.tileSize / 2)
            local endY = (self.targetGridY - 1) * self.tileSize + (self.tileSize / 2)
            self.x = startX + (endX - startX) * moveProgress
            self.y = startY + (endY - startY) * moveProgress
        end
    end

    if self.spawnEffect then
        self.spawnEffect:update(dt)
    end

    local cols = (self.currentAnimation == 'idle') and IDLE_COLS or WALK_COLS
    local frameTime = (self.currentAnimation == 'idle') and self.frameDurationIdle or self.frameDurationRun
    self.animationTimer = self.animationTimer + dt
    if self.animationTimer >= frameTime then
        self.currentFrame = (self.currentFrame % cols) + 1
        self.animationTimer = self.animationTimer - frameTime
    end
end

function ghost:draw()
    if not self.active then return end

    local row = self.facingRow
    local scaleX = self.flipH and -self.drawScale or self.drawScale
    local rot = 0

    if self.isFinished then
        self.currentAnimation = 'idle'
    end

    local mapType = (self.currentAnimation == 'idle') and 'idle' or 'run'
    local img = (mapType == 'idle') and self.idleImage or self.walkImage
    currentQuad = self.quads[mapType][row][self.currentFrame]

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(img, currentQuad,
        self.x, self.y,
        rot, scaleX, self.drawScale,
        FRAME_W/2, FRAME_H/2 + 4)
    love.graphics.setColor(1, 1, 1, 1)

    if self.spawnEffect then
        love.graphics.push()
        love.graphics.setBlendMode('add')
        love.graphics.draw(self.spawnEffect)
        love.graphics.setBlendMode('alpha')
        love.graphics.pop()
    end
end

return ghost
