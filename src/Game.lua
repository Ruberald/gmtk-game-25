local Game = {}

local levels = require 'src.scenes.levels'
local settings = require 'src.settings'
local lore = require 'src.scenes.lore'

Game.currentLevel = levels.level1
Game.state = "lore" -- or "playing"

-- Music sources
local track1, track2
local currentTrack = 1

local function playCurrentTrack()
    if currentTrack == 1 and track1 then
        track1:play()
    elseif currentTrack == 2 and track2 then
        track2:play()
    end
end

function Game:enter(previous, ...)
    local resetHistory = previous ~= Game
    lore:load()
    self.state = "lore"
    self:load(resetHistory)
end

function Game:load(resetHistory)
    if resetHistory then
        self.currentLevel.lastRunActions = nil
        self.currentLevel.currentRunActions = {}
    end
    self.currentLevel:load()
end

function Game:update(dt)
    if self.state == "lore" then
        lore:update(dt)
        if lore.done then
            self.state = "playing"
            playCurrentTrack()
        end
        return
    end

    if not HasShownDeathLore and HasPlayerDiedOnce then
        HasShownDeathLore = true
        roomy:push(require 'src.scenes.deathLore')
        return
    end

    if not HasShownGhostLore and HasGhostDiedOnce then
        HasShownGhostLore = true
        roomy:push(require 'src.scenes.ghostLore')
        return
    end

    -- Music switching logic
    if track1 and track2 then
        if currentTrack == 1 and not track1:isPlaying() then
            track2:setVolume(settings.musicVolume)
            track2:play()
            currentTrack = 2
        elseif currentTrack == 2 and not track2:isPlaying() then
            track1:setVolume(settings.musicVolume)
            track1:play()
            currentTrack = 1
        end
    end

    -- Update level
    local nextLevelKey = self.currentLevel:update(dt)
    if nextLevelKey then
        if nextLevelKey == "end" then
            roomy:push(require 'src.scenes.finalLore')  -- push final lore scene
            return
        end
        self.currentLevel = levels[nextLevelKey]
        self.currentLevel:load()
    end

    -- Load music now if transitioning out of level1 and music not yet loaded
    if not track1 and HasShownGhostLore then
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

function Game:draw()
    if self.state == "lore" then
        lore:draw()
    else
        self.currentLevel:draw()
    end
end

function Game:keypressed(key)
    if self.state == "lore" then
        lore:keypressed(key)
    end
end

function Game:mousepressed(x, y, button)
    if self.state == "lore" then
        lore:mousepressed(x, y, button)
    end
end

return Game
