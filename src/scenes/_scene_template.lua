local _sceneName = {}

-- `previous` - the previously active scene, or `false` if there was no previously active scene
-- `...` - additional arguments passed to `manager.enter` or `manager.push`
function _sceneName:enter(previous, ...)
  -- set up the level
end

function _sceneName:update(dt)
  -- update entities
end

function _sceneName:keypressed(key)
  -- someone pressed a key
end

function _sceneName:mousepressed(x, y, button, istouch, presses)
  -- someone clicked the mouse
end

-- `next` - the scene that will be active next
-- `...` - additional arguments passed to `manager.enter` or `manager.pop`
function _sceneName:leave(next, ...)
  -- destroy entities and cleanup resources
end

-- `next` - the scene that was pushed on top of this scene
-- `...` - additional arguments passed to `manager.push`
function _sceneName:pause(next, ...)
  -- destroy entities and cleanup resources
end

-- `previous` - the scene that was popped
-- `...` - additional arguments passed to `manager.pop`
function _sceneName:resume(previous, ...)
  -- Called when a scene is popped and this scene becomes active again.
end

function _sceneName:draw()
  -- draw the level
end

return _sceneName