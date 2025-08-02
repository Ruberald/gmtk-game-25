-- src/scenes/settingsMenu.lua
local settingsMenu = {}

local button = require 'src.ui.components.button'
local label  = require 'src.ui.components.label'
local settings = require 'src.settings'
local Game = require 'src.Game'

local musicVolumeLabel

function settingsMenu:enter(previous)
  -- UI container
  menu = badr { column = true, gap = 10 }

  -- Music volume controls
  musicVolumeLabel = label({ text = "Music Volume: " .. math.floor(settings.musicVolume * 100) .. "%", width = 200 })

  local function updateVolumeLabel()
    musicVolumeLabel.text = "Music Volume: " .. math.floor(settings.musicVolume * 100) .. "%"
    if Game.menuMusic then
      Game.menuMusic:setVolume(settings.musicVolume)
    end
  end

  menu = menu
    + label({ text = "Settings", width = 200 })
    + musicVolumeLabel
    + button {
        text = "Volume -",
        width = 95,
        onClick = function()
          settings.musicVolume = math.max(0, settings.musicVolume - 0.1)
          updateVolumeLabel()
        end
      }
    + button {
        text = "Volume +",
        width = 95,
        onClick = function()
          settings.musicVolume = math.min(1, settings.musicVolume + 0.1)
          updateVolumeLabel()
        end
      }
    + button {
        text = love.window.getFullscreen() and "Fullscreen: On" or "Fullscreen: Off",
        width = 200,
        onClick = function(self)
          local newValue = not love.window.getFullscreen()
          love.window.setFullscreen(newValue)
          self.text = newValue and "Fullscreen: On" or "Fullscreen: Off"
        end
      }
    + button {
        text = "Back",
        width = 200,
        onClick = function()
          roomy:pop()
        end
      }

  -- Center the menu
  menu:updatePosition(
    love.graphics.getWidth() * 0.5 - menu.width * 0.5,
    love.graphics.getHeight() * 0.5 - menu.height * 0.5
  )
end

function settingsMenu:update(dt)
  menu:update(dt)
end

function settingsMenu:draw()
  menu:draw()
end

return settingsMenu
