local enemy = {
    x = 0, y = 0,
    gridX = 1, gridY = 1,
    targetGridX = 1, targetGridY = 1,

    tileSize = 16,
    moveTimer = 0,
    moveDuration = 0.3,
    moving = false,
    active = false,

    sprites = {},
    quads = {},
    width = 16,
    height = 16,
    drawScale = 1,
    totalFrames = 8,
    frameDuration = 0.1,

    direction = "down", -- 'up', 'down', 'left', 'right'
    currentFrame = 1,
    animationTimer = 0,

    triggered = false,
    triggerDistance = 3,

    target = nil,
}

function enemy:load()
    local frameWidth = 16
    local frameHeight = 16
    local gap = 7
    local padding = 2

    self.sprites = {
        down = love.graphics.newImage('assets/enemy/enemy_front.png'),
        up = love.graphics.newImage('assets/enemy/enemy_front.png'),
        side = love.graphics.newImage('assets/enemy/enemy_front.png'),
    }

    self.quads = {}
    for dir, image in pairs(self.sprites) do
        self.quads[dir] = {}
        for i = 0, self.totalFrames - 1 do
            local x = padding + 1 + i * (frameWidth + gap)
            local y = padding
            local quad = love.graphics.newQuad(
                x, y,
                frameWidth, frameHeight,
                image:getWidth(), image:getHeight()
            )
            table.insert(self.quads[dir], quad)
        end
    end
end

function enemy:reset(gridX, gridY, tileSize)
    self.gridX = gridX
    self.gridY = gridY
    self.targetGridX = gridX
    self.targetGridY = gridY
    self.tileSize = tileSize
    self.x = (gridX - 1) * tileSize + tileSize / 2
    self.y = (gridY - 1) * tileSize + tileSize / 2
    self.direction = "down"

    self.currentFrame = 1
    self.animationTimer = 0
    self.moving = false
    self.triggered = false
end

function enemy:trigger()
    self.triggered = true
end

function enemy:update(dt, player, ghost)
    if not self.triggered then
        local playerDist = math.abs(self.gridX - player.gridX) + math.abs(self.gridY - player.gridY)
        local ghostDist = math.abs(self.gridX - ghost.gridX) + math.abs(self.gridY - ghost.gridY)

        if playerDist <= self.triggerDistance or ghostDist <= self.triggerDistance then
            if playerDist <= ghostDist then
                self.target = player
            else
                self.target = ghost
            end
            self:trigger()
        else
            return -- wait until something gets close enough
        end
    end
    -- Movement
    if not self.moving then
        -- If target died (e.g., player fell), reset target and wait
        if self.target and self.target.isDead then
            self.triggered = false
            self.target = nil
            return
        end

        local dx = self.target.gridX - self.gridX
        local dy = self.target.gridY - self.gridY

        if dx ~= 0 or dy ~= 0 then
            if math.abs(dx) > math.abs(dy) then
                self.targetGridX = self.gridX + (dx > 0 and 1 or -1)
                self.targetGridY = self.gridY
                self.direction = dx > 0 and "right" or "left"
            else
                self.targetGridY = self.gridY + (dy > 0 and 1 or -1)
                self.targetGridX = self.gridX
                self.direction = dy > 0 and "down" or "up"
            end

            self.moving = true
            self.moveTimer = 0
            self.animationTimer = 0
        end
    else
        self.moveTimer = self.moveTimer + dt
        self.animationTimer = self.animationTimer + dt

        local progress = self.moveTimer / self.moveDuration

        if progress >= 1 then
            -- Finish move
            self.gridX = self.targetGridX
            self.gridY = self.targetGridY
            self.x = (self.gridX - 1) * self.tileSize + self.tileSize / 2
            self.y = (self.gridY - 1) * self.tileSize + self.tileSize / 2
            self.moving = false
            self.moveTimer = 0
        else
            -- Smooth interpolation
            local startX = (self.gridX - 1) * self.tileSize + self.tileSize / 2
            local startY = (self.gridY - 1) * self.tileSize + self.tileSize / 2
            local endX = (self.targetGridX - 1) * self.tileSize + self.tileSize / 2
            local endY = (self.targetGridY - 1) * self.tileSize + self.tileSize / 2

            self.x = startX + (endX - startX) * progress
            self.y = startY + (endY - startY) * progress
        end

        if self.target == player and self.gridX == player.gridX and self.gridY == player.gridY then
            player:die()
        end

        -- Advance animation
        if self.animationTimer >= self.frameDuration then
            self.currentFrame = (self.currentFrame % self.totalFrames) + 1
            self.animationTimer = self.animationTimer - self.frameDuration
        end
    end
end

function enemy:draw()
    local dir = self.direction
    if dir == 'left' or dir == 'right' then
        dir = 'side'
    end

    local image = self.sprites[dir]
    local quad = self.quads[dir][self.currentFrame]

    local scaleX = self.drawScale
    local offsetX = 0
    if self.direction == 'left' then
        scaleX = -self.drawScale
        offsetX = self.width
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        image,
        quad,
        self.x + offsetX, self.y,
        0,
        scaleX, self.drawScale,
        self.width / 2, self.height / 2
    )
end

return enemy
