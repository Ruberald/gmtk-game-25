local level1Data = require 'src.levels.level1'
local level2Data = require 'src.levels.level2'
local level3Data = require 'src.levels.level3'
local level4Data = require 'src.levels.level4'
local player = require 'src.entities.player'
local ghost = require 'src.entities.ghost'
local enemy = require 'src.entities.enemy'
local key = require 'src.entities.key'
local TILE_DEFS = require 'src.levels.tile_definition'

local function createLevel(tiledMapData, nextLevelKey, levelNumber)
    local level = {
        mapWidthInTiles = tiledMapData.width,
        mapHeightInTiles = tiledMapData.height,
        tileSize = tiledMapData.tilewidth,
        nextLevelKey = nextLevelKey,
        levelNumber = levelNumber,

        playerStartX = 8,
        playerStartY = 6,

        tileQuads = {},
        tileLayers = {},
        collisionMap = {},
        tileIDs = {}, 

        plates = {},
        spikes = {},
        doors = {},
        buttons = {},
        levelUpPos = nil,
        keyStartX = nil,
        keyStartY = nil,

        scale = 1,
        offsetX = 0,
        offsetY = 0,

        gameTimer = 0,
        currentRunActions = {},
        lastRunActions = nil,
        puzzleTargetID = nil, -- will be set once on load for level 3
    }

    function level:getProperty(props, name)
        if not props then return nil end
        for _, p in ipairs(props) do
            if p.name == name then
                return p.value
            end
        end
        return nil
    end

    function level:buildTileDictionary()
        self.tileIDs = {}
        local tilesetInfo = {}
        for _, ts in ipairs(tiledMapData.tilesets) do
            tilesetInfo[ts.name] = ts.firstgid
        end
        for name, def in pairs(TILE_DEFS) do
            local firstgid = tilesetInfo[def.tileset]
            if firstgid then
                self.tileIDs[name] = firstgid + def.localId
            else
                print(string.format("WARNING: Tileset '%s' not found for tile '%s'", def.tileset, name))
            end
        end
    end

    function level:loadInteractionObjects()
        self.plates = {}
        self.spikes = {}
        self.doors = {}
        self.buttons = {}
        self.levelUpPos = nil
        self.puzzleTargetID = nil 

        for _, layer in ipairs(tiledMapData.layers) do
            if layer.type == "objectgroup" and layer.name == "Interactions" then
                for _, obj in ipairs(layer.objects) do
                    local objType = self:getProperty(obj.properties, "type")
                    local tileX = math.floor(obj.x / self.tileSize) + 1
                    local tileY = math.floor(obj.y / self.tileSize) + 1
                    
                    if objType == "plate" then
                        table.insert(self.plates, { x = tileX, y = tileY, targets = self:getProperty(obj.properties, "targets"), isPressed = false, layerIndex = 4, timer = nil, wasOnPlate = false })
                    elseif objType == "spike" then
                        local id = self:getProperty(obj.properties, "id")
                        local alwaysOn = self:getProperty(obj.properties, "alwaysOn") or false
                        table.insert(self.spikes, {
                            x = tileX,
                            y = tileY,
                            id = id,
                            isActive = true,
                            alwaysOn = alwaysOn,
                            layerIndex = 4,
                            frame = 1,
                            timer = 0,
                            direction = 1
                        })
                    elseif objType == "door" then
                        table.insert(self.doors, { x = tileX, y = tileY, id = self:getProperty(obj.properties, "id"), isOpen = false, layerIndex = 3 })
                    elseif objType == "button" then
                        local button = { x = tileX, y = tileY, targets = self:getProperty(obj.properties, "targets"), wasPressed = false, layerIndex = 4, puzzle_role = self:getProperty(obj.properties, "puzzle_role") }
                        table.insert(self.buttons, button)
                        if self.levelNumber == 3 and button.puzzle_role then
                            self.puzzleTargetID = button.targets
                        end
                    elseif objType == "levelUp" then
                        self.levelUpPos = { x = tileX, y = tileY }
                    elseif objType == "playerStart" then
                        self.playerStartX = tileX
                        self.playerStartY = tileY
                    elseif objType == "keyStart" then
                        self.keyStartX = tileX
                        self.keyStartY = tileY
                    end
                end
            end
        end
    end

    function level:setTargetsActive(targetID, isActive)
        for _, spike in ipairs(self.spikes) do
            if spike.id == targetID and not spike.alwaysOn then
                spike.isActive = isActive
            end
        end
        for _, door in ipairs(self.doors) do
            if door.id == targetID then
                if door.isOpen ~= isActive then
                    if self.sounds.doorOpen then self.sounds.doorOpen:play() end
                end
                door.isOpen = isActive
                self.collisionMap[door.y][door.x] = door.isOpen and 0 or 1
                local doorTID = door.isOpen and 0 or self.tileIDs.doorBlock
                if doorTID then self.tileLayers[door.layerIndex][door.y][door.x] = doorTID end
            end
        end
    end

    function level:load()
        self:buildTileDictionary()
        self.shinyFrame = 1
        self.shinyTimer = 0
        self.nextShinySwitch = love.math.random() * 0.75 + 0.25
        self.tileLayers = {}
        self.collisionMap = {}
        self.tileQuads = {}
        for _, ts in ipairs(tiledMapData.tilesets) do
            local image = love.graphics.newImage('assets/' .. ts.name .. '.png')
            local imgW, imgH = image:getWidth(), image:getHeight()
            local cols = math.floor(imgW / self.tileSize)
            local rows = math.floor(imgH / self.tileSize)
            local id = ts.firstgid
            for ry = 0, rows - 1 do
                for cx = 0, cols - 1 do
                    self.tileQuads[id] = { image = image, quad = love.graphics.newQuad(cx * self.tileSize, ry * self.tileSize, self.tileSize, self.tileSize, imgW, imgH) }
                    id = id + 1
                end
            end
        end
        for _, layerData in ipairs(tiledMapData.layers) do
            if layerData.type == "tilelayer" then
                local layer2D = {}
                for y = 1, self.mapHeightInTiles do
                    layer2D[y] = {}
                    for x = 1, self.mapWidthInTiles do
                        layer2D[y][x] = layerData.data[(y - 1) * self.mapWidthInTiles + x]
                    end
                end
                if layerData.name == "Collisions" then self.collisionMap = layer2D else table.insert(self.tileLayers, layer2D) end
            end
        end

        self.sounds = {
            doorOpen = love.audio.newSource("assets/sfx/door.mp3", "static"),
            spikeKill = love.audio.newSource("assets/sfx/spike.mp3", "static"),
            platePress = love.audio.newSource("assets/sfx/plate.mp3", "static")
        }

        self:loadInteractionObjects()

        player:load()
        ghost:load()
        if self.keyStartX and self.keyStartY then key:load(self.keyStartX, self.keyStartY, self.tileSize) self.key = key else self.key = nil end
        self.lastRunActions = nil
        ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, nil)
        self:startNewRun()
    end

    function level:startNewRun()
        if #self.currentRunActions > 0 then self.lastRunActions = self.currentRunActions end
        self.gameTimer = 0
        self.currentRunActions = {}

        -- enemy:reset(10, 10, self.tileSize)
        -- key:reset()

        player:reset(self.playerStartX, self.playerStartY, self.tileSize)
        if self.lastRunActions then ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, self.lastRunActions) end
        for _, plate in ipairs(self.plates) do
            plate.isPressed = false
            plate.timer = nil
            plate.wasOnPlate = false
            self:setTargetsActive(plate.targets, false)
        end
        for _, button in ipairs(self.buttons) do
            button.wasPressed = false
            if self.levelNumber == 3 then
                self:setTargetsActive(button.targets, true)
            else
                self:setTargetsActive(button.targets, false)
            end
        end
        for _, spike in ipairs(self.spikes) do
            spike.isActive = true
            spike.frame = 1
            spike.timer = 0
            spike.direction = 1
        end
    end

    function level:update(dt)
        self.gameTimer = self.gameTimer + dt
        player:update(dt, self.collisionMap, self.tileSize, self.gameTimer, self.currentRunActions)
        ghost:update(dt, self.gameTimer)
        if self.key then self.key:update(player) end
        self.shinyTimer = self.shinyTimer + dt
        if self.shinyTimer >= self.nextShinySwitch then
            self.shinyTimer = self.shinyTimer - self.nextShinySwitch
            self.nextShinySwitch = love.math.random() * 0.75 + 0.25
            self.shinyFrame = (self.shinyFrame == 1) and 2 or 1
        end
        for _, plate in ipairs(self.plates) do
            local onPlate = (player.gridX == plate.x and player.gridY == plate.y) or (ghost.active and ghost.gridX == plate.x and ghost.gridY == plate.y)
            if onPlate and not plate.isPressed and not plate.wasOnPlate then
                if self.sounds.platePress then self.sounds.platePress:play() end
                plate.isPressed = true
                -- determine duration based on target type
                do
                    local targetID = plate.targets
                    local hasSpike = false
                    for _, sp in ipairs(self.spikes) do if sp.id == targetID then hasSpike = true break end end
                    plate.timer = hasSpike and 1.5 or 0.8
                    if hasSpike then
                        -- temporarily disable spikes (even alwaysOn)
                        for _, sp in ipairs(self.spikes) do
                            if sp.id == targetID then
                                sp.isActive = false
                                sp.frame = 1
                            end
                        end
                    else
                        self:setTargetsActive(targetID, true)
                    end
                end
            end
            if plate.isPressed and plate.timer then
                plate.timer = plate.timer - dt
                if plate.timer <= 0 then
                    plate.isPressed = false
                    plate.timer = nil
                    -- restore door or spikes appropriately
                    do
                        local targetID = plate.targets
                        local hasSpike = false
                        for _, sp in ipairs(self.spikes) do if sp.id == targetID then hasSpike = true break end end
                        if hasSpike then
                            -- restore spikes (respect alwaysOn)
                            for _, sp in ipairs(self.spikes) do
                                if sp.id == targetID then
                                    sp.isActive = true
                                    sp.frame = sp.alwaysOn and 3 or 1
                                    sp.timer = 0
                                    sp.direction = 1
                                end
                            end
                        else
                            self:setTargetsActive(targetID, false)
                        end
                    end
                end
            end
            local plateTID = plate.isPressed and self.tileIDs.pressedPressurePlate or self.tileIDs.pressurePlate
            if plateTID then self.tileLayers[plate.layerIndex][plate.y][plate.x] = plateTID end
            plate.wasOnPlate = onPlate
        end

        if self.levelNumber == 3 then
            local button1_pressed, button2_pressed = false, false
            for _, button in ipairs(self.buttons) do
                local onButton = (player.gridX == button.x and player.gridY == button.y) or (ghost.active and ghost.gridX == button.x and ghost.gridY == button.y)
                if onButton then
                    if button.puzzle_role == "dual_1" then button1_pressed = true end
                    if button.puzzle_role == "dual_2" then button2_pressed = true end
                end
            end
            if button1_pressed and button2_pressed then
                self:setTargetsActive(self.puzzleTargetID, false)
            end
        else
            for _, button in ipairs(self.buttons) do
                if not button.wasPressed then
                    local onButton = (player.gridX == button.x and player.gridY == button.y) or (ghost.active and ghost.gridX == button.x and ghost.gridY == button.y)
                    if onButton then
                        button.wasPressed = true
                        -- toggle door or spikes appropriately
                        do
                            local targetID = button.targets
                            local hasSpike = false
                            for _, sp in ipairs(self.spikes) do if sp.id == targetID then hasSpike = true break end end
                            if hasSpike then
                                -- permanently disable spikes (set to frame 1)
                                for _, sp in ipairs(self.spikes) do
                                    if sp.id == targetID then
                                        sp.isActive = false
                                        sp.frame = 1
                                    end
                                end
                            else
                                self:setTargetsActive(targetID, true)
                            end
                        end
                        self.tileLayers[button.layerIndex][button.y][button.x] = self.tileIDs.pressedButton
                    end
                end
            end
        end

        for _, spike in ipairs(self.spikes) do
            if not spike.isActive then
                -- disabled spikes stay retracted
                spike.frame = 1
            elseif spike.alwaysOn then
                -- always-on spikes animate up to frame 3 and stay
                if spike.frame < 3 then
                    spike.timer = spike.timer + dt
                    local interval = (spike.frame == 1) and 0.75 or 0.25
                    if spike.timer >= interval then
                        spike.timer = spike.timer - interval
                        spike.frame = spike.frame + 1
                    end
                end
            elseif self.levelNumber == 3 and spike.id == self.puzzleTargetID and spike.isActive then
                -- level3 puzzle spike
                if spike.frame < 3 then
                    spike.timer = spike.timer + dt
                    local interval = (spike.frame == 1) and 0.75 or 0.25
                    if spike.timer >= interval then
                        spike.timer = spike.timer - interval
                        spike.frame = spike.frame + 1
                    end
                end
            elseif spike.isActive then
                -- normal spike animation
                spike.timer = spike.timer + dt
                local interval = (spike.frame == 1) and 0.75 or 0.25
                if spike.timer >= interval then
                    spike.timer = spike.timer - interval
                    if spike.frame == 3 then spike.direction = -1 elseif spike.frame == 1 then spike.direction = 1 end
                    spike.frame = spike.frame + spike.direction
                end
            else
                spike.frame = 1
            end

            if spike.frame > 1 then 
                if not player.isDead and player.gridX == spike.x and player.gridY == spike.y then 
                    if self.sounds.spikeKill then self.sounds.spikeKill:play() end
                    player:die('normal') 
                end
                if ghost.active and ghost.gridX == spike.x and ghost.gridY == spike.y then ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, self.lastRunActions) end
            end
            
            if self.tileIDs['spike' .. spike.frame] then
                self.tileLayers[spike.layerIndex][spike.y][spike.x] = self.tileIDs['spike' .. spike.frame]
            end
        end

        if not player.isDead and not player.moving and self.levelUpPos then
            if player.gridX == self.levelUpPos.x and player.gridY == self.levelUpPos.y then
                if self.levelNumber == 3 or self.levelNumber == 4 then
                    return self.nextLevelKey
                end
                local mainDoorIsOpen = false
                for _, door in ipairs(self.doors) do if door.isOpen then mainDoorIsOpen = true break end end
                if (self.key and player.hasKey) or mainDoorIsOpen then return self.nextLevelKey end
            end
        end
        if player:getIsReadyToRespawn() then self:startNewRun() end
    end

    function level:draw()
        local mapPixelWidth = self.mapWidthInTiles * self.tileSize
        local mapPixelHeight = self.mapHeightInTiles * self.tileSize
        local screenWidth, screenHeight = love.graphics.getDimensions()
        self.scale = math.min(screenWidth / mapPixelWidth, screenHeight / mapPixelHeight)
        self.offsetX = (screenWidth - (mapPixelWidth * self.scale)) / 2
        self.offsetY = (screenHeight - (mapPixelHeight * self.scale)) / 2
        love.graphics.push()
        love.graphics.translate(self.offsetX, self.offsetY)
        love.graphics.scale(self.scale, self.scale)
        for _, layer in ipairs(self.tileLayers) do
            for y = 1, self.mapHeightInTiles do
                for x = 1, self.mapWidthInTiles do
                    local tid = layer[y][x]
                    if tid and tid ~= 0 then
                        local drawTid = tid
                        if tid == self.tileIDs.shinyStar1 then drawTid = self.tileIDs['shinyStar' .. self.shinyFrame] end
                        local info = self.tileQuads[drawTid]
                        if info then love.graphics.draw(info.image, info.quad, (x - 1) * self.tileSize, (y - 1) * self.tileSize) end
                    end
                end
            end
        end
        ghost:draw()
        player:draw()
        if self.key then self.key:draw() end
        love.graphics.pop()
    end

    return level
end

return {
    level1 = createLevel(level1Data, 'level2', 1),
    level2 = createLevel(level2Data, 'level3', 2),
    level3 = createLevel(level3Data, 'level4', 3),
    level4 = createLevel(level4Data, nil, 4)
}
