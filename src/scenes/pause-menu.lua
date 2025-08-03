local pauseMenu = {}

local button = require 'src.ui.components.button'
local label  = require 'src.ui.components.label'
local Game   = require 'src.Game'
local settings   = require 'src.settings'

local menuMusic = nil  -- holds the music source

function pauseMenu:enter(previous, ...)
    if Game.pause then
        Game:pause()
    end
  -- Load music if not already loaded
  if not menuMusic then
    menuMusic = love.audio.newSource("assets/main_menu.mp3", "stream")
    menuMusic:setVolume(settings.musicVolume)
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
            roomy:push(require 'src.scenes.settingsMenu')
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

function pauseMenu:update(dt)
  menu:update()
end

function pauseMenu:keypressed(key)
  -- handle key input if needed
end

function pauseMenu:leave(next, ...)
  if menuMusic then
    menuMusic:stop()
  end
end

function pauseMenu:pause(next, ...)
  if menuMusic then
    menuMusic:pause()
  end
end

function pauseMenu:resume(previous, ...)
  if menuMusic then
    menuMusic:setVolume(settings.musicVolume)
    menuMusic:play()
  end
end

function pauseMenu:draw()
    Game:draw() -- draw game in background

    -- draw translucent overlay
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- reset color and draw UI
    love.graphics.setColor(1, 1, 1)
    menu:draw()
end

return pauseMenu
