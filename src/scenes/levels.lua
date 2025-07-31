local level1Data = require 'src.levels.level1'
local player = require 'src.entities.player'
local ghost = require 'src.entities.ghost'

local function createLevel(levelData)
    local level = {
        tileSize = levelData.tileSize,
        mapData = levelData.mapData,
        playerStartX = levelData.playerStartX or 1,
        playerStartY = levelData.playerStartY or 1,

        tilesetImage = nil,
        tileQuads = {},
        mapWidthInTiles = 0,
        mapHeightInTiles = 0,

        gameTimer = 0,
        currentRunActions = {},
        lastRunActions = nil,
    }

    function level:load()
        self.tilesetImage = love.graphics.newImage('assets/bg-tileset.png')
        self.mapHeightInTiles = #self.mapData
        self.mapWidthInTiles = #self.mapData[1]

        local imgW, imgH = self.tilesetImage:getWidth(), self.tilesetImage:getHeight()
        local tilesPerRow = math.floor(imgW / self.tileSize)
        local tilesPerCol = math.floor(imgH / self.tileSize)

        local tileID = 1
        for y = 0, tilesPerCol - 1 do
            for x = 0, tilesPerRow - 1 do
                self.tileQuads[tileID] = love.graphics.newQuad(
                    x * self.tileSize, y * self.tileSize,
                    self.tileSize, self.tileSize,
                    imgW, imgH
                )
                tileID = tileID + 1
            end
        end

        player:load()
        ghost:load()

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

    function level:checkPlayerDeath()
        if player:getIsDead() then
            self:startNewRun()
        end
    end

    function level:update(dt)
        self.gameTimer = self.gameTimer + dt

        player:update(dt, self.mapData, self.tileSize, self.gameTimer, self.currentRunActions)
        ghost:update(dt, self.gameTimer)

        self:checkPlayerDeath()
    end

    function level:draw()
        for y = 1, self.mapHeightInTiles do
            for x = 1, self.mapWidthInTiles do
                local tileID = self.mapData[y][x]
                local quad = self.tileQuads[tileID]
                if quad then
                    love.graphics.draw(self.tilesetImage, quad, (x - 1) * self.tileSize, (y - 1) * self.tileSize)
                end
            end
        end

        love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
        for y = 0, self.mapHeightInTiles do
            love.graphics.line(0, y * self.tileSize, self.mapWidthInTiles * self.tileSize, y * self.tileSize)
        end
        for x = 0, self.mapWidthInTiles do
            love.graphics.line(x * self.tileSize, 0, x * self.tileSize, self.mapHeightInTiles * self.tileSize)
        end
        love.graphics.setColor(1, 1, 1, 1)

        ghost:draw()
        player:draw()
    end

    return level
end

return {
    level1 = createLevel(level1Data)
    
}
