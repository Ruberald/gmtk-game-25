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
  nextlayerid = 6,
  nextobjectid = 1,
  properties = {},
  hintDelay = 10,
  hintDuration = 30,
  hints = {
      "Two buttons...?",
      "Maybe we could stand together.",
  },
  tilesets = {
    {
      name = "CosmicLilac_Tiles",
      firstgid = 1,
      filename = "./CosmicLilac_Tiles.tsx"
    },
    {
      name = "Sprites2",
      firstgid = 119,
      filename = "./Sprites2.tsx"
    },
    {
      name = "Space-bg",
      firstgid = 135,
      filename = "./Space-bg.tsx"
    },
    {
      name = "Interiors",
      firstgid = 199,
      filename = "./Interiors.tsx"
    },
    {
      name = "shiny_star",
      firstgid = 215,
      filename = "./shiny_star.tsx"
    },
    {
      name = "stars",
      firstgid = 217,
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
      id = 2,
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
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 163, 164, 165, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 215, 101, 101, 101, 101, 101, 101, 215, 171, 172, 215, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 179, 180, 181, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,
        101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      id = 3,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 33, 21, 21, 21, 21, 21, 21, 21, 21, 21, 34, 21, 0, 0, 0, 0,
        0, 0, 0, 0, 29, 29, 29, 29, 29, 29, 101, 101, 29, 101, 101, 101, 0, 0, 0, 0,
        0, 0, 0, 0, 29, 29, 29, 29, 29, 101, 29, 101, 29, 101, 101, 101, 0, 0, 0, 0,
        0, 0, 0, 0, 29, 29, 29, 29, 29, 29, 29, 101, 29, 29, 29, 29, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
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
      id = 4,
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
        44, 41, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 45,
        17, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 4, 0, 0, 14,
        17, 0, 0, 14, 15, 15, 15, 0, 0, 0, 0, 0, 0, 15, 15, 15, 17, 0, 0, 14,
        17, 0, 0, 14, 15, 15, 15, 0, 0, 0, 0, 0, 0, 15, 15, 15, 17, 0, 0, 14,
        17, 0, 0, 14, 15, 15, 15, 0, 0, 0, 0, 0, 0, 15, 15, 15, 17, 0, 0, 14,
        30, 0, 0, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0, 15, 17, 0, 0, 14,
        17, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43, 0, 0, 14,
        17, 0, 0, 14, 0, 0, 0, 0, 0, 0, 101, 101, 0, 101, 101, 101, 0, 0, 0, 14,
        17, 0, 0, 14, 0, 0, 0, 0, 0, 101, 0, 101, 0, 101, 101, 101, 0, 0, 0, 14,
        17, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 101, 0, 0, 0, 57, 0, 0, 0, 14,
        17, 0, 0, 40, 69, 71, 72, 73, 71, 72, 73, 101, 69, 69, 69, 70, 0, 0, 0, 14,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14,
        17, 0, 0, 0, 84, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14,
        30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27,
        19, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 18
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      id = 5,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 217, 67, 0,
        0, 0, 0, 0, 0, 12, 0, 119, 119, 119, 119, 119, 119, 0, 64, 0, 0, 0, 217, 0,
        0, 0, 0, 0, 0, 132, 0, 119, 119, 119, 119, 119, 119, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 131, 0, 119, 119, 119, 119, 119, 119, 20, 7, 20, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 66, 0, 0, 0, 0, 0, 0, 0, 31, 0, 31, 0, 0, 0, 0,
        0, 217, 0, 0, 0, 0, 0, 127, 0, 127, 127, 127, 0, 127, 0, 127, 0, 0, 0, 0,
        0, 0, 217, 0, 0, 28, 28, 127, 127, 127, 0, 0, 123, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 47, 0, 127, 127, 0, 120, 0, 48, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 199, 6, 6, 120, 0, 28, 28, 0, 0, 0, 0, 0, 0, 217, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 78, 78, 0, 0, 0, 217, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 217, 0, 0, 67, 0, 0, 0, 0, 217, 0, 0, 0, 0, 0, 0, 67, 0, 0, 0,
        0, 0, 217, 0, 0, 0, 0, 0, 217, 0, 0, 67, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      id = 6,
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
        44, 41, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 45,
        17, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 4, 0, 0, 14,
        17, 0, 0, 14, 15, 15, 15, 0, 0, 0, 0, 0, 0, 15, 15, 15, 17, 0, 0, 14,
        17, 0, 0, 14, 15, 15, 15, 0, 0, 0, 0, 0, 0, 15, 15, 15, 17, 0, 0, 14,
        17, 0, 0, 14, 15, 15, 15, 0, 0, 0, 0, 0, 0, 15, 15, 15, 17, 0, 0, 14,
        30, 0, 0, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0, 15, 17, 0, 0, 14,
        17, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43, 0, 0, 14,
        17, 0, 0, 14, 0, 0, 0, 0, 0, 0, 101, 101, 0, 101, 101, 101, 0, 0, 0, 14,
        17, 0, 0, 14, 0, 0, 0, 0, 0, 101, 0, 101, 0, 101, 101, 101, 0, 0, 0, 14,
        17, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 101, 0, 0, 0, 57, 0, 0, 0, 14,
        17, 0, 0, 40, 69, 71, 72, 73, 71, 72, 73, 101, 69, 69, 69, 70, 0, 0, 0, 14,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14,
        17, 0, 0, 0, 84, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14,
        30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27,
        19, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 18
      }
    },
     {
        type = "objectgroup",
        id = 7, 
        name = "Interactions",
        visible = true,
        opacity = 1,
        offsetx = 0,
        offsety = 0,
        draworder = "topdown",
        properties = {},
        objects = {
            {
                id = 1, name = "playerStart", x = 5 * 16, y = 6 * 16, width = 16, height = 16,
                properties = { { name = "type", type = "string", value = "playerStart" } }
            },
            {
                id = 2, name = "levelExit", x = 14 * 16, y = 6 * 16, width = 16, height = 16,
                properties = { { name = "type", type = "string", value = "levelUp" } }
            },
            {
                id = 3, name = "plateWest", x = 7 * 16, y = 9 * 16, width = 16, height = 16,
                properties = {
                    { name = "type", type = "string", value = "plate" },
                    { name = "targets", type = "string", value = "west_spikes" }
                }
            },
            {
                id = 4, name = "plateMiddle", x = 10 * 16, y = 8 * 16, width = 16, height = 16,
                properties = {
                    { name = "type", type = "string", value = "plate" },
                    { name = "targets", type = "string", value = "middle_spikes" }
                }
            },
            {
                id = 5, name = "buttonEast", x = 12 * 16, y = 7 * 16, width = 16, height = 16,
                properties = {
                    { name = "type", type = "string", value = "button" },
                    { name = "targets", type = "string", value = "east_spikes" }
                }
            },


            { id = 6, name="spike_w1", x = 7 * 16, y = 6 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "west_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },
            { id = 7, name="spike_w1", x = 7 * 16, y = 7 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "west_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },
            { id = 8, name="spike_w1", x = 7 * 16, y = 8 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "west_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },
            { id = 9, name="spike_w1", x = 8 * 16, y = 7 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "west_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },
            { id = 10, name="spike_w1", x = 8 * 16, y = 8 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "west_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },

            { id = 11, name="spike_m1", x = 9 * 16, y = 6 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "middle_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },
            { id = 12, name="spike_m1", x = 10 * 16, y = 6 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "middle_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },
            { id = 13, name="spike_m1", x = 11 * 16, y = 6 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "middle_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },
            { id = 13, name="spike_m1", x = 9 * 16, y = 7 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "middle_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },

            { id = 14, name="spike_e1", x = 13 * 16, y = 6 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "east_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },
            -- { id = 15, name="spike_e1", x = 14 * 16, y = 6 * 16, width=16, height=16, properties = {
            --     { name = "type", type = "string", value = "spike" },
            --     { name = "id", type = "string", value = "east_spikes" },
            --     { name = "alwaysOn", type = "bool", value = true }
            -- } },
            { id = 16, name="spike_e1", x = 15 * 16, y = 6 * 16, width=16, height=16, properties = {
                { name = "type", type = "string", value = "spike" },
                { name = "id", type = "string", value = "east_spikes" },
                { name = "alwaysOn", type = "bool", value = true }
            } },
        }
    }
  }
}
