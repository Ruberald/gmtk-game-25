local loadTimeStart = love.timer.getTime()

require 'globals'
local Game = require 'src.Game'

function love.load()
    love.window.setMode(CONFIG.window.width, CONFIG.window.height, {
        fullscreen = CONFIG.window.fullscreen,
        resizable = CONFIG.window.resizable,
        vsync = CONFIG.window.vsync,
    })

    love.window.setTitle(CONFIG.window.title)
    love.graphics.setDefaultFilter('nearest','nearest')

    if CONFIG.window.icon then
        love.window.setIcon(love.image.newImageData(CONFIG.window.icon))
    end

    roomy:hook({exclude = { 'update', 'draw' }})

    if CONFIG.showSplash then
        roomy:enter(scenes.splash)
    else
        Game:load()
    end

    if DEBUG then
        local loadTimeEnd = love.timer.getTime()
        print(("Loaded game in %.3f seconds."):format(loadTimeEnd - loadTimeStart))
    end
end

lurker.postswap = function(fileName)
    love.event.quit("restart")
end

function love.update(dt)
    lurker.update(dt)
    local top = roomy._scenes[#roomy._scenes]
    if top.update then
        top:update(dt)
    else
        Game:update(dt)
    end
end

function love.draw()
    local drawTimeStart = love.timer.getTime()
    local top = roomy._scenes[#roomy._scenes]
    if top.draw then
        top:draw()
    else
        Game:draw()
    end
    local drawTimeEnd = love.timer.getTime()

    if DEBUG then
        drawDebugStats(drawTimeEnd - drawTimeStart)
    end
end

function drawDebugStats(drawTime)
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
        "DRAW: " .. ("%7.3fms"):format(drawTime * 1000),
        "RAM: " .. string.format("%7.2f", ram) .. memoryUnit,
        "VRAM: " .. string.format("%6.2f", vram) .. memoryUnit,
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

function love.keypressed(key, scancode, isRepeat)
    if key == 'escape' then
        local topScene = roomy._scenes[#roomy._scenes]
        if topScene == scenes.mainMenu then
            roomy:pop()
        else
            roomy:push(scenes.mainMenu)
        end
    elseif not RELEASE and scancode == CONFIG.debug.key then
        DEBUG = not DEBUG
    else
        local topScene = roomy._scenes[#roomy._scenes]
        if topScene.keypressed then
            topScene:keypressed(key, scancode, isRepeat)
        end
    end
end

function love.threaderror(thread, errorMessage)
    print("Thread error!\n" .. errorMessage)
end
