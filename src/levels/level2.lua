return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 20,
  height = 15,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 9,
  nextobjectid = 1,
  properties = {},
  hints = {
      "Nasty spikes...",
      "Maybe I should move in time.",
  },
  tilesets = {
    {
      name = "CosmicLilac_Tiles",
      firstgid = 1,
      filename = "./CosmicLilac_Tiles.tsx"
    },
    {
      name = "Sprites2",
      firstgid = 107,
      filename = "./Sprites2.tsx"
    },
    {
      name = "Space-bg",
      firstgid = 123,
      filename = "./Space-bg.tsx"
    },
    {
      name = "shiny_star",
      firstgid = 187,
      filename = "./shiny_star.tsx"
    },
    {
      name = "stars",
      firstgid = 189,
      filename = "./stars.tsx"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      id = 3,
      name = "Space",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 101, 101,
        102, 189, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 102, 101, 101,
        102, 102, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 102, 102,
        102, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 102, 102,
        102, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 102, 189, 102,
        102, 189, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 102, 102, 102,
        102, 101, 101, 101, 101, 125, 126, 101, 101, 101, 101, 148, 149, 150, 151, 101, 101, 102, 102, 102,
        102, 101, 101, 101, 101, 133, 134, 101, 101, 101, 101, 156, 157, 158, 159, 79, 101, 102, 102, 102,
        102, 101, 189, 101, 101, 79, 101, 101, 101, 101, 79, 164, 165, 166, 167, 101, 189, 101, 102, 102,
        102, 102, 101, 189, 101, 101, 101, 101, 101, 101, 101, 172, 173, 174, 175, 101, 101, 101, 189, 102,
        102, 102, 102, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 102, 102,
        102, 102, 102, 101, 101, 101, 102, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 102,
        102, 102, 85, 102, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 102, 102, 102,
        102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102,
        102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      id = 4,
      name = "Foreground1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0, 0, 0, 0, 0,
        0, 0, 0, 23, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 0, 0, 0,
        0, 0, 0, 35, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 29, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 36, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 36, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 36, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 21, 21, 21, 21, 22, 29, 21, 21, 21, 21, 21, 21, 21, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 29, 0, 0, 0, 0, 0, 0, 0, 29, 29, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      id = 5,
      name = "Foreground2",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        137, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 138,
        135, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 0, 136,
        135, 0, 27, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 17, 0, 136,
        135, 0, 27, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 81, 15, 15, 17, 0, 136,
        135, 0, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 136,
        135, 0, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 136,
        135, 0, 27, 146, 146, 146, 138, 0, 0, 137, 146, 146, 146, 146, 146, 146, 146, 30, 0, 136,
        135, 0, 27, 0, 0, 0, 136, 0, 0, 135, 0, 0, 0, 0, 0, 0, 0, 30, 0, 136,
        135, 0, 27, 0, 0, 0, 136, 0, 0, 135, 0, 0, 0, 0, 0, 0, 0, 30, 0, 136,
        135, 0, 27, 145, 145, 145, 129, 0, 0, 130, 145, 145, 145, 145, 145, 145, 145, 30, 0, 136,
        135, 0, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 136,
        135, 0, 40, 41, 41, 45, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 136,
        135, 0, 0, 0, 0, 14, 37, 44, 42, 42, 42, 42, 42, 45, 0, 0, 30, 0, 0, 136,
        135, 0, 0, 0, 0, 40, 42, 43, 0, 0, 0, 0, 0, 40, 42, 42, 43, 0, 0, 136,
        130, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 129
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      id = 6,
      name = "Foreground3",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 187, 0,
        0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 16, 0, 0, 20, 7, 20, 0, 0, 0, 0,
        0, 0, 0, 0, 66, 0, 0, 0, 0, 0, 0, 0, 0, 31, 0, 31, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 115, 47, 115, 21, 21, 115, 34, 21, 21, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 47, 0, 0, 115, 115, 46, 0, 115, 0, 48, 0, 0, 0,
        0, 0, 0, 107, 107, 107, 107, 49, 0, 107, 107, 107, 107, 107, 107, 107, 107, 0, 0, 0,
        0, 0, 0, 107, 107, 107, 107, 0, 46, 107, 107, 107, 107, 107, 107, 107, 107, 0, 0, 0,
        0, 0, 0, 107, 107, 107, 107, 115, 0, 107, 107, 107, 107, 107, 107, 107, 107, 0, 0, 0,
        0, 0, 0, 107, 107, 107, 107, 0, 115, 107, 107, 107, 107, 107, 107, 107, 107, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 115, 0, 115, 0, 115, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 115, 56, 115, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 187, 187, 0, 0, 0, 0, 0, 0, 0, 0, 0, 108, 108, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 187, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      id = 5,
      name = "Collisions",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        137, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 146, 138,
        135, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 0, 136,
        135, 0, 27, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 17, 0, 136,
        135, 0, 27, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 81, 15, 15, 17, 0, 136,
        135, 0, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 136,
        135, 0, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 136,
        135, 0, 27, 146, 146, 146, 138, 0, 0, 137, 146, 146, 146, 146, 146, 146, 146, 30, 0, 136,
        135, 0, 27, 0, 0, 0, 136, 0, 0, 135, 0, 0, 0, 0, 0, 0, 0, 30, 0, 136,
        135, 0, 27, 0, 0, 0, 136, 0, 0, 135, 0, 0, 0, 0, 0, 0, 0, 30, 0, 136,
        135, 0, 27, 145, 145, 145, 129, 0, 0, 130, 145, 145, 145, 145, 145, 145, 145, 30, 0, 136,
        135, 0, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 136,
        135, 0, 40, 41, 41, 45, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 136,
        135, 0, 0, 0, 0, 14, 37, 44, 42, 42, 42, 42, 42, 45, 0, 0, 30, 0, 0, 136,
        135, 0, 0, 0, 0, 40, 42, 43, 0, 0, 0, 0, 0, 40, 42, 42, 43, 0, 0, 136,
        130, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 145, 129
      }
    },
    {
      type = "objectgroup",
      id = 9, 
      name = "Interactions",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
          {
              id = 1, name = "playerStart", x = 4 * 16, y = 4 * 16, width = 16, height = 16,
              properties = { { name = "type", type = "string", value = "playerStart" } }
          },
          {
              id = 2, name = "levelExit", x = 14 * 16, y = 4 * 16, width = 16, height = 16,
              properties = { { name = "type", type = "string", value = "levelUp" } }
          },
          {
              id = 3, name = "mainDoor", x = 14 * 16, y = 3 * 16, width = 16, height = 16,
              properties = {
                  { name = "type", type = "string", value = "door" },
                  { name = "id", type = "string", value = "main_door" }
              }
          },
          {
              id = 4, name = "plateAlpha", x = 14 * 16, y = 12 * 16, width = 16, height = 16,
              properties = {
                  { name = "type", type = "string", value = "plate" },
                  { name = "targets", type = "string", value = "main_door" }
              }
          },
          {
              id = 5, name = "plateBeta", x = 15 * 16, y = 12 * 16, width = 16, height = 16,
              properties = {
                  { name = "type", type = "string", value = "plate" },
                  { name = "targets", type = "string", value = "main_door" }
              }
          },
          { id = 6, name="spike_a1", x = 8 * 16, y = 4 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_alpha" }} },
          { id = 7, name="spike_a2", x = 10 * 16, y = 4 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_alpha" }} },
          { id = 8, name="spike_a3", x = 13 * 16, y = 4 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_alpha" }} },
          { id = 9, name="spike_a4", x = 10 * 16, y = 5 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_alpha" }} },
          { id = 10, name="spike_a5", x = 11 * 16, y = 5 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_alpha" }} },
          { id = 11, name="spike_a6", x = 14 * 16, y = 5 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_alpha" }} },
          { id = 12, name="spike_b1", x = 7 * 16, y = 8 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_beta" }} },
          { id = 13, name="spike_b2", x = 8 * 16, y = 9 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_beta" }} },
          { id = 14, name="spike_b3", x = 11 * 16, y = 10 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_beta" }} },
          { id = 15, name="spike_b4", x = 13 * 16, y = 10 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_beta" }} },
          { id = 16, name="spike_b5", x = 15 * 16, y = 10 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_beta" }} },
          { id = 17, name="spike_b6", x = 10 * 16, y = 11 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_beta" }} },
          { id = 18, name="spike_b7", x = 12 * 16, y = 11 * 16, width=16, height=16, properties = {{ name = "type", type = "string", value = "spike" }, { name = "id", type = "string", value = "spike_group_beta" }} }
      }
  }
  }
}
