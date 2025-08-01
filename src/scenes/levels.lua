local level1Data = require 'src.levels.level1'
local level2Data = require 'src.levels.level2'
local level3Data = require 'src.levels.level3'
local player = require 'src.entities.player'
local ghost = require 'src.entities.ghost'

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
    }

    function level:load()
        self.tileLayers = {}
        self.collisionMap = {}
        self.tileQuads = {}
        self.ladderIDs = {}

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

        player:load()
        ghost:load()
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
        player:reset(self.playerStartX, self.playerStartY, self.tileSize)
        if self.lastRunActions then
            ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, self.lastRunActions)
        end
    end

    function level:update(dt)
        self.gameTimer = self.gameTimer + dt
        player:update(dt, self.collisionMap, self.tileSize, self.gameTimer, self.currentRunActions)
        ghost:update(dt, self.gameTimer)

        local tx, ty = player.gridX, player.gridY
        if not player.isDead and self.tileLayers[3][ty] and self.tileLayers[3][ty][tx] == 67 then
            print("player should die")
            player:die('pitfall')
        end

        if not player.isDead and not player.moving and self.tileLayers[3][ty] and self.tileLayers[3][ty][tx] == 34 then
            print("Player reached the door! Loading next level: " .. tostring(self.nextLevelKey))
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

        love.graphics.pop()
    end

    return level
end

return {
    level1 = createLevel(level1Data, 'level2'),
    level2 = createLevel(level2Data, 'level3'),
    level2 = createLevel(level3Data, nil),
}
