local mainMenu = {}

local button = require 'src.ui.components.button'
local label  = require 'src.ui.components.label'
local Game   = require 'src.Game'

-- `previous` - the previously active scene, or `false` if there was no previously active scene
-- `...` - additional arguments passed to `manager.enter` or `manager.push`
function mainMenu:enter(previous, ...)
  -- set up the level

  local clicks = 0
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
      + button { text = 'Settings', width = 200, onClick = function()
        local success = love.window.showMessageBox("Settings", "Not implemented", "info")
        if success then
          print("Settings message box closed")
        end
      end }
      + button { text = 'Credits', width = 200, onClick = function()
          roomy:push(scenes.credits)
        end }
      + button { text = 'Return', width = 200, onClick = function()
          roomy:pop()
         end }
      + button { text = 'Quit', width = 200, onClick = function() love.event.quit() end }

  menu:updatePosition(
    love.graphics.getWidth() * 0.5 - menu.width * 0.5,
    love.graphics.getHeight() * 0.5 - menu.height * 0.5
  )
end

function mainMenu:update(dt)
  -- update entities
  menu:update()
end

function mainMenu:keypressed(key)
  -- someone pressed a key
end

-- `next` - the scene that will be active next
-- `...` - additional arguments passed to `manager.enter` or `manager.pop`
function mainMenu:leave(next, ...)
  -- destroy entities and cleanup resources
end

-- `next` - the scene that was pushed on top of this scene
-- `...` - additional arguments passed to `manager.push`
function mainMenu:pause(next, ...)
  -- destroy entities and cleanup resources
end

-- `previous` - the scene that was popped
-- `...` - additional arguments passed to `manager.pop`
function mainMenu:resume(previous, ...)
  -- Called when a scene is popped and this scene becomes active again.
end

function mainMenu:draw()
  -- draw the level
  menu:draw()
end

return mainMenu
