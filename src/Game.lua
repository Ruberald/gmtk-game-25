-- src/Game.lua
local Game = {}

local levels = require 'src.scenes.levels'

Game.currentLevel = levels.level2

function Game:load(resetHistory)
    if resetHistory then
        self.currentLevel.lastRunActions = nil
        self.currentLevel.currentRunActions = {}
    end
    self.currentLevel:load()
end

function Game:update(dt)
    local nextLevelKey = self.currentLevel:update(dt)
    if nextLevelKey then
        self.currentLevel = levels[nextLevelKey]
        self.currentLevel:load()
        return
    end
end

function Game:draw()
    self.currentLevel:draw()
end

return Game
