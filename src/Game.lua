-- src/Game.lua
local Game = {}

local levels = require 'src.scenes.levels'
local settings = require 'src.settings'

Game.currentLevel = levels.level4

-- Music sources
local track1, track2
local currentTrack = 1

function Game:enter(previous, ...)
    local resetHistory = previous ~= Game
    self:load(resetHistory)
end

function Game:load(resetHistory)
    if resetHistory then
        self.currentLevel.lastRunActions = nil
        self.currentLevel.currentRunActions = {}
    end
    self.currentLevel:load()

    -- Load music once
    if not track1 then
        track1 = love.audio.newSource("assets/levels1.mp3", "stream")
        track2 = love.audio.newSource("assets/levels2.mp3", "stream")
        track1:setLooping(false)
        track2:setLooping(false)
        track1:setVolume(settings.musicVolume)
        track2:setVolume(settings.musicVolume)
        track1:play()
        currentTrack = 1
    end
end

function Game:update(dt)
    -- Music switching logic
    if currentTrack == 1 and not track1:isPlaying() then
        track2:play()
        currentTrack = 2
    elseif currentTrack == 2 and not track2:isPlaying() then
        track1:play()
        currentTrack = 1
    end

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

function Game:pause(next, ...)
    -- Pause current track
    if currentTrack == 1 and track1 and track1:isPlaying() then
        track1:setVolume(settings.musicVolume)
        track1:pause()
    elseif currentTrack == 2 and track2 and track2:isPlaying() then
        track2:setVolume(settings.musicVolume)
        track2:pause()
    end
end

function Game:resume(previous, ...)
    -- Resume current track
    if currentTrack == 1 and track1 then
        track1:setVolume(settings.musicVolume)
        track1:play()
    elseif currentTrack == 2 and track2 then
        track2:setVolume(settings.musicVolume)
        track2:play()
    end
end

function Game:leave(next, ...)
    if track1 then track1:stop() end
    if track2 then track2:stop() end
    track1 = nil
    track2 = nil
end

return Game
