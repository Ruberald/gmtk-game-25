local loadTimeStart = love.timer.getTime()

require 'globals'

function love.load()
  if CONFIG.window.icon ~= nil then
    love.window.setIcon(love.image.newImageData(CONFIG.window.icon))
  end

  roomy:hook()

  if CONFIG.showSplash then
    roomy:enter(scenes.splash)
  end

  if not CONFIG.showSplash then
    roomy:enter(scenes.mainMenu)
  end

  if DEBUG then
    local loadTimeEnd = love.timer.getTime()
    local loadTime = (loadTimeEnd - loadTimeStart)
    print(("Loaded game in %.3f seconds."):format(loadTime))
  end
end

-- useful for dev
lurker.postswap = function(fileName)
  love.event.quit("restart")
end

function love.update(dt)
  lurker.update()
end

function love.draw()
  local drawTimeStart = love.timer.getTime()
  -- call draw?
  local drawTimeEnd = love.timer.getTime()
  local drawTime = drawTimeEnd - drawTimeStart

  if DEBUG then
    love.graphics.push()
    local x, y = CONFIG.debug.stats.position.x, CONFIG.debug.stats.position.y
    local dy = CONFIG.debug.stats.lineHeight
    local stats = love.graphics.getStats()
    local memoryUnit = "KB"
    local ram = collectgarbage("count")
    local vram = stats.texturememory / 1024
    if not CONFIG.debug.stats.kilobytes then
      ram = ram / 1024
      vram = vram / 1024
      memoryUnit = "MB"
    end
    local info = {
      "FPS: " .. ("%3d"):format(love.timer.getFPS()),
      "DRAW: " .. ("%7.3fms"):format(lume.round(drawTime * 1000, .001)),
      "RAM: " .. string.format("%7.2f", lume.round(ram, .01)) .. memoryUnit,
      "VRAM: " .. string.format("%6.2f", lume.round(vram, .01)) .. memoryUnit,
      "Draw calls: " .. stats.drawcalls,
      "Images: " .. stats.images,
      "Canvases: " .. stats.canvases,
      "\tSwitches: " .. stats.canvasswitches,
      "Shader switches: " .. stats.shaderswitches,
      "Fonts: " .. stats.fonts,
    }

    love.graphics.setFont(love.graphics.newFont(12))
    for i, text in ipairs(info) do
      local sx, sy = CONFIG.debug.stats.shadowOffset.x, CONFIG.debug.stats.shadowOffset.y
      love.graphics.setColor(CONFIG.debug.stats.shadow)
      love.graphics.print(text, x + sx, y + sy + (i - 1) * dy)
      love.graphics.setColor(CONFIG.debug.stats.foreground)
      love.graphics.print(text, x, y + (i - 1) * dy)
    end

    love.graphics.pop()
  end
end

function love.keypressed(key, code, isRepeat)
  if not RELEASE and code == CONFIG.debug.key then
    DEBUG = not DEBUG
  end
end

function love.threaderror(thread, errorMessage)
  print("Thread error!\n" .. errorMessage)
end
