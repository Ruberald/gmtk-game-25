local level1Data = require 'src.levels.level1'

local function createLevel(levelData)
  local level = {
    tileSize = levelData.tileSize,
    mapData = levelData.mapData,

    tilesetImage = nil,
    tileQuads = {},
    mapWidthInTiles = 0,
    mapHeightInTiles = 0,
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
  end

  return level
end

return {
  level1 = createLevel(level1Data)
}
