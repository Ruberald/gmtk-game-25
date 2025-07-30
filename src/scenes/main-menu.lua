local mainMenu = {}

local button = require 'src.ui.components.button'
local label  = require 'src.ui.components.label'

-- `previous` - the previously active scene, or `false` if there was no previously active scene
-- `...` - additional arguments passed to `manager.enter` or `manager.push`
function mainMenu:enter(previous, ...)
  -- set up the level
  love.graphics.setBackgroundColor(colors.rgbForGraphics(colors.Slate800))

  local clicks = 0
  menu = badr { column = true, gap = 10 }
      + label({ text = "Main Menu", width = 200 })
      + button {
        text = 'New game',
        width = 200,
        onHover = function()
          print 'mouse entered'
          return function()
            print('mouse exited')
          end
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
      + button { text = 'Quit', width = 200, onClick = function() love.event.quit() end }
      + button {
        text = 'Clicked: 0',
        width = 200,
        onClick = function(self)
          clicks = clicks + 1
          self.text = 'Clicked: ' .. clicks
        end
      }
      + button {
        text = 'Click to remove',
        onClick = function(self)
          self.parent = self.parent - self
          love.mouse.setCursor()
        end
      }

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
