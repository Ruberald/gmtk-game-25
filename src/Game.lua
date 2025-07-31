-- src/Game.lua
local Game = {}

local levels = require 'src.scenes.levels'

Game.currentLevel = levels.level1

function Game:load()
    self.currentLevel:load()
end

function Game:update(dt)
    self.currentLevel:update(dt)
end

function Game:draw()
    self.currentLevel:draw()
end

return Game
