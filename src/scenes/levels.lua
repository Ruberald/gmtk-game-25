local level1Data = require 'src.levels.level1'
local level2Data = require 'src.levels.level2'
local level3Data = require 'src.levels.level3'
local player = require 'src.entities.player'
local ghost = require 'src.entities.ghost'
local enemy = require 'src.entities.enemy'

local function createLevel(tiledMapData, nextLevelKey)
    local level = {
        mapWidthInTiles = tiledMapData.width,
        mapHeightInTiles = tiledMapData.height,
        tileSize = tiledMapData.tilewidth,
        nextLevelKey = nextLevelKey,

        playerStartX = 8,
        playerStartY = 6,

        tilesetImage = nil,
        tileQuads = {},
        tileLayers = {},
        collisionMap = {},

        scale = 1,
        offsetX = 0,
        offsetY = 0,

        gameTimer = 0,
        currentRunActions = {},
        lastRunActions = nil,

        -- tile ids
        chasm = 67,
        closedDoor = 66,
        openDoor = 53,
        doorBlock = 81,
        levelUpTile = 34,
        pressurePlate = 106,
        pressedPressurePlate = 107,
        leverUp = 108,
        button = 109,
        pressedButton = 111,
        leverDown = 112,
        spike1 = 113,
        spike2 = 114,
        spike3 = 115,
        spikeInterval = 0.5,
        spikeDirection = 1,

        -- interactable object state
        doorPos = nil,
        buttonPos = nil,
        pressurePlatePos = nil,
        isDoorOpen = false,
        doorTimer = 0,
        doorOpenDuration = 1,
        buttonWasPressed = false,
        pressurePlateWasPressed = false,
    }

    function level:load()
        self.tileLayers = {}
        self.collisionMap = {}
        self.tileQuads = {}
        self.doorPos, self.buttonPos, self.pressurePlatePos = nil, nil, nil

        for _, ts in ipairs(tiledMapData.tilesets) do
            local image = love.graphics.newImage('assets/' .. ts.name .. '.png')
            local imgW, imgH = image:getWidth(), image:getHeight()
            local cols = math.floor(imgW / self.tileSize)
            local rows = math.floor(imgH / self.tileSize)
            local id = ts.firstgid
            for ry = 0, rows - 1 do
                for cx = 0, cols - 1 do
                    self.tileQuads[id] = { image = image, quad = love.graphics.newQuad(
                        cx * self.tileSize, ry * self.tileSize,
                        self.tileSize, self.tileSize,
                        imgW, imgH
                    ) }
                    id = id + 1
                end
            end
        end

        for _, layerData in ipairs(tiledMapData.layers) do
            if layerData.type == "tilelayer" then
                local layer2D = {}
                for y = 1, self.mapHeightInTiles do
                    layer2D[y] = {}
                    for x = 1, self.mapWidthInTiles do
                        local i = (y - 1) * self.mapWidthInTiles + x
                        layer2D[y][x] = layerData.data[i]
                    end
                end

                if layerData.name == "Collisions" then
                    self.collisionMap = layer2D
                else
                    table.insert(self.tileLayers, layer2D)
                end
            end
        end

        for layerIndex, layer in ipairs(self.tileLayers) do
            for y = 1, self.mapHeightInTiles do
                for x = 1, self.mapWidthInTiles do
                    local tid = layer[y][x]
                    if tid == self.doorBlock then
                        self.doorPos = { layer = layerIndex, x = x, y = y }
                        self.collisionMap[y][x] = 1
                    elseif tid == self.button then
                        self.buttonPos = { layer = layerIndex, x = x, y = y }
                    elseif tid == self.pressurePlate then
                        self.pressurePlatePos = { layer = layerIndex, x = x, y = y }
                    elseif tid == self.levelUpTile then
                        self.levelUpPos = { layer = layerIndex, x = x, y = y }
                    end
                end
            end
        end

        self.spikePositions = {}
        for layerIndex, layer in ipairs(self.tileLayers) do
            for y = 1, self.mapHeightInTiles do
                for x = 1, self.mapWidthInTiles do
                    if layer[y][x] == self.spike1 then
                        table.insert(self.spikePositions, { layer = layerIndex, x = x, y = y })
                    end
                end
            end
        end
        self.spikeTimer = 0
        self.spikeFrame = 1
        self.spikeDirection = 1

        player:load()
        ghost:load()

        enemy:load()

        self.lastRunActions = nil
        ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, nil)
        self:startNewRun()
    end

    function level:startNewRun()
        if #self.currentRunActions > 0 then self.lastRunActions = self.currentRunActions end
        self.gameTimer = 0
        self.currentRunActions = {}
        enemy:reset(10, 10, self.tileSize)

        self.playerCurrentZ = 0
        player:reset(self.playerStartX, self.playerStartY, self.tileSize, self.playerCurrentZ)

        if self.lastRunActions then
            ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, self.lastRunActions)
        end

        self.isDoorOpen = false
        self.doorTimer = 0
        self.buttonWasPressed = false
        self.pressurePlateWasPressed = false

        if self.doorPos then
            self.tileLayers[self.doorPos.layer][self.doorPos.y][self.doorPos.x] = self.doorBlock
            self.collisionMap[self.doorPos.y][self.doorPos.x] = 1
        end
        if self.buttonPos then
            self.tileLayers[self.buttonPos.layer][self.buttonPos.y][self.buttonPos.x] = self.button
        end
        if self.pressurePlatePos then
            self.tileLayers[self.pressurePlatePos.layer][self.pressurePlatePos.y][self.pressurePlatePos.x] = self.pressurePlate
        end
    end

    function level:update(dt)
        self.gameTimer = self.gameTimer + dt
        local newZ = player:update(dt, self.collisionMap, self.tileSize, self.gameTimer, self.currentRunActions, self.playerCurrentZ)
        self.playerCurrentZ = newZ
        ghost:update(dt, self.gameTimer)
        enemy:update(dt, player, ghost)

        if #self.spikePositions > 0 then
            self.spikeTimer = self.spikeTimer + dt
            local interval = (self.spikeFrame == 1) and 0.75 or 0.25
            if self.spikeTimer >= interval then
                self.spikeTimer = self.spikeTimer - interval
                if self.spikeFrame == 3 then self.spikeDirection = -1
                elseif self.spikeFrame == 1 then self.spikeDirection = 1 end
                self.spikeFrame = self.spikeFrame + self.spikeDirection
                for _, pos in ipairs(self.spikePositions) do
                    self.tileLayers[pos.layer][pos.y][pos.x] = self['spike' .. self.spikeFrame]
                end
            end

            local p_tx, p_ty = player.gridX, player.gridY
            for _, pos in ipairs(self.spikePositions) do
                if p_tx == pos.x and p_ty == pos.y and not player.isDead then
                    local tid = self.tileLayers[pos.layer][pos.y][pos.x]
                    if tid == self.spike2 or tid == self.spike3 then
                        player:die('normal')
                        break
                    end
                end
            end
            for _, pos in ipairs(self.spikePositions) do
                if ghost.active and ghost.gridX == pos.x and ghost.gridY == pos.y then
                    local tid = self.tileLayers[pos.layer][pos.y][pos.x]
                    if tid == self.spike2 or tid == self.spike3 then
                        ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, self.lastRunActions)
                        break
                    end
                end
            end
        end

        if self.doorPos then
            if self.buttonPos and not self.buttonWasPressed then
                local onButton = (player.gridX == self.buttonPos.x and player.gridY == self.buttonPos.y)
                    or (ghost.active and ghost.gridX == self.buttonPos.x and ghost.gridY == self.buttonPos.y)
                if onButton then
                    self.buttonWasPressed = true
                end
            end
            if self.pressurePlatePos then
                if self.doorTimer == 0 then
                    self.pressurePlateWasPressed = false
                end
                local playerOnPlate = player.gridX == self.pressurePlatePos.x and player.gridY == self.pressurePlatePos.y
                local ghostOnPlate = ghost.active and ghost.gridX == self.pressurePlatePos.x and ghost.gridY == self.pressurePlatePos.y
                local onPlate = playerOnPlate or ghostOnPlate
                if onPlate and not self.pressurePlateWasPressed then
                    self.pressurePlateWasPressed = true
                    self.doorTimer = self.doorOpenDuration
                end
                local plLayer = self.pressurePlatePos.layer
                local isPressed = self.doorTimer > 0
                self.tileLayers[plLayer][self.pressurePlatePos.y][self.pressurePlatePos.x] = isPressed and self.pressedPressurePlate or self.pressurePlate
            end
            if self.doorTimer > 0 then
                self.doorTimer = math.max(0, self.doorTimer - dt)
            end
            local shouldDoorBeOpen = self.buttonWasPressed or self.doorTimer > 0
             local dl = self.doorPos.layer
             if shouldDoorBeOpen and not self.isDoorOpen then
                 self.isDoorOpen = true
                 self.tileLayers[dl][self.doorPos.y][self.doorPos.x] = 0
                 self.collisionMap[self.doorPos.y][self.doorPos.x] = 0
             elseif not shouldDoorBeOpen and self.isDoorOpen then
                 self.isDoorOpen = false
                 self.tileLayers[dl][self.doorPos.y][self.doorPos.x] = self.doorBlock
                 self.collisionMap[self.doorPos.y][self.doorPos.x] = 1
             end
            if self.buttonPos then
                local btnLayer = self.buttonPos.layer
                self.tileLayers[btnLayer][self.buttonPos.y][self.buttonPos.x] = self.buttonWasPressed and self.pressedButton or self.button
            end
        end

        local p_tx, p_ty = player.gridX, player.gridY
        if not player.isDead and self.tileLayers[3][p_ty] and self.tileLayers[3][p_ty][p_tx] == self.chasm then
            player:die('pitfall')
        end

        if not player.isDead and not player.moving and self.levelUpPos and self.isDoorOpen then
            if player.gridX == self.levelUpPos.x and player.gridY == self.levelUpPos.y then
                return self.nextLevelKey
            end
        end

        if player:getIsReadyToRespawn() then
            self:startNewRun()
        end
    end

    function level:draw()
        local mapPixelWidth = self.mapWidthInTiles * self.tileSize
        local mapPixelHeight = self.mapHeightInTiles * self.tileSize
        local screenWidth, screenHeight = love.graphics.getDimensions()

        self.scale = math.min(screenWidth / mapPixelWidth, screenHeight / mapPixelHeight)
        self.offsetX = (screenWidth - (mapPixelWidth * self.scale)) / 2
        self.offsetY = (screenHeight - (mapPixelHeight * self.scale)) / 2

        love.graphics.push()
        love.graphics.translate(self.offsetX, self.offsetY)
        love.graphics.scale(self.scale, self.scale)

        for _, layer in ipairs(self.tileLayers) do
            for y = 1, self.mapHeightInTiles do
                for x = 1, self.mapWidthInTiles do
                    local tid = layer[y][x]
                    if tid ~= 0 then
                        local info = self.tileQuads[tid]
                        if info then
                            love.graphics.draw(info.image, info.quad,
                                (x - 1) * self.tileSize, (y - 1) * self.tileSize)
                        end
                    end
                end
            end
        end

        ghost:draw()
        player:draw()
        enemy:draw()

        love.graphics.pop()
        local sw, sh = love.graphics.getDimensions()
        local px, py = player.gridX, player.gridY
        local currZ = (self.collisionMap[py] and self.collisionMap[py][px]) or 0
        local dx, dy = 0, 0
        if player.facingRow == 1 then dy = 1
        elseif player.facingRow == 4 then dy = -1
        elseif player.facingRow == 6 then dx = player.flipH and -1 or 1
        end
        local nx, ny = px + dx, py + dy
        local nextZ = (self.collisionMap[ny] and self.collisionMap[ny][nx]) or 0
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print('Curr Z: '..currZ..'  Next Z: '..nextZ, 10, sh - 20)
    end

    return level
end

return {
    level1 = createLevel(level1Data, 'level2'),
    level2 = createLevel(level2Data, 'level3'),
    level3 = createLevel(level3Data, nil),
}
