-- src/scenes/lore.lua
local lore = {}

local font
local pages = {
  [[
  Stranded.
]],
  [[
  Alone in an abandoned facilty, 
  hurtling past asteroids through space.
]],
  [[
  Death, perhaps...
]],
  [[
  Is the only way out.
]]
}

lore.done = false

local currentPage = 1
local charIndex = 0
local charTimer = 0
local charDelay = 0.1
local displayedText = ""
local revealComplete = false

function lore:load()
  font = love.graphics.newFont("assets/font.ttf", 48)
  self:resetPage(1)
  self.done = false
end

function lore:resetPage(page)
  currentPage = page
  charIndex = 0
  charTimer = 0
  displayedText = ""
  revealComplete = false
end

function lore:update(dt)
  if not revealComplete then
    charTimer = charTimer + dt
    while charTimer >= charDelay and charIndex < #pages[currentPage] do
      charTimer = charTimer - charDelay
      charIndex = charIndex + 1
      displayedText = pages[currentPage]:sub(1, charIndex)
    end
    if charIndex >= #pages[currentPage] then
      revealComplete = true
    end
  end
end

function lore:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  love.graphics.setFont(font)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(displayedText, 40, h / 3, w - 80, "center")

  if revealComplete then
    local prompt = currentPage < #pages and "..." or "Press any key to begin"
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.printf(prompt, 0, h - 60, w, "center")
  end
end

function lore:keypressed()
  if not revealComplete then
    -- Instantly reveal full text
    charIndex = #pages[currentPage]
    displayedText = pages[currentPage]
    revealComplete = true
  elseif currentPage < #pages then
    -- Next page
    self:resetPage(currentPage + 1)
  else
    -- All pages done
    self.done = true
  end
end

function lore:mousepressed()
  self:keypressed()
end

return lore
