Love2D Template
===============

> A LÖVE (Love2d) template that includes everything you need to develop a game with modern niceties

### Why?

Mostly just exploring Love2d and some modules. Also trying to wrap my head around how I should structure a game and all it's parts.

### Install

```sh
git clone https://github.com/james2doyle/love2d-template
cd love2d-template
love .
```

### Running

The game starts with a splash page, then goes to the main menu. You can click some of the menu items to go to those other menus. Pressing any button in the credits goes back to the main menu.

Pressing `\`` at any time will toggle the debug menu.

### Modules

* [Badr](https://github.com/Nabeel20/Badr) - Simple and easy user interfaces with composable components
* [Roomy](https://github.com/tesselode/roomy) - Organize your game into "screens" (title/start screen, levels, pause screen)
* [Flux (fork)](https://github.com/Sheepolution/flux) - Fast, lightweight tweening library
* [Step](https://github.com/Sheepolution/step) - Timer module for interval actions or delayed actions
* [Lurker (fork)](https://github.com/jeduden/lurker) - Auto-swaps changed files in a running
* [Lume (fork)](https://github.com/NQMVD/lume) - Helpful functions
* [Luacolors](https://github.com/icrawler/luacolors) - Collection of functions for common colors and conversions

<!-- TODO Add these -->
<!-- * [Baton](https://github.com/tesselode/baton) - Input library that supports keyboards, joysticks, and on-the-fly control swapping -->
<!-- * [Nata](https://github.com/tesselode/nata) - Entity management with containers for objects in a game, like geometry, characters, and collectibles -->
<!-- * [Moonshine (fork)](https://github.com/flamendless/moonshine) - Chainable post-processing shaders -->
<!-- * [Fizzx](https://github.com/2dengine/fizzx) - Collision detection and resolution library -->
<!-- * [Strike](https://github.com/Aweptimum/Strike) - Collision detection between convex shapes -->
<!-- * [Binser](https://github.com/bakpakin/binser) - Robust serializer for storing complex objects -->
<!-- * [Profile.lua](https://github.com/2dengine/profile.lua) - Profile your code by gathering function call frequently and execution time -->
<!-- * [Vudu](https://github.com/deltadaedalus/vudu) - GUI based in-game debugging system -->
<!-- * [Love-Release](https://github.com/MisterDA/love-release) - Create releases for Windows executables, macOS applications, Debian packages, and more -->

## Snippets

#### A new "scene"

```lua
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
```