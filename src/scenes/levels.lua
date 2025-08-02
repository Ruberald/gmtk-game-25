local level1Data = require 'src.levels.level1'
local level2Data = require 'src.levels.level2'
local level3Data = require 'src.levels.level3'
local player = require 'src.entities.player'
local ghost = require 'src.entities.ghost'
local enemy = require 'src.entities.enemy'
local key = require 'src.entities.key'
local TILE_DEFS = require 'src.levels.tile_definition'

local function createLevel(tiledMapData, nextLevelKey)
    local level = {
        mapWidthInTiles = tiledMapData.width,
        mapHeightInTiles = tiledMapData.height,
        tileSize = tiledMapData.tilewidth,
        nextLevelKey = nextLevelKey,

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

        scale = 1,
        offsetX = 0,
        offsetY = 0,

        gameTimer = 0,
        currentRunActions = {},
        lastRunActions = nil,
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
                print(string.format("WARNING: Tileset '%s' not found in map for tile '%s'", def.tileset, name))
            end
        end

        -- print("Loaded Tile IDs:")
        -- for name, id in pairs(self.tileIDs) do
        --     print(name .. ": " .. id)
        -- end
    end



    function level:loadInteractionObjects()
    print("--- Loading Interaction Objects ---")
    self.plates = {}
    self.spikes = {}
    self.doors = {}
    self.buttons = {}
    self.levelUpPos = nil

    local interactionLayerFound = false
    for _, layer in ipairs(tiledMapData.layers) do
        if layer.type == "objectgroup" and layer.name == "Interactions" then
            interactionLayerFound = true
            print("Found 'Interactions' layer with " .. #layer.objects .. " objects.")
            for _, obj in ipairs(layer.objects) do
                local objType = self:getProperty(obj.properties, "type")
                local tileX = math.floor(obj.x / self.tileSize) + 1
                local tileY = math.floor(obj.y / self.tileSize) + 1
                
                if objType == "plate" then
                    print("Found plate at:", tileX, tileY)
                    table.insert(self.plates, {
                        x = tileX,
                        y = tileY,
                        targets = self:getProperty(obj.properties, "targets"),
                        isPressed = false,
                        layerIndex = 4,
                        timer = nil,
                        wasOnPlate = false,
                    })
                elseif objType == "spike" then
                    print("Found spike at:", tileX, tileY, "with id:", self:getProperty(obj.properties, "id"))
                    table.insert(self.spikes, {
                        x = tileX,
                        y = tileY,
                        id = self:getProperty(obj.properties, "id"),
                        isActive = true,
                        layerIndex = 4,
                        frame = 1,
                        timer = 0,
                        direction = 1
                    })
                elseif objType == "door" then
                    print("Found door at:", tileX, tileY)
                     table.insert(self.doors, {
                        x = tileX,
                        y = tileY,
                        id = self:getProperty(obj.properties, "id"),
                        isOpen = false,
                        layerIndex = 3 
                     })
                elseif objType == "button" then
                    print("Found button at:", tileX, tileY)
                    table.insert(self.buttons, {
                        x = tileX,
                        y = tileY,
                        targets = self:getProperty(obj.properties, "targets"),
                        wasPressed = false,
                        layerIndex = 4 
                    })
                elseif objType == "levelUp" then
                    self.levelUpPos = { x = tileX, y = tileY }
                elseif objType == "playerStart" then
                    self.playerStartX = tileX
                    self.playerStartY = tileY
                end
            end
        end
    end
    if not interactionLayerFound then
        print("!!! ERROR: 'Interactions' object layer NOT FOUND in map data.")
    end
end


    function level:setTargetsActive(targetID, isActive)
        -- deactivate spikes
        for _, spike in ipairs(self.spikes) do
            if spike.id == targetID then
                spike.isActive = isActive
            end
        end

        -- open/close doors with the matching ID
        for _, door in ipairs(self.doors) do
            if door.id == targetID then
                door.isOpen = isActive
                self.collisionMap[door.y][door.x] = door.isOpen and 0 or 1
                local doorTID = door.isOpen and 0 or self.tileIDs.doorBlock
                self.tileLayers[door.layerIndex][door.y][door.x] = doorTID
            end
        end
    end


    function level:load()
        self:buildTileDictionary()

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
                    self.tileQuads[id] = { image = image, quad = love.graphics.newQuad(
                        cx * self.tileSize, ry * self.tileSize,
                        self.tileSize, self.tileSize,
                        imgW, imgH
                    ) }
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
                        local i = (y - 1) * self.mapWidthInTiles + x
                        layer2D[y][x] = layerData.data[i]
                    end
                end

                if layerData.name == "Collisions" then
                    self.collisionMap = layer2D  -- collision layer will not get rendered
                else
                    table.insert(self.tileLayers, layer2D)
                end
            end
        end

        self:loadInteractionObjects()
        
        player:load()
        ghost:load()
        key:load(10, 7, self.tileSize) -- key needs to be moved to the interactions layer too
        self.key = key

        self.lastRunActions = nil
        ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, nil)
        self:startNewRun()
    end

    function level:startNewRun()
        if #self.currentRunActions > 0 then self.lastRunActions = self.currentRunActions end
        self.gameTimer = 0
        self.currentRunActions = {}

        -- enemy:reset(10, 10, self.tileSize)
        key:reset()

        player:reset(self.playerStartX, self.playerStartY, self.tileSize)

        if self.lastRunActions then
            ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, self.lastRunActions)
        end

        for _, plate in ipairs(self.plates) do
            plate.isPressed = false
            plate.timer = nil
            plate.wasOnPlate = false
            self:setTargetsActive(plate.targets, false)
        end
        for _, button in ipairs(self.buttons) do
            button.wasPressed = false
            self:setTargetsActive(button.targets, false)
        end
    end

    function level:update(dt)
        self.gameTimer = self.gameTimer + dt
        player:update(dt, self.collisionMap, self.tileSize, self.gameTimer, self.currentRunActions)
        ghost:update(dt, self.gameTimer)
        self.key:update(player)

        -- check Plates
        for _, plate in ipairs(self.plates) do
            local playerOnPlate = (player.gridX == plate.x and player.gridY == plate.y)
            local ghostOnPlate = (ghost.active and ghost.gridX == plate.x and ghost.gridY == plate.y)
            local onPlate = playerOnPlate or ghostOnPlate

            -- detect new press and start timer
            if onPlate and not plate.isPressed and not plate.wasOnPlate then
                print("PLAYER/GHOST STEPPED ON PLATE. Activating targets: " .. plate.targets)
                plate.isPressed = true
                plate.timer = 1
                self:setTargetsActive(plate.targets, true)
            end

            -- handle timer countdown for automatic release
            if plate.isPressed and plate.timer then
                plate.timer = plate.timer - dt
                if plate.timer <= 0 then
                    print("Pressure plate timeout. Deactivating targets: " .. plate.targets)
                    plate.isPressed = false
                    plate.timer = nil
                    self:setTargetsActive(plate.targets, false)
                end
            end

            -- update tile appearance
            local plateTID = plate.isPressed and self.tileIDs.pressedPressurePlate or self.tileIDs.pressurePlate
            self.tileLayers[plate.layerIndex][plate.y][plate.x] = plateTID

            -- update wasOnPlate for next frame
            plate.wasOnPlate = onPlate
        end

        for _, button in ipairs(self.buttons) do
            if not button.wasPressed then
                local onButton = (player.gridX == button.x and player.gridY == button.y) or
                               (ghost.active and ghost.gridX == button.x and ghost.gridY == button.y)
                if onButton then
                    button.wasPressed = true
                    self:setTargetsActive(button.targets, true)
                    self.tileLayers[button.layerIndex][button.y][button.x] = self.tileIDs.pressedButton
                end
            end
        end

        for _, spike in ipairs(self.spikes) do
            if spike.isActive then
                spike.timer = spike.timer + dt
                local interval = (spike.frame == 1) and 0.75 or 0.25
                if spike.timer >= interval then
                    spike.timer = spike.timer - interval
                    if spike.frame == 3 then spike.direction = -1
                    elseif spike.frame == 1 then spike.direction = 1 end
                    spike.frame = spike.frame + spike.direction
                end
                if spike.frame > 1 then 
                    if not player.isDead and player.gridX == spike.x and player.gridY == spike.y then
                        player:die('normal')
                    end
                    if ghost.active and ghost.gridX == spike.x and ghost.gridY == spike.y then
                        ghost:reset(self.playerStartX, self.playerStartY, self.tileSize, self.lastRunActions)
                    end
                end
            else
                spike.frame = 1 
            end
            self.tileLayers[spike.layerIndex][spike.y][spike.x] = self.tileIDs['spike' .. spike.frame]
        end

        local p_tx, p_ty = player.gridX, player.gridY
        -- if not player.isDead and self.tileLayers[3][p_ty] and self.tileLayers[3][p_ty][p_tx] == self.tileIDs.chasm then
        --     player:die('pitfall')
        -- end
        
        if not player.isDead and not player.moving and self.levelUpPos then
            if player.gridX == self.levelUpPos.x and player.gridY == self.levelUpPos.y then
                local canExit = player.hasKey or self.collisionMap[self.levelUpPos.y][self.levelUpPos.x] == 0
                if canExit then
                    return self.nextLevelKey
                end
            end
        end

        if player:getIsReadyToRespawn() then
            self:startNewRun()
        end
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
                        local info = self.tileQuads[tid]
                        if info then
                            love.graphics.draw(info.image, info.quad, (x - 1) * self.tileSize, (y - 1) * self.tileSize)
                        end
                    end
                end
            end
        end

        ghost:draw()
        player:draw()
        self.key:draw()

        love.graphics.pop()
    end

    return level
end

return {
    level1 = createLevel(level1Data, 'level2'),
    level2 = createLevel(level2Data, 'level3'),
    level3 = createLevel(level3Data, nil),
}
