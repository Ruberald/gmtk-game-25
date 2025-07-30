-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !! This flag controls the ability to toggle the debug view.         !!
-- !! You will want to turn this to 'true' when you publish your game. !!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
RELEASE = false

-- Enables the debug stats
DEBUG = not RELEASE

-- @see https://github.com/icrawler/luacolors
colors = require("lib.luacolors")

-- @see https://github.com/Nabeel20/Badr
badr = require("lib.badr")

-- @see https://github.com/tesselode/roomy
roomy = require("lib.roomy").new()

-- @see https://github.com/Sheepolution/flux
flux = require("lib.flux")

-- @see https://github.com/Sheepolution/step
step = require("lib.step")

-- @see https://github.com/jeduden/lurker
lurker = require("lib.lurker")

-- @see https://github.com/NQMVD/lume
lume = require("lib.lume")

-- @see https://github.com/tesselode/baton
-- baton = require("lib.baton")

-- @see https://github.com/tesselode/nata
-- nata = require("lib.nata")

-- @see https://github.com/flamendless/moonshine
-- moonshine = require("lib.moonshine")

-- @see https://github.com/2dengine/fizzx
-- fizzx = require("lib.fizzx")

-- @see https://github.com/Aweptimum/Strike
-- strike = require("lib.strike")

-- @see https://github.com/bakpakin/binser
-- binser = require("lib.binser")

-- @see https://github.com/2dengine/profile.lua
-- profile = require("lib.profile")

-- @see https://github.com/flamendless/moonshine
-- moonshine = require("lib.moonshine")

-- @see https://github.com/deltadaedalus/vudu
-- vudu = require("lib.vudu")

scenes = {
  splash = require("src.scenes.splash"),
  credits = require("src.scenes.credits"),
  mainMenu = require("src.scenes.main-menu"),
}

CONFIG = {
  showSplash = true,
  joystick = love.joystick.getJoysticks()[1],
  deadzone = .33,
  graphics = {
    filter = {
      -- FilterModes: linear (blurry) / nearest (blocky)
      -- Default filter used when scaling down
      down = "nearest",

      -- Default filter used when scaling up
      up = "nearest",

      -- Amount of anisotropic filter performed
      anisotropy = 1,
    }
  },

  window = {
    -- icon = 'assets/images/icon.png'
    icon = nil
  },

  debug = {
    -- The key (scancode) that will toggle the debug state.
    -- Scancodes are independent of keyboard layout so it will always be in the same
    -- position on the keyboard. The positions are based on an American layout.
    key = '`',

    stats = {
      font         = nil,          -- set after fonts are created
      fontSize     = 16,
      lineHeight   = 18,
      foreground   = colors.whiteAlpha(1),
      shadow       = colors.blackAlpha(1),
      shadowOffset = { x = 1, y = 1 },
      position     = { x = 8, y = 6 },

      kilobytes    = false,
    },

    -- Error screen config
    error = {
      font         = nil,          -- set after fonts are created
      fontSize     = 16,
      background   = { .1, .31, .5 },
      foreground   = colors.white,
      shadow       = colors.blackAlpha(.88),
      shadowOffset = { x = 1, y = 1 },
      position     = { x = 70, y = 70 },
    },
  }
}
