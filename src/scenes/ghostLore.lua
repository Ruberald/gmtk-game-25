-- src/scenes/ghostLore.lua
local ghostLore = {}

local font
local pages = {
  [[
  They ran experiments on you.
  ]],
  [[
  Making their robot repeat your death loop.
  ]],
  [[
  Again.
  And Again.
  ]],
  [[
  ...
  ]],
  [[
  Maybe there's a way out after all.
  ]]
}

ghostLore.done = false

local currentPage = 1
local charIndex = 0
local charTimer = 0
local charDelay = 0.1
local displayedText = ""
local revealComplete = false

function ghostLore:enter()
  love.graphics.setBackgroundColor(0, 0, 0)
  font = love.graphics.newFont("assets/font.ttf", 48)
  self:resetPage(1)
  self.done = false
end

function ghostLore:resetPage(page)
  currentPage = page
  charIndex = 0
  charTimer = 0
  displayedText = ""
  revealComplete = false
end

function ghostLore:update(dt)
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

function ghostLore:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  love.graphics.setFont(font)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(displayedText, 40, h / 3, w - 80, "center")

  if revealComplete then
    local prompt = currentPage < #pages and "..." or "Press any key to continue"
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.printf(prompt, 0, h - 60, w, "center")
  end
end

function ghostLore:keypressed()
  if not revealComplete then
    charIndex = #pages[currentPage]
    displayedText = pages[currentPage]
    revealComplete = true
  elseif currentPage < #pages then
    self:resetPage(currentPage + 1)
  else
    self.done = true
    roomy:pop()
  end
end

function ghostLore:mousepressed()
  self:keypressed()
end

return ghostLore

