-- src/Game.lua
local Game = {}

local player = require 'src.entities.player'
local levels = require 'src.scenes.levels'

Game.currentLevel = levels.level1

function Game:load()
  self.currentLevel:load()
  player:load()
  player:reset(1, 1, self.currentLevel.tileSize)
end

function Game:update(dt)
  player:update(dt, self.currentLevel.mapData, self.currentLevel.tileSize)
end

function Game:draw()
  self.currentLevel:draw()
  player:draw()

  love.graphics.print("Player Grid X: " .. player.gridX, 10, 10)
  love.graphics.print("Player Grid Y: " .. player.gridY, 10, 30)
end

return Game

