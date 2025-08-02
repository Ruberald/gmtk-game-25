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

        playerStartX = 7,
        playerStartY = 9,

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
        spikeInterval = 0.25,
        spikeDirection = 1,

        -- interactable object state
        doorPos = nil,
        buttonPos = nil,
        pressurePlatePos = nil,
        isDoorOpen = false,
        doorTimer = 0,
        doorOpenDuration = 1,
        buttonWasPressed = false,
    }

    function level:load()
        self.tileLayers = {}
        self.collisionMap = {}
        self.tileQuads = {}
        self.ladderIDs = {}
        self.doorPos = nil
        self.buttonPos = nil

        for _, ts in ipairs(tiledMapData.tilesets) do
            local image = love.graphics.newImage('assets/' .. ts.name .. '.png')
            local imgW, imgH = image:getWidth(), image:getHeight()
            local cols = math.floor(imgW / self.tileSize)
            local rows = math.floor(imgH / self.tileSize)
            local id = ts.firstgid
            local isLadder = (ts.name == 'ladder8')
            for ry = 0, rows - 1 do
                for cx = 0, cols - 1 do
                    self.tileQuads[id] = { image = image, quad = love.graphics.newQuad(
                        cx * self.tileSize, ry * self.tileSize,
                        self.tileSize, self.tileSize,
                        imgW, imgH
                    ) }
                    if isLadder then self.ladderIDs[id] = true end
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
                table.insert(self.tileLayers, layer2D)
            end
        end

        for y = 1, self.mapHeightInTiles do
            self.collisionMap[y] = {}
            for x = 1, self.mapWidthInTiles do
                local tid = self.tileLayers[2][y][x]
                self.collisionMap[y][x] = (tid == 0) and 0 or 1
            end
        end

        local foregroundLayer = self.tileLayers[3]
        for y = 1, self.mapHeightInTiles do
            for x = 1, self.mapWidthInTiles do
                if foregroundLayer[y][x] == self.closedDoor then
                    -- door detection
                    self.doorPos = { x = x, y = y }
                    self.collisionMap[y][x] = 1
                elseif foregroundLayer[y][x] == self.button then
                    self.buttonPos = { x = x, y = y }
                elseif foregroundLayer[y][x] == self.pressurePlate then
                    self.pressurePlatePos = { x = x, y = y }
                end
            end
        end

        -- initialize spikes animation
        self.spikePositions = {}
        for y = 1, self.mapHeightInTiles do
            for x = 1, self.mapWidthInTiles do
                if self.tileLayers[3][y][x] == self.spike1 then
                    table.insert(self.spikePositions, { x = x, y = y })
                end
            end
        end
        self.spikeTimer = 0
        self.spikeFrame = 1

        player:load()
        ghost:load()

        enemy:load()

        self.lastRunActions = nil
        ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, nil)
        self:startNewRun()
    end

    function level:startNewRun()
        if #self.currentRunActions > 0 then
            self.lastRunActions = self.currentRunActions
        end
        self.gameTimer = 0
        self.currentRunActions = {}
        enemy:reset(10, 10, self.tileSize)
        player:reset(self.playerStartX, self.playerStartY, self.tileSize)
        if self.lastRunActions then
            ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, self.lastRunActions)
        end

        self.isDoorOpen = false
        self.doorTimer = 0
        self.buttonWasPressed = false
        if self.doorPos then
            self.tileLayers[3][self.doorPos.y][self.doorPos.x] = self.closedDoor
            self.collisionMap[self.doorPos.y][self.doorPos.x] = 1
        end
        if self.buttonPos then
            self.tileLayers[3][self.buttonPos.y][self.buttonPos.x] = self.button
        end
        if self.pressurePlatePos then
            self.tileLayers[3][self.pressurePlatePos.y][self.pressurePlatePos.y] = self.pressurePlate
            
        end
    end

    function level:update(dt)
        self.gameTimer = self.gameTimer + dt
        player:update(dt, self.collisionMap, self.tileSize, self.gameTimer, self.currentRunActions)
        ghost:update(dt, self.gameTimer)
        enemy:update(dt, player, ghost)

        -- spikes animation and collision
        self.spikeTimer = self.spikeTimer + dt
        if self.spikeTimer >= self.spikeInterval then
            self.spikeTimer = self.spikeTimer - self.spikeInterval
            -- reverse direction at ends for ping-pong
            if self.spikeFrame == 3 then
                self.spikeDirection = -1
            elseif self.spikeFrame == 1 then
                self.spikeDirection = 1
            end
            self.spikeFrame = self.spikeFrame + self.spikeDirection
            for _, pos in ipairs(self.spikePositions) do
                self.tileLayers[3][pos.y][pos.x] = self['spike' .. self.spikeFrame]
            end
        end
        local p_tx, p_ty = player.gridX, player.gridY
        local current = self.tileLayers[3][p_ty] and self.tileLayers[3][p_ty][p_tx]
        if not player.isDead and (current == self.spike1 or current == self.spike2 or current == self.spike3) then
            player:die('normal')
        end
        -- ghost spike collision: reset ghost but keep its action list
        local g_tx, g_ty = ghost.gridX, ghost.gridY
        local g_current = self.tileLayers[3][g_ty] and self.tileLayers[3][g_ty][g_tx]
        if ghost.active and not ghost.isFinished and (g_current == self.spike1 or g_current == self.spike2 or g_current == self.spike3) then
            ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, self.lastRunActions)
        end

        if self.buttonPos and self.doorPos then
            local playerOnButton = player.gridX == self.buttonPos.x and player.gridY == self.buttonPos.y
            local ghostOnButton = ghost.active and not ghost.isFinished and ghost.gridX == self.buttonPos.x and ghost.gridY == self.buttonPos.y
            local anyoneOnButton = playerOnButton or ghostOnButton

            local playerOnPlate = self.pressurePlatePos and player.gridX == self.pressurePlatePos.x and player.gridY == self.pressurePlatePos.y
            local ghostOnPlate = self.pressurePlatePos and ghost.active and not ghost.isFinished and ghost.gridX == self.pressurePlatePos.x and ghost.gridY == self.pressurePlatePos.y
            local anyoneOnPlate = playerOnPlate or ghostOnPlate

           if not anyoneOnButton then self.buttonWasPressed = false end
            if anyoneOnButton and not self.buttonWasPressed then
                self.buttonWasPressed = true
                self.doorTimer = self.doorOpenDuration 
            end
            if self.doorTimer > 0 then self.doorTimer = self.doorTimer - dt end

            local shouldDoorBeOpen = (self.doorTimer > 0) or anyoneOnPlate

            if shouldDoorBeOpen and not self.isDoorOpen then
                self.isDoorOpen = true
                self.tileLayers[3][self.doorPos.y][self.doorPos.x] = self.openDoor
                self.collisionMap[self.doorPos.y][self.doorPos.x] = 0
            elseif not shouldDoorBeOpen and self.isDoorOpen then
                self.isDoorOpen = false
                self.tileLayers[3][self.doorPos.y][self.doorPos.x] = self.closedDoor
                self.collisionMap[self.doorPos.y][self.doorPos.x] = 1 
            end

            if self.buttonPos then
                self.tileLayers[3][self.buttonPos.y][self.buttonPos.x] = (self.doorTimer > 0) and self.pressedButton or self.button
            end
            if self.pressurePlatePos then
                self.tileLayers[3][self.pressurePlatePos.y][self.pressurePlatePos.x] = anyoneOnPlate and self.pressedPressurePlate or self.pressurePlate
            end
        end

        local p_tx, p_ty = player.gridX, player.gridY
        if not player.isDead and self.tileLayers[3][p_ty] and self.tileLayers[3][p_ty][p_tx] == self.chasm then
            player:die('pitfall')
        end

        if not player.isDead and not player.moving and self.tileLayers[3][p_ty][p_tx] == self.levelUpTile and self.isDoorOpen then
            return self.nextLevelKey
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
    end

    return level
end

return {
    level1 = createLevel(level1Data, 'level2'),
    level2 = createLevel(level2Data, 'level3'),
    level3 = createLevel(level3Data, nil),
}
