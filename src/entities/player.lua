local player = {
    x = 0, y = 0,
    gridX = 1, gridY = 1,
    targetGridX = 1, targetGridY = 1,

    moving = false,
    moveTimer = 0,
    moveDuration = 0.2,

    spriteSheet = nil,
    width = 32, height = 32,
    drawScale = 2,
    rotation = 0,

    currentAnimation = 'idle',
    animationTimer = 0,
    currentFrame = 1,

    isDead = false,

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

function player:load()
    if not self.spriteSheet then
        self.spriteSheet = love.graphics.newImage('assets/player_spritesheet.png')
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
end

function player:getIsDead()
    return self.isDead
end

function player:update(dt, mapData, tileSize, gameTimer, actionsTable)
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
        local targetX = self.gridX
        local targetY = self.gridY
        local movedInput = false

        if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
            targetY = self.gridY - 1
            self.rotation = math.rad(-90)
            movedInput = true
        elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
            targetY = self.gridY + 1
            self.rotation = math.rad(90)
            movedInput = true
        elseif love.keyboard.isDown('left') or love.keyboard.isDown('a') then
            targetX = self.gridX - 1
            self.rotation = math.rad(0)
            movedInput = true
        elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
            targetX = self.gridX + 1
            self.rotation = math.rad(0)
            movedInput = true
        elseif love.keyboard.isDown('space') then
            self.isDead = true
        end

        if movedInput then
            local mapWidthInTiles = #mapData[1]
            local mapHeightInTiles = #mapData

            if targetX >= 1 and targetX <= mapWidthInTiles and
                targetY >= 1 and targetY <= mapHeightInTiles then
                local tileID = mapData[targetY][targetX]
                if tileID == 90 then
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

function player:draw()
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

    love.graphics.draw(
        self.spriteSheet,
        currentQuad,
        self.x,
        self.y,
        self.rotation,
        self.drawScale,
        self.drawScale,
        self.width / 2,
        self.height / 2
    )
end

return player