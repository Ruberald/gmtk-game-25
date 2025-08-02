local key = {
    x = 0, y = 0,
    gridX = 1, gridY = 1,
    tileSize = 16,
    picked = false,

    image = nil,
}

function key:load(x, y, tileSize)
    self.gridX = x
    self.gridY = y
    self.tileSize = tileSize
    self.x = (x - 1) * tileSize + tileSize / 2
    self.y = (y - 1) * tileSize + tileSize / 2
    self.image = love.graphics.newImage("assets/key.png")
    self.picked = false
end

function key:update(player)
    if not self.picked and player.gridX == self.gridX and player.gridY == self.gridY then
        self.picked = true
        player.hasKey = true
        -- Optional: play sound, animation, etc.
    end
end

function key:draw()
    if not self.picked then
        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.tileSize / 2, self.tileSize / 2)
    end
end

return key

