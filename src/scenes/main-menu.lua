local mainMenu = {}
local button = require 'src.ui.components.button'
local label  = require 'src.ui.components.label'
local Game   = require 'src.Game'
local settingsMenu   = require 'src.scenes.settingsMenu'
local credits   = require 'src.scenes.credits'
local settings = require 'src.settings'
local splash = require 'src.scenes.splash'

local music = nil

function mainMenu:enter()
  if not music then
    music = love.audio.newSource("assets/main_menu.mp3", "stream")
    music:setLooping(true)
    music:setVolume(settings.musicVolume)
  end
  love.audio.play(music)

  local hintFont = love.graphics.newFont("assets/font.ttf", 20)

  menu = badr { column = true, gap = 10 }
    + label({ text = "One More Loop", width = 200 })
    + button {
        text = "Start Game",
        width = 200,
        font = hintFont,
        onClick = function()
            roomy:enter(Game)
        end
      }
    + button {
        text = "Settings",
        width = 200,
        font = hintFont,
        onClick = function()
          roomy:push(settingsMenu)
        end
      }
    + button {
        text = "Credits",
        width = 200,
        font = hintFont,
        onClick = function()
          roomy:push(credits)
        end
      }
    + button {
        text = "Quit",
        width = 200,
        font = hintFont,
        onClick = function()
          love.event.quit()
        end
      }

  menu:updatePosition(
    love.graphics.getWidth() * 0.5 - menu.width * 0.5,
    love.graphics.getHeight() * 0.5 - menu.height * 0.5
  )
end

function mainMenu:update(dt)
  menu:update(dt)
end

function mainMenu:draw()
    splash:draw()
    -- Draw translucent background (black with 50% opacity)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- Reset color and draw menu UI
    love.graphics.setColor(1, 1, 1)
    menu:draw()
end

function mainMenu:leave()
  if music then music:stop() end
end

return mainMenu
