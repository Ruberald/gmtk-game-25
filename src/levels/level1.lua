local player = require 'src.entities.player'
local ghost = require 'src.entities.ghost'

local level1 = {
    bg = nil,
    tileSize = 32,

    mapData = {
        {90, 90, 1, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 1, 1, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 1, 1, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 1, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    },

    tilesetImage = nil,
    tileQuads = {},

    mapWidthInTiles = 0,
    mapHeightInTiles = 0,

    gameTimer = 0,
    currentRunActions = {},
    lastRunActions = nil
}

function level1:enter()
    self.tilesetImage = love.graphics.newImage('assets/bg-tileset.png')

    self.mapHeightInTiles = #self.mapData
    self.mapWidthInTiles = #self.mapData[1]

    local tilesetImageWidth = self.tilesetImage:getWidth()
    local tilesetImageHeight = self.tilesetImage:getHeight()
    local tilesPerRow = math.floor(tilesetImageWidth / self.tileSize)
    local tilesPerCol = math.floor(tilesetImageHeight / self.tileSize)

    local tileID = 1
    for y = 0, tilesPerCol - 1 do
        for x = 0, tilesPerRow - 1 do
            self.tileQuads[tileID] = love.graphics.newQuad(
                x * self.tileSize, y * self.tileSize,
                self.tileSize, self.tileSize,
                tilesetImageWidth, tilesetImageHeight
            )
            tileID = tileID + 1
        end
    end

    player:load()
    ghost:load() 

    self:startNewRun()
end

function level1:startNewRun()
    if #self.currentRunActions > 0 then
        self.lastRunActions = self.currentRunActions
    end

    self.gameTimer = 0
    self.currentRunActions = {}

    player:reset(1, 1, self.tileSize)

    if self.lastRunActions then
        ghost:reset(1, 1, self.tileSize, self.lastRunActions)
    end
end

function level1:checkPlayerDeath()
    if player:GetIsDead() then
        self:startNewRun()
    end
end

function level1:update(dt)
    self.gameTimer = self.gameTimer + dt

    player:update(dt, self.mapData, self.tileSize, self.gameTimer, self.currentRunActions)
    ghost:update(dt, self.gameTimer)

    self:checkPlayerDeath()
end

function level1:draw()
    for y = 1, self.mapHeightInTiles do
        for x = 1, self.mapWidthInTiles do
            local tileID = self.mapData[y][x]
            local tileQuad = self.tileQuads[tileID]
            if tileQuad then
                love.graphics.draw(
                    self.tilesetImage,
                    tileQuad,
                    (x - 1) * self.tileSize,
                    (y - 1) * self.tileSize
                )
            end
        end
    end

    ghost:draw()
    player:draw()

    love.graphics.print("Player Grid X: " .. player.gridX, 10, 10)
    love.graphics.print("Player Grid Y: " .. player.gridY, 10, 30)
    love.graphics.print("Press 'space' to die and start a new run.", 10, 50)
end

return level1