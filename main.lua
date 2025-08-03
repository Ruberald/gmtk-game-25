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

    -- local info = {
    --     "FPS: " .. ("%3d"):format(love.timer.getFPS()),
    --     "DRAW: " .. ("%7.3fms"):format(drawTime * 1000),
    --     "RAM: " .. string.format("%7.2f", ram) .. memoryUnit,
    --     "VRAM: " .. string.format("%6.2f", vram) .. memoryUnit,
    --     "Draw calls: " .. stats.drawcalls,
    --     "Images: " .. stats.images,
    --     "Canvases: " .. stats.canvases,
    --     "\tSwitches: " .. stats.canvasswitches,
    --     "Shader switches: " .. stats.shaderswitches,
    --     "Fonts: " .. stats.fonts,
    -- }

    -- love.graphics.setFont(love.graphics.newFont(12))
    -- for i, text in ipairs(info) do
    --     local sx, sy = CONFIG.debug.stats.shadowOffset.x, CONFIG.debug.stats.shadowOffset.y
    --     love.graphics.setColor(CONFIG.debug.stats.shadow)
    --     love.graphics.print(text, x + sx, y + sy + (i - 1) * dy)
    --     love.graphics.setColor(CONFIG.debug.stats.foreground)
    --     love.graphics.print(text, x, y + (i - 1) * dy)
    -- end

    love.graphics.pop()
end

function love.keypressed(key, scancode, isRepeat)
    if key == 'escape' then
        local topScene = roomy._scenes[#roomy._scenes]
        if topScene == scenes.pauseMenu then
            roomy:pop()
        elseif topScene == scenes.mainMenu then
            roomy:enter(scenes.splash)
        elseif topScene == scenes.splash then
            love.event.quit()
        else
            roomy:push(scenes.pauseMenu)
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

-- Sprite Coordinate Finder
-- A simple tool to find the exact pixel coordinates on a spritesheet.

-- require 'globals'

-- function love.load()
--     -- ===================================================================
--     -- INSTRUCTIONS: Change this path to the spritesheet you want to inspect.
--     -- Make sure the path is correct relative to your project's root.
--     -- ===================================================================
--     local imagePath = 'assets/player/idle.png'

--     love.window.setMode(CONFIG.window.width, CONFIG.window.height, {
--         fullscreen = CONFIG.window.fullscreen,
--         resizable = CONFIG.window.resizable,
--         vsync = CONFIG.window.vsync,
--     })

--     -- Check if the file exists before trying to load it
--     local success, message = pcall(function()
--         image = love.graphics.newImage(imagePath)
--     end)

--     if not success then
--         image = nil
--         print("ERROR: Could not load image at: '" .. imagePath .. "'")
--         print("LÖVE2D Error: " .. tostring(message))
--         print("Please make sure the path is correct and the file is in your project folder.")
--     end

--     -- Set up font and window title
--     font = love.graphics.newFont(14)
--     love.window.setTitle("Sprite Coordinate Finder | Click to print coordinates")
-- end

-- function love.update(dt)
--     -- No update logic is needed for this tool.
-- end

-- function love.draw()
--     love.graphics.setBackgroundColor(0.2, 0.2, 0.25) -- Dark background for better contrast

--     if image then
--         -- Draw the spritesheet at the top-left corner
--         love.graphics.draw(image, 0, 0)
--     else
--         -- Display an error message if the image could not be loaded
--         love.graphics.setColor(1, 0.2, 0.2)
--         love.graphics.print("Could not load image. Check the console for the correct path.", 10, 10)
--         love.graphics.setColor(1, 1, 1)
--         return
--     end

--     -- Get the current mouse position
--     local mx, my = love.mouse.getPosition()

--     -- Draw helpful text on the screen
--     love.graphics.setFont(font)
--     love.graphics.setColor(1, 1, 1)
--     love.graphics.print("Move mouse to find coordinates.", 10, love.graphics.getHeight() - 60)
--     love.graphics.print("Click to print coordinates to the console.", 10, love.graphics.getHeight() - 40)

--     -- Draw the current mouse coordinates next to the cursor for real-time feedback
--     love.graphics.setColor(1, 1, 0) -- Bright yellow for high visibility
--     love.graphics.printf("(" .. mx .. ", " .. my .. ")", mx + 20, my, love.graphics.getWidth())
--     love.graphics.setColor(1, 1, 1) -- Reset color
-- end

-- function love.mousepressed(x, y, button, istouch, presses)
--     -- When the left mouse button is clicked, print the coordinates to the console.
--     if button == 1 then
--         print("Clicked at: x = " .. x .. ", y = " .. y)
--     end
-- end

