-- #AI CODE
-- Maglev technology definition (unlocks maglev rail + locomotive).

local MAGLEV_TINT = {r = 0.2, g = 0.9, b = 1.0, a = 1}

local function tint_icons(proto, tint)
  if proto.icons then
    for _, icon in pairs(proto.icons) do
      icon.tint = tint
    end
    return
  end
  if proto.icon then
    proto.icons = {{
      icon = proto.icon,
      icon_size = proto.icon_size or 256,
      icon_mipmaps = proto.icon_mipmaps,
      tint = tint
    }}
    proto.icon = nil
  end
end

local base = data.raw["technology"]["railway"]
local tech = table.deepcopy(base)
tech.name = "maglev-railway"
tech.localised_name = {"technology-name.maglev-railway"}
tech.localised_description = {"technology-description.maglev-railway"}
if tech.unit then
  tech.unit.count = 500
end
tech.prerequisites = {"railway"}
tech.order = (base.order or "") .. "-maglev"
tech.effects = {
  {type = "unlock-recipe", recipe = "maglev-rail"},
  {type = "unlock-recipe", recipe = "maglev-locomotive"}
}

tint_icons(tech, MAGLEV_TINT)

data:extend({tech})
