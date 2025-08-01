local ghost = {
    x = 0, y = 0,
    gridX = 1, gridY = 1,
    targetGridX = 1, targetGridY = 1,

    moving = false,
    moveTimer = 0,
    moveDuration = 0.2,

    spriteSheet = nil,
    tombstoneImage = nil, 
    width = 32, height = 32,
    drawScale = 2,
    rotation = 0,

    currentAnimation = 'idle',
    animationTimer = 0,
    currentFrame = 1,

    actions = nil,
    actionIndex = 1,
    tileSize = 32,
    active = false,
    isFinished = false,

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
            frameDuration = 0.05
        }
    }
}

local currentQuad

function ghost:load()
    if not self.spriteSheet then
        self.spriteSheet = love.graphics.newImage('assets/player_spritesheet.png')
    end
    if not self.tombstoneImage then
        self.tombstoneImage = love.graphics.newImage('assets/tombstone.png')
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
    self.currentAnimation = 'idle'
    self.animationTimer = 0
    self.currentFrame = 1
    self.moving = false
    self.moveTimer = 0
    self.isFinished = false
    self.drawScale = tileSize / self.width

    if actionList and #actionList > 0 then
        self.actions = actionList
        self.actionIndex = 1
        self.active = true
    else
        self.actions = nil
        self.active = false
    end
end

function ghost:update(dt, gameTimer)
    if not self.active or self.isFinished then
        return
    end

    local nextAction = self.actions[self.actionIndex]
    if nextAction and gameTimer >= nextAction.time and not self.moving then
        if nextAction.type == 'move' then
            self.targetGridX = nextAction.targetGridX
            self.targetGridY = nextAction.targetGridY
            self.moving = true
            self.moveTimer = 0

            if self.targetGridX > self.gridX then self.rotation = math.rad(0)
            elseif self.targetGridX < self.gridX then self.rotation = math.rad(0)
            elseif self.targetGridY > self.gridY then self.rotation = math.rad(90)
            elseif self.targetGridY < self.gridY then self.rotation = math.rad(-90) end
        end
        self.actionIndex = self.actionIndex + 1
    end

    if not self.moving and not self.actions[self.actionIndex] then
        self.isFinished = true
        self.rotation = 0 
        return
    end

    local newAnimation = self.currentAnimation
    if self.moving then
        self.moveTimer = self.moveTimer + dt
        local moveProgress = self.moveTimer / self.moveDuration
        newAnimation = 'run'
        if moveProgress >= 1 then
            self.gridX = self.targetGridX
            self.gridY = self.targetGridY
            self.x = (self.gridX - 1) * self.tileSize + (self.tileSize / 2)
            self.y = (self.gridY - 1) * self.tileSize + (self.tileSize / 2)
            self.moving = false
            self.moveTimer = 0
            newAnimation = 'idle'
        else
            local startX = (self.gridX - 1) * self.tileSize + (self.tileSize / 2)
            local startY = (self.gridY - 1) * self.tileSize + (self.tileSize / 2)
            local endX = (self.targetGridX - 1) * self.tileSize + (self.tileSize / 2)
            local endY = (self.targetGridY - 1) * self.tileSize + (self.tileSize / 2)
            self.x = startX + (endX - startX) * moveProgress
            self.y = startY + (endY - startY) * moveProgress
        end
    else
        newAnimation = 'idle'
    end

    if self.currentAnimation ~= newAnimation then
        self.currentAnimation = newAnimation
        self.currentFrame = 1
        self.animationTimer = 0
    end

    if not self.isFinished then
        self.animationTimer = self.animationTimer + dt
        local currentAnimData = self.animations[self.currentAnimation]
        if currentAnimData then
            local numFrames = #currentAnimData.frames
            local frameDuration = currentAnimData.frameDuration
            if self.animationTimer >= frameDuration then
                self.currentFrame = (self.currentFrame % numFrames) + 1
                self.animationTimer = self.animationTimer - frameDuration
            end
        end
    end
end

function ghost:draw()
    if not self.active then
        return
    end

    if self.isFinished then
        love.graphics.setColor(1, 1, 1, 0.9)
        if self.tombstoneImage then
            love.graphics.draw(
                self.tombstoneImage,
                self.x,
                self.y,
                self.rotation, -- Will be 0
                self.drawScale,
                self.drawScale,
                self.tombstoneImage:getWidth() / 2, 
                self.tombstoneImage:getHeight() / 2
            )
        end
    else
        love.graphics.setColor(1, 1, 1, 0.5)
        local currentAnimData = self.animations[self.currentAnimation]
        if currentAnimData and self.spriteSheet then
            local frameInfo = currentAnimData.frames[self.currentFrame]
            if frameInfo then
                currentQuad = love.graphics.newQuad(
                    frameInfo.x, frameInfo.y,
                    frameInfo.width, frameInfo.height,
                    self.spriteSheet:getWidth(), self.spriteSheet:getHeight()
                )
                love.graphics.draw(
                    self.spriteSheet, currentQuad,
                    self.x, self.y,
                    self.rotation, self.drawScale, self.drawScale,
                    self.width / 2, self.height / 2
                )
            end
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return ghost
