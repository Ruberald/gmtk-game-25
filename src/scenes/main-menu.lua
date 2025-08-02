local mainMenu = {}

local button = require 'src.ui.components.button'
local label  = require 'src.ui.components.label'
local Game   = require 'src.Game'

local menuMusic = nil  -- holds the music source

function mainMenu:enter(previous, ...)
    if Game.pause then
        Game:pause()
    end
  -- Load music if not already loaded
  if not menuMusic then
    menuMusic = love.audio.newSource("assets/main_menu.mp3", "stream")
    menuMusic:setLooping(true)
  end
  love.audio.play(menuMusic)

  -- UI setup
  menu = badr { column = true, gap = 10 }
      + label({ text = "Main Menu", width = 200 })
      + button {
        text = 'Reset Level',
        width = 200,
        onClick = function()
          Game:load(true)
          roomy:pop()
        end
      }
      + button {
        text = 'Settings',
        width = 200,
        onClick = function()
          local success = love.window.showMessageBox("Settings", "Not implemented", "info")
          if success then print("Settings message box closed") end
        end
      }
      + button {
        text = 'Credits',
        width = 200,
        onClick = function()
          roomy:push(scenes.credits)
        end
      }
      + button {
        text = 'Return',
        width = 200,
        onClick = function()
          roomy:pop()
        end
      }
      + button {
        text = 'Quit',
        width = 200,
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
  menu:update()
end

function mainMenu:keypressed(key)
  -- handle key input if needed
end

function mainMenu:leave(next, ...)
  if menuMusic then
    menuMusic:stop()
  end
end

function mainMenu:pause(next, ...)
  if menuMusic then
    menuMusic:pause()
  end
end

function mainMenu:resume(previous, ...)
  if menuMusic then
    menuMusic:play()
  end
end

function mainMenu:draw()
  menu:draw()
end

return mainMenu
